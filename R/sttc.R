##' Compute STTC for a pair of spike trains
##'
##' The Spike Time Tiling correlation (STTC) is computed for a pair
##' of spike trains.  The method is defined in Cutts and Eglen (2014).
##' 
##' @title Compute STTC for a pair of spike trains
##' @param a first spike train
##' @param b second spike train
##' @param dt bin size in seconds
##' @param rec.time 2-element vector: start and end time 
##' @return STTC a scalar bounded between -1 and +1.
##' @author Stephen J Eglen
##' @examples
##' a = c(1, 2, 3, 4, 5)
##' b = a+0.01
##' c = a+0.5
##' sttc(a, b)==1
##' sttc(a, c)==0
sttc <- function(a, b, dt=0.05, rec.time=NULL) {
  if (is.null(rec.time)) {
    rec.time <- range(c(a, b))
  }
  run_TMcpp(dt, rec.time[1], rec.time[2], a, b)
}
