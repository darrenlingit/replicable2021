# libraries and other things
set.seed(2021)

library(PRP)
library(rstudioapi)
library(mamba)
library(data.table)
library(parallel)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
outlier_rate = 0.5

# loading in or creating data
if (file.exists("../data/mamba_data_p50.rda") &&
    file.exists("../data/sim_mamba_mod_p50.rda") ) {
  
  load(file = "../data/mamba_data_p50.rda")
  load(file = "../data/sim_mamba_mod_p50.rda")
  
  snpeffect <- mamba_data_p50$betajk
  snpvar <- mamba_data_p50$sjk2
  
} else {
  # simulate data with MAMBA
  mamba_data_p50 <- generate_data_mamba(lambda = outlier_rate)
  save(mamba_data_p50, file = "../data/mamba_data_p50.rda")
  
  # save effects and variance
  snpeffect <- mamba_data_p50$betajk
  snpvar <- mamba_data_p50$sjk2
  
  # fit mamba model
  sim_mod_p50 <- mamba(betajk = snpeffect, sjk2 = snpvar)
  save(sim_mod_p50, file = "../data/sim_mamba_mod_p50.rda")
  
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
post_prp_data_p50 = t(mapply(posterior_prp,
                         beta = list_eff,
                         se = list_eff))

post_prp_data_p50 <- as.data.frame(post_prp_data_p50)

post_prp_data_pval_p50 <- as.numeric(post_prp_data_p50$pvalue)

post_prp_data_ch_p50 <- apply(post_prp_data_p50,
                              MARGIN = 2,
                              FUN = as.character)


save(post_prp_data_p50, file = "../data/post_prp_data_p50.rda")
save(post_prp_data_pval_p50, file = "../data/post_prp_data_pval_p50.rda")
write.csv(post_prp_data_ch_p50, "../data/post_prp_data_p50.csv", row.names = FALSE)