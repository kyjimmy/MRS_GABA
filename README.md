# MRS_GABA

### Description:
This project studys the cerebellar GABA+ values of children with neurodevelopmental disorders (NDD), including autism spectrum disorder (ASD), attention deficit hyperactivity disorder (ADHD) and paediatric obsessive compulsive disorder (OCD), and runs in R.

### Files:
"**MRS_data.xlsx**" provides the simulated GABA+ data and demographic information. The brain GABA+ levels were obtained through 1H-magnetic resonance spectroscopy (MRS) data acquired with a MEGA-PRESS (Mullins et al., 2014) spectral editing sequence, and processed using the Gannet software (Edden et al., 2014). 

"**run_stats.R**" cleans up the data and runs statistical analyses on edited magnetic resonance spectroscopy (MRS) data. 

• It conducts quality control by excluding scans with either GABA+ fit errors of greater than 15% or an implausible GABA+ fit value greater than one or less than zero. 

• After orgnaizing the data, it compares the GABA+ values across groups (ASD,ADHD,OCD,CTRL) using a weighted linear mixed-effects regression model controlling for age, sex, scanner and data format (TWIX or rda) with a random intercept for subject.

• Lastly, it visualizes the data using ggplot.




### References:

Edden RAE, Puts NAJ, Harris AD, Barker PB, Evans CJ. Gannet: A batch-processing tool for the quantitative analysis of gamma-aminobutyric acid-edited MR spectroscopy spectra. J. Magn. Reson. Imaging 2014;40:1445–1452. doi: 10.1002/jmri.24478

Mullins PG, McGonigle DJ, O’Gorman RL, Puts NAJ, Vidyasagar R, Evans CJ, Cardiff Symposium on MRS
of GABA, Edden RAE. (2014). Current practice in the use of MEGA-PRESS spectroscopy for the detection of
GABA. NeuroImage, 86, 43-52. Doi: 10.1016/j.neuroimage.2012.12.004.
