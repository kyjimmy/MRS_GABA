## Clear Environment
rm(list=ls())

## Set Working Directory
#setwd ("/User/....")    

## Load Packages
suppressPackageStartupMessages({
  library(dplyr)
  library(lmerTest)
  library(readxl)
  library(purrr)
  library(ggplot2)
  library(ggpubr)
})

## Input spreadsheet. Obtained from Gannet software.
## Replaced with simulated data due to confidentiality
result_files <- "MRS_data.xlsx"

##### Preprocessing #####
## Remove outliers
results <- 
  map_df(result_files, function(f){
    read_excel(f)
  }) %>%
  filter(between(GABAFitError, 0, 20),
         between(GABAconcCr, 0, 1)) %>%
  mutate(weight = 1/GABAFitError^2)

## Relevel the variable "Diagnostic Group"
results %<>%
  filter(Dx %in% c("OCD", "ASD", "ADHD", "CTRL")) %>%
  mutate(Dx = relevel(factor(Dx), "CTRL")) 

## Gannet sometimes models the same scan with multiple outputs, therefore pick the one with the lowest error.
best_results <-
  results	%>% 
  group_by(Scan) %>% 
  filter(GABAFitError == min(GABAFitError)) %>%
  mutate(scan_age = Age_at_Scan_Days/365) %>%
  ungroup

## Optional. Group the "ASD", "OCD" and "ADHD" into one group "NDD"
# best_results$Dx <- as.character(best_results$Dx)
# best_results$Dx[best_results$Dx =="ASD"] <- "NDD"
# best_results$Dx[best_results$Dx =="OCD"] <- "NDD"
# best_results$Dx[best_results$Dx =="ADHD"] <- "NDD"

## Breakdown of participants 
grpnum1 <- plyr::count(best_results, c('Dx','Scanner'))
print(grpnum1)
grpnum2 <- plyr::count(best_results, c('Dx'))
print(grpnum2)
grpnum3 <- plyr::count(best_results, c('Dx','Gender'))
print(grpnum3)

##### Statistical Analysis (weighted linear mixed-effects regression model) #####

### Fit GABA+/Cr values ####
mod <- 
  lmer(GABAconcCr ~ Dx + scan_age + Gender + Scanner + File_type + (1|ID) 
       , data = best_results
       , weight = best_results$weight)
summary(mod)

#### Check for Error ####
mod2 <- 
  lmer(GABAFitError ~ Dx + scan_age + Gender + Scanner + File_type + (1|ID) 
       , data = best_results
       , weight = best_results$weight)
summary(mod2)

#### Visualize the between-group differences of GABA+/Cr values ####
best_results %>% 
  ggplot(aes(x = Dx, y = GABAconcCr)) + 
  geom_boxplot() + 
  facet_wrap(~ Scanner)

#### Fit GABA+/Cr values without the variable "Dx" to obtain residuals ####
resid_vals <- 
  lmer(GABAconcCr ~ scan_age + Gender + Scanner + File_type + (1|ID) 
       , data = best_results
       , weight = best_results$weight) %>%
  fitted

#### Visualize the residual values of each Dx group ####
best_results %>% 
  mutate(resid_vals = resid_vals) %>%
  ggplot(aes(x = Dx, y = resid_vals)) +
  geom_boxplot() + 
  facet_wrap(~ Scanner)

#### Scatterplot of Age and GABA+/Cr values ####
best_results %>%
  ggplot(aes(x = scan_age, y = GABAconcCr)) + geom_point()
facet_wrap(~ scanner)

####Scatterplot of Age and GABA+/Cr values by Diagnostics Group ####
sp <- ggscatter(best_results,x="scan_age",y="GABAconcCr", add ="reg.line" ,facet.by = "Dx",
                add.params = list(color = "blue", fill = "lightgray"),conf.int = TRUE)
sp + stat_cor(method = "pearson", label.x.npc = "right", label.y.npc = 0.7)

## Optional. Save the filtered dataframe into spreadsheet
# write.csv(best_results, file = "MRS_best_results.csv")