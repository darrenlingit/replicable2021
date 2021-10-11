# R "job" files are used to create data used for analysis.
# It's not recommended you run these "job" files, since they take time.
# Download them from the link in the readme file instead.
set.seed(2021)
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source(file = "gen_prp_pval.R")
mamba_data_ppr_and_prp(noutlier_rate = 0.25)