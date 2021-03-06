## Test the STTC

## if one train is empty, we get NaN.
expect_equal( sttc(1:5, double(0)), NaN)

context("Tiling coefficent should return 1 for autocorrelated trains.")

poisson.train <- function(n = 1000, rate = 1, beg = 0) {
  ## Generate a Poisson spike train with N spikes and firing rate RATE.
  ## BEG is time of start of recording
  ## Check that the histogram looks exponentially distributed.
  ## hist( diff(poisson.train()))
  x <- runif(n)
  isi <- log(x) / rate
  spikes <- beg - cumsum(isi)
  spikes
}

## Auto-correlations should be 1.

## Poisson spike train generated using the rule: t_i+1 = t_i -
## ln(x)/r, where x is drawn from Uniform distribuition and r is the
## rate.

## So in each case lets draw n=200 spikes from varying a rates.
n <-  5000
rates <- c(0.3, 1, 2, 5, 10)
for (r in rates) {
  t <- poisson.train(n, r, beg = 300)
  expect_equal( sttc(t, t), 1)
}

context("Tiling coefficent should return 0 for two independent Poisson trains.")

## We look at the distribution of many trials.  the tails of the
## distribution should still be close to zero.  Here we check that the
## 5% and 95% bins are less than 0.02 away from zero, and that they
## are opposite signs, so mirrored around zero.

tiling.ind <- function()  {
  n <- 3000; r <- 0.2
  ## Compute tiling for a pair of Poisson trains -- should be close to zero.
  a <- poisson.train(n, r, beg = 300)
  b <- poisson.train(n, r, beg = 300)
  sttc(a, b)
}

coefs <- replicate(1000, tiling.ind())
hist(coefs)
percentiles <- quantile(coefs, probs = c(0.05, 0.95))
expect_true(max(abs(percentiles)) < 0.02)
expect_true( prod(percentiles) < 0)     #check opposite signs.


context("Introducing some correlation between pairs of trains.")

tiling.shared <- function(p.shared = 0.6, n = 2000, r = 1) {
  master <- poisson.train(n, r)
  p.own <- (1-p.shared)/2
  p <- c( p.own, p.own, p.shared)
  ## Each spike is in one of three states with prob given by P vector above.
  ## 1: in train 1 only.
  ## 2: in train 2 only.
  ## 3: in both trains
  state <- sample(1:3, n, replace = TRUE, prob = p)
  a <- master[state != 2]
  b <- master[state != 1]
  sttc(a, b)
}

p.shared <- seq(from = 0, to = 1, length = 100)
coef <- sapply(p.shared, tiling.shared)
plot(p.shared, coef, pch = 20, main = 'This should monotonically increase')
expect_true( abs(coef[1]) < 0.1)
expect_equal( coef[length(coef)], 1)



context("Anti-correlated trains.")
tiling.anti <- function(dt = 0.05, n = 2000) {
  master <- seq(from = 0, by = 0.5, length = n)
  odd <- rep_len(c(TRUE, FALSE), n)
  a <- master[odd]
  b <- master[!odd]
  sttc(a,b,dt)
}

dts <- seq(from = 0.05, to = 1.0, length = 100)
dts <- c(0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0)
coeff <- sapply(dts, tiling.anti)
plot(dts, coeff, pch = 20, type = 'b')
## We get NaN for dt=0.5 and dt=1 second.

context("Symmetric calculation")
n <-  5000
rates <- c(0.3, 1, 2, 5, 10)
for (r in rates) {
  t1 <- poisson.train(n, r, beg = 300)
  t2 <- poisson.train(n, r, beg = 300)
  expect_equal( sttc(t1, t2), sttc(t2, t1))
}


context("Checking the rec_time works")

## Generate a pair of uncorrelated trains, a and b.
## Then make trains a' and b' by simply adding a constant Z to all times.
## then check that tiling(a,b) == tiling(a+z, b+z)
beg <- 0; end <- 2000; n <- 3000;
z <- 5000;                              #large offset for 2nd set of trains
for (i in seq_len(10)) {
  a <- sort(runif(n, beg, end))
  b <- sort(runif(n, beg, end))
  c1 <- sttc(a, b, rec_time = c(beg, end))
  c2 <- sttc(a+z, b+z, rec_time = z + c(beg, end))
  all.equal(c1, c2)
}

context("Pathological corner case with synthetic trains")
## This is when Pa=Tb=1 so both numerator and denominator are zero.
## What should we do about this case?  Unlikely to happen for
## realistic trains.
a <- 1; b <- 2                          # one spike in each time.
expect_equal(sttc(a, b, dt = 1, rec_time = c(0, 3)), 1)
expect_equal(sttc(a, b, dt = 1), NaN) #is this correct?!?


context("STTCP profile should be antisymmetric")

n <-  5000
rates <- c(0.3, 1, 2, 5, 10, 30)
for (r in rates) {
  t1 <- poisson.train(n, r, beg = 300)
  t2 <- poisson.train(n, r, beg = 300)
  expect_equal( sttcp(t1, t2)$y, rev(sttcp(t2, t1)$y))
}

context("STTCP autocorrelation should have peak at 1, ~0 elsewhere")
for (i in 1:100) {
  t1 <- poisson.train(5000, 10, beg = 300)
  y <- sttcp(t1, t1)$y
  middle <- (length(y)+1)/2
  expect_equal(y[middle], 1.0) # peak should equal 1 at tau=0
  y[middle] <- 0
  expect_true( all(abs(y) < 0.1)) # all other elements under threshold ~ 0.1
}

context("middle bin of sttcp() should equal sttp()")
for (i in 1:100) {
  t1 <- poisson.train(5000, 10, beg = 300)
  t2 <- poisson.train(5000, 10, beg = 300)
  y <- sttcp(t1, t2)$y
  middle <- (length(y)+1)/2
  c <- sttc(t1, t2)
  expect_equal(y[middle], c)
}
