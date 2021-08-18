# some functions for finding the inverse variance weighted beta and se estimates
ivw_beta <- function(snp_beta, snp_se) {
  # for one SNP, get inverse variance weighted beta estimate
  weights <- 1/(snp_se^2)
  beta_val <- sum(snp_beta*weights, na.rm = TRUE)/sum(weights, na.rm = TRUE)
  return(beta_val)
  
}

ivw_beta_all <- function(snp_beta, snp_se) {
  # for matrix of SNPs
  beta_vals <- sapply(1:nrow(snp_beta),
                      function(row) {
                        ivw_beta(snp_beta[row, ], snp_se[row, ])
                      } )
  return(beta_vals)
}

ivw_se <- function(snp_se) {
  # for one SNP, get inverse variance weighted se estimate
  weights <- 1/(snp_se^2)
  sum_weights_inv <- sum(1/weights, na.rm = TRUE)
  beta_est_se <- sqrt(sum_weights_inv)
  return(beta_est_se)
}

ivw_se_all <- function(snp_se) {
  # for matrix of SNPs
  ivw_se_vals <- apply(snp_se,
                       MARGIN=1,
                       FUN = ivw_se)
  return(ivw_se_vals)
}