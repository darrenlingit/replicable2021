set.seed(2021)
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source(file = "giant_replicable.R")

load(file = "giant_bmi/bmi_beta.rda")
load(file = "giant_bmi/bmi_se.rda")


giant_replicable(beta = bmi_beta,
                 se = bmi_se,
                 prp_file = "giant_bmi/bmi_prp_file.rda",
                 prp_pval_file = "giant_bmi/bmi_prp_pval.rda",
                 mamba_data_file = "giant_bmi/bmi_mamba.rda")
