# libraries and other things
library(PRP)
library(rstudioapi)
library(mamba)
library(data.table)
library(parallel)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

set.seed(2021)


# loading in or creating data
if (file.exists("../data/mamba_data.rda") &&
    file.exists("../data/sim_mamba_mod.rda") ) {
  
  load(file = "../data/mamba_data.rda")
  load(file = "../data/sim_mamba_mod.rda")
  
  snpeffect <- mamba_data$betajk
  snpvar <- mamba_data$sjk2
  
} else {
  # simulate data with MAMBA
  mamba_data <- generate_data_mamba()
  save(mamba_data, file = "../data/mamba_data.rda")
  
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