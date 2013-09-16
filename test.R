library(testthat)
source("SABR.R")
test_that("SBAR model test", {
  k <- c(12.0, 15.0, 17.0, 19.5, 20.0, 22.0, 22.5,24.5, 25.0,27.0, 27.5, 29.5, 30.0, 32.0, 32.5, 34.5, 37.0)
  iv <- c(0.346,0.280, 0.243, 0.208, 0.203, 0.192, 0.192, 0.201, 0.205, 0.223, 0.228, 0.247, 0.252, 0.271, 0.275, 0.293, 0.313) 
  f <- 22.724
  t <- 0.583
  a <- 0.317
  b <- 0.823
  r <- 0.111
  n <- 1.050
  iv.model <- SABR.BSIV(t, f, k, a, b, r, n)
  params <- SABR.calibration(t, f, k, iv)
  iv.calibrated <- SABR.BSIV(t, f, k, params[1], params[2], params[3], params[4])
  # check wether initial model can produce market IV or not.
  for(i in length(k)){expect_equal(iv.model[i],      iv[i], tolerance=0.01*iv[i])}
  # check wether calibrated parameter can produce market IV or not.
  for(i in length(k)){expect_equal(iv.calibrated[i], iv[i], tolerance=0.01*iv[i])}
})