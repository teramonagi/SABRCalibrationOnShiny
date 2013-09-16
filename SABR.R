# CONSTANT
EPS <- 10^(-8)

# sub function for SABR BS-IV
.x <- function(z, r){log((sqrt(1-2*r*z+z^2)+z-r)/(1-r))}
.z <- function(f, K, a, b, nu){nu/a*(f*K)^(0.5*(1-b))*log(f/K)}

# variable transformation function
.t1  <- function(x){1/(1+exp(x))}
.t2  <- function(x){2/(1+exp(x)) -1}

# Black-Scholes IV apporoximation formula by Hagan(2002)
SABR.BSIV <- function(t, f, K, a, b, r, n)
{
  z <- .z(f, K, a, b, n)
  x <- .x(z, r)
  numerator   <- 1 + ((1-b)^2/24*a^2/(f*K)^(1-b) + 0.25*r*b*n*a/(f*K)^(0.5*(1-b)) + (2-3*r^2)*n^2/24)*t
  denominator <- x*(f*K)^(0.5*(1-b))*(1 + (1-b)^2/24*(log(f/K))^2 + (1-b)^4/1920*(log(f/K))^4)
  ifelse(abs((f-K)/f) < EPS, a*numerator/f^(1-b), z*a*numerator/denominator)
}

# Parameter calibration function for SABR
SABR.calibration <- function(t, f, K, iv)
{
  # objective function for optimization
  # variables are transformed because of satisfing the constraint conditions
  objective <- function(x){sum( (iv - SABR.BSIV(t, f, K, exp(x[1]), .t1(x[2]), .t2(x[3]), exp(x[4])))^2) }
  x <- nlm(objective, c(0.1, 0.5, 0.0, 0.1))
  # return the optimized parameters
  parameter <- x$estimate
  parameter <- c(exp(parameter[1]), .t1(parameter[2]), .t2(parameter[3]), exp(parameter[4]))
  names(parameter) <- c("Alpha", "Beta", "Rho", "Nu")
  parameter
}