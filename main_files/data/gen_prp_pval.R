# libraries and other things
library(PRP)
library(rstudioapi)
library(mamba)
library(data.table)
library(parallel)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

mamba_data_ppr_and_prp <- function(noutlier_rate = 0.975) {
  # Generates data from MAMBA package
  # Input takes an nonoutlier rate, the rate that generated studies are not outliers
  # Then computes the PPR values from the MAMBA and PRP values from PPR package
  

  # text for names
  text_rate <- gsub("\\.", "", as.character(noutlier_rate*100))
  
  # mamba files we need
  # create if they don't exist
  mamba_data_file <- paste("mamba_data/mamba_data_p",
                           text_rate,
                           ".rda",
                           sep = "")
  # simulated mamba data file name
  sim_mamba_mod_file <- paste("mamba_data/sim_mamba_mod_p",
                              text_rate,
                              ".rda",
                              sep = "")
  
  # files we want to save data/results to
  post_prp_data_file <- paste("prp_data/post_prp_data",
                              text_rate,
                              ".rda",
                              sep = "")
  post_prp_data_pval_file <- paste("prp_data/post_prp_data_pval_p",
                                   text_rate,
                                   ".rda",
                                   sep = "")
  
  post_prp_data_ch_file <- paste("prp_data/post_prp_data_p",
                                 text_rate,
                                 ".rda",
                                 sep = "")
  
  
  # loading in or creating data
  if (file.exists(mamba_data_file) &&
      file.exists(sim_mamba_mod_file) ) {
    
    load(file = mamba_data_file)
    load(file = sim_mamba_mod_file)
    
    snpeffect <- mamba_data$betajk
    snpvar <- mamba_data$sjk2
    
  } else {
    # simulate data with MAMBA
    mamba_data <- generate_data_mamba(lambda = noutlier_rate)
    
    save(mamba_data,
         file = mamba_data_file)
    
    
    # save effects and variance
    snpeffect <- mamba_data$betajk
    snpvar <- mamba_data$sjk2
    
    # fit mamba model
    sim_mod <- mamba(betajk = snpeffect, sjk2 = snpvar)
    save(sim_mod,
         file = sim_mamba_mod_file)
    
  }
  
  
  # list of effects and list of standard errors
  # each item is a row from the data
  list_eff = lapply(seq_len(nrow(snpeffect)),
                    function(x) {
                      snpeffect[x,]
                    })
  list_se = lapply(seq_len(nrow(snpvar)),
                   function(x) {
                     sqrt(snpvar[x,])
                   })
  
  
  # fitting to posterior_prp function
  print("Now applying posterior_prp function.")
  post_prp_data = t(mapply(posterior_prp,
                           beta = list_eff,
                           se = list_se))
  
  post_prp_data <- as.data.frame(post_prp_data)
  
  post_prp_data_pval <- as.numeric(post_prp_data$pvalue)
  
  post_prp_data_ch <- apply(post_prp_data,
                            MARGIN = 2,
                            FUN = as.character)
  
  
  
  # saving data to respective folders
  save(post_prp_data, file = post_prp_data_file)
  save(post_prp_data_pval, file = post_prp_data_pval_file)
  #write.csv(post_prp_data_ch, post_prp_data_ch_file, row.names = FALSE)
  
}

# an example of the function
#mamba_data_ppr_and_prp(noutlier_rate = 0.975)
