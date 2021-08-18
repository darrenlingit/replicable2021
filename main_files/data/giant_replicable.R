# libraries and other things
library(PRP)
library(rstudioapi)
library(mamba)
library(data.table)
library(parallel)
library(dplyr)

giant_replicable <- function(beta,
                             se,
                             prp_file,
                             prp_pval_file,
                             mamba_data_file,
                             prior_post = "posterior") {
  
  # list of effects and list of se
  # each item is a row from the data
  # leaves out NA values
  list_eff <- lapply(seq_len(nrow(beta)),
                    function(x) {
                      beta <- as.double(beta[x,])
                      beta <- beta[is.na(beta) == FALSE]
                      #beta <- beta[is.infinite(beta) == FALSE]
                    })
  
  list_se <- lapply(seq_len(nrow(se)),
                   function(x) {
                     se <- as.double(se[x,])
                     se <- se[is.na(se) == FALSE]
                     #se <- se[is.infinite(se) == FALSE]
                   })
  
  # PRP package functions
  if (prior_post == "posterior") {
    
    # fitting to posterior_prp function
    print("Now applying posterior_prp function.")
    post_prp_data = t(mapply(posterior_prp,
                             beta = list_eff,
                             se = list_se))
    
    post_prp_data <- as.data.frame(post_prp_data)
    
    post_prp_data_pval <- as.numeric(post_prp_data$pvalue)
    
    # saving prp data
    save(post_prp_data, file = prp_file)
    save(post_prp_data_pval, file = prp_pval_file)
    
  } else if (prior_post == "prior") {
    
    # fitting to prior_prp function
    print("Now applying prior_prp function.")
    prior_prp_data = t(mapply(prior_prp,
                              beta = list_eff,
                              se = list_se))
    
    prior_prp_data <- as.data.frame(prior_prp_data)
    
    prior_prp_data_pval <- as.numeric(prior_prp_data$pvalue)
    
    # saving prp data
    save(prior_prp_data, file = prp_file)
    save(prior_prp_data_pval, file = prp_pval_file)
    
  }
  
  
  
  # MAMBA fitting
  print("Now applying MAMBA library.")
  mamba_data <- mamba(beta, se^2)
  
  # saving mamba data
  save(mamba_data, file = mamba_data_file)
  
}
