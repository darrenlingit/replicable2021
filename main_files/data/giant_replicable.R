# libraries and other things
library(PRP)
library(rstudioapi)
library(mamba)
library(data.table)
library(parallel)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

giant_replicable <- function(beta, se, prp_file, prp_pval_file, mamba_data_file) {
  # list of effects and list of se
  # each item is a row from the data
  # leaves out NA values
  list_eff = lapply(seq_len(nrow(beta)),
                    function(x) {
                      beta <- as.double(beta[x,])
                      beta <- beta[is.na(beta) == FALSE]
                    })
  
  list_se = lapply(seq_len(nrow(se)),
                   function(x) {
                     se <- as.double(se[x,])
                     se <- se[is.infinite(se) == FALSE]
                   })
  
  
  # fitting to posterior_prp function
  print("Now applying posterior_prp function.")
  post_prp_data = t(mapply(posterior_prp,
                           beta = list_eff,
                           se = list_se))
  
  post_prp_data <- as.data.frame(post_prp_data)
  
  post_prp_data_pval <- as.numeric(post_prp_data$pvalue)
  
  # now fitting mamba
  print("Now applying MAMBA library.")
  mamba_data <- mamba(beta, se^2)
  
  # saving data
  save(post_prp_data, file = prp_file)
  save(post_prp_data_pval, file = prp_pval_file)
  
  save(mamba_data, file = mamba_data_file)
  
}
