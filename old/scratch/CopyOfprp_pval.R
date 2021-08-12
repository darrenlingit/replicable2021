# libraries and other things
library(PRP)
library(rstudioapi)
library(mamba)
library(data.table)
library(parallel)

set.seed(2021)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

create_prp_data <- function(noutlier_rate = 0.975) {
  # text for names
  text_rate <- gsub("\\.", "", as.character(noutlier_rate*100))
  
  
  # loading in or creating data
  if (file.exists("../data/mamba_data.rda") &&
      file.exists("../data/sim_mamba_mod.rda") ) {
    
    load(file = "../data/mamba_data.rda")
    load(file = "../data/sim_mamba_mod.rda")
    
    
    assign(paste("effect", text_rate, sep = "_"), mamba_data$betajk)
    snpeffect <- mamba_data$betajk
    snpvar <- mamba_data$sjk2
    
  } else {
    # simulate data with MAMBA
    #mamba_data <- generate_data_mamba()
    
    noutlier_rate <- 0.25
    text_rate <- gsub("\\.", "", as.character(noutlier_rate*100))
    mamba_data <- paste("mamba_data_p",
                        text_rate,
                        sep = "")
    
    # assign(mamba_data,
    #        value = generate_data_mamba(lambda = noutlier_rate))
    
    test1 <- as.name(mamba_data)
    as.name(mamba_data) <- generate_data_mamba(lambda = noutlier_rate)
    save(eval(parse(text = "mamba_data")),
         file = paste("../data/mamba_data_p",
                                  text_rate,
                                  ".rda",
                                  sep = ""))

    
    # save effects and variance
    snpeffect <- mamba_data$betajk
    snpvar <- mamba_data$sjk2
    
    # fit mamba model
    sim_mod <- mamba(betajk = snpeffect, sjk2 = snpvar)
    save(sim_mod, file = "../data/sim_mamba_mod.rda")
    
  }
  
  
  # list of effects and list of se
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
                           se = list_eff))
  
  post_prp_data <- as.data.frame(post_prp_data)
  
  post_prp_data_pval <- as.numeric(post_prp_data$pvalue)
  
  post_prp_data_ch <- apply(post_prp_data,
                            MARGIN = 2,
                            FUN = as.character)
  
  
  save(post_prp_data, file = "../data/post_prp_data.rda")
  save(post_prp_data_pval, file = "../data/post_prp_data_pval.rda")
  write.csv(post_prp_data_ch, "../data/post_prp_data.csv", row.names = FALSE)
  
}


