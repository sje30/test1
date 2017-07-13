.spikes.to.count3 <- function(spikes,
                            time.interval=1, #time bin of 1sec.
                            beg=floor(min(unlist(spikes))),
                            end=ceiling(max(unlist(spikes)))
                            )
{
  ## Convert the spikes for each cell into a firing rate (in Hz)
  ## We count the number of spikes within time bins of duration
  ## time.interval (measured in seconds).
  ##
  ## Currently cannot specify BEG or END as less than the
  ## range of spike times else you get an error from hist().  The
  ## default anyway is to do all the spikes within a data file.
  ##
  ## C version, which should replace spikes.to.count
  ## Returns a time series object.

  ## Each bin is of the form [t, t+dt) I believe, as shown by:
  ## .spikes.to.count3(list( c(0, 6.9), c( 2, 4)))
  
  ## time.breaks <- seq(from=beg, to=end, by=time.interval)
  nbins <- ceiling( (end-beg) / time.interval)

  nspikes <- sapply(spikes, length)     #already computed elsewhere!
  count = count_ns(spikes, beg, end, time.interval, nbins)

  ## Return counts as a time series.
  res <- ts(data=count, start=beg, deltat=time.interval)

  res
}
