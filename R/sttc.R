##' Compute STTC for a pair of spike trains
##'
##' The Spike Time Tiling correlation (STTC) is computed for a pair
##' of spike trains.  The method is defined in Cutts and Eglen (2014).
##' 
##' @title Compute STTC for a pair of spike trains
##' @param a first spike train
##' @param b second spike train
##' @param dt bin size in seconds
##' @param rec_time 2-element vector: start and end time 
##' @return STTC a scalar bounded between -1 and +1.
##' @author Stephen J Eglen
##' @examples
##' a = c(1, 2, 3, 4, 5)
##' b = a+0.01
##' c = a+0.5
##' sttc(a, b)==1
##' sttc(a, c)==0
sttc <- function(a, b, dt = 0.05, rec_time = NULL) {
  if (is.null(rec_time)) {
    rec_time <- range(c(a, b))
  }
  run_TMcpp(dt, rec_time[1], rec_time[2], a, b)
}


##' Compute STTC profile for a pair of spike trains
##'
##' .. content for \details{} ..
##' @title 
##' @param a spike train 1
##' @param b spike train 2
##' @param dt time window for STTC
##' @param tau_max maximum time shift
##' @param tau_step step size in tau
##' @param beg start of recording. When NULL use the minimum spike time from
##' the two trains.
##' @param end end of recording.  When NULL use the maximum spike time from
##' the two trains.
##' @return List containing the STTC profile.
##' @author Stephen Eglen
sttcp <- function(a, b, dt = 0.05, tau_max = 5, tau_step = 0.1,
                  beg = NULL, end = NULL) {
  spikes <- c(a, b)
  nspikes <- c(length(a), length(b))
  first_spike <- cumsum(c(1, length(a)))
  if (is.null(beg))
    beg <- min(spikes)
  if (is.null(end))
    end <- max(spikes)
  
  res <- tiling_correlogramcpp_index(spikes, 2,
                               nspikes,
                               first_spike,
                               beg, end,
                               dt,
                               tau_step,
                               tau_max,
                               1,2)
  taus = seq(from=-tau_max, to=tau_max, by=tau_step)
  object = list(x=taus, y=res)
  class(object) <- "sttcp"
  object
}

plot.sttcp <- function(x) {
  plot(x$x, x$y, xlab="tau (s)", ylab='STTC', type='l')
}
