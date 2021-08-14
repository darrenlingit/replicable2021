set.seed(2021)
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source(file = "giant_replicable.R")

load(file = "giant_meta/meta_beta.rda")
load(file = "giant_meta/meta_se.rda")

giant_replicable(beta = meta_beta,
                 se = meta_se,
                 prp_file = "giant_meta/meta_prp_file.rda",
                 prp_pval_file = "giant_meta/meta_prp_pval.rda",
                 mamba_data_file = "giant_meta/meta_mamba.rda",
                 prior_post = "prior")
