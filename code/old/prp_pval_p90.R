# libraries and other things
set.seed(2021)

library(PRP)
library(rstudioapi)
library(mamba)
library(data.table)
library(parallel)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
outlier_rate = 0.90

# loading in or creating data
if (file.exists("../data/mamba_data_p90.rda") &&
    file.exists("../data/sim_mamba_mod_p90.rda") ) {
  
  load(file = "../data/mamba_data_p90.rda")
  load(file = "../data/sim_mamba_mod_p90.rda")
  
  snpeffect <- mamba_data_p90$betajk
  snpvar <- mamba_data_p90$sjk2
  
} else {
  # simulate data with MAMBA
  mamba_data_p90 <- generate_data_mamba(lambda = outlier_rate)
  save(mamba_data_p90, file = "../data/mamba_data_p90.rda")
  
  # save effects and variance
  snpeffect <- mamba_data_p90$betajk
  snpvar <- mamba_data_p90$sjk2
  
  # fit mamba model
  sim_mod_p90 <- mamba(betajk = snpeffect, sjk2 = snpvar)
  save(sim_mod_p90, file = "../data/sim_mamba_mod_p90.rda")
  
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
post_prp_data_p90 = t(mapply(posterior_prp,
                         beta = list_eff,
                         se = list_eff))

post_prp_data_p90 <- as.data.frame(post_prp_data_p90)

post_prp_data_pval_p90 <- as.numeric(post_prp_data_p90$pvalue)

post_prp_data_ch_p90 <- apply(post_prp_data_p90,
                              MARGIN = 2,
                              FUN = as.character)


save(post_prp_data_p90, file = "../data/post_prp_data_p90.rda")
save(post_prp_data_pval_p90, file = "../data/post_prp_data_pval_p90.rda")
write.csv(post_prp_data_ch_p90, "../data/post_prp_data_p90.csv", row.names = FALSE)