set.seed(2021)
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source(file = "giant_replicable.R")

load(file = "giant_height/height_beta.rda")
load(file = "giant_height/height_se.rda")

giant_replicable(beta = height_beta,
                 se = height_se,
                 prp_file = "giant_height/height_prp_file.rda",
                 prp_pval_file = "giant_height/height_prp_pval.rda",
                 mamba_data_file = "giant_height/height_mamba.rda")
