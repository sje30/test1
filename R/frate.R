make.spikes.to.frate2 <- function(spikes,
                                 time.interval=1, #time bin of 1sec.
                                 frate.min=0,
                                 frate.max=20,
                                 clip=FALSE,
                                 beg=NULL,
                                 end=NULL
                                 ) {
  ## Convert the spikes for each cell into a firing rate (in Hz)
  ## We count the number of spikes within time bins of duration
  ## time.interval (measured in seconds).
  ##
  ## Currently cannot specify BEG or END as less than the
  ## range of spike times else you get an error from hist().  The
  ## default anyway is to do all the spikes within a data file.

  ## Note, we need to check for when there are no spikes; this can
  ## happen when examining a subset of spikes, e.g. a well in a multi-well
  ## plate that was not working.
  ## r <- make.spikes.to.frate(list(), beg=100, end=200, clip=TRUE)
  nspikes <- lapply(spikes, length)
  nelectrodes <- length(nspikes)
  
  ## if clips is set to TRUE, firing rate is clipped within the
  ## values frate.min and frate.max.  This is problably not needed.
  
  spikes.range <- range(unlist(spikes))
  if (is.null(beg))  beg <-  spikes.range[1]
  if (is.null(end))  end <-  spikes.range[2]
  
  time.breaks <- seq(from=beg, to=end, by=time.interval)
  if (time.breaks[length(time.breaks)] <= end) {
    ## extra time bin needs adding.
    ## e.g seq(1,6, by = 3) == 1 4, so we need to add 7 ourselves.
    time.breaks <- c(time.breaks,
                     time.breaks[length(time.breaks)]+time.interval)
   }
  nbins <- length(time.breaks) - 1

  rates <- frate_counts(spikes, time.breaks[1], time.breaks[nbins], time.interval, nbins)

  ## Check if there are any electrodes to process.
  if (nelectrodes > 0) {
    ## Now optionally set the upper and lower frame rates if clip is TRUE.
    if (clip)
      rates <- pmin(pmax(rates, frate.min), frate.max)

    ## Do the average computation here.
    ## av.rate == average rate across the array.
    av.rate <- apply(rates, 1, mean)
  } else {
    av.rate <- rep(NA, nbins)
  }
  ## We can remove the last "time.break" since it does not correspond
  ## to the start of a time frame.
  res <- list(rates=rates,
              times=time.breaks[-length(time.breaks)],
              av.rate=av.rate,
              time.interval=time.interval)
  res
}
