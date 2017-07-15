##' run the STTC code for a spike train (Cpp version)
##'
##' Internal computation
##' @title Compute STCC direct in Cpp
##' @param dt bin width for 
##' @param start start time in seconds
##' @param end end time in seconds
##' @param spike_times_1 spike train 1
##' @param spike_times_2 spike train 2
##' @return STTC value
##' @author Stephen Eglen
"run_TMcpp"

##' Compute STTC for all unique pairs of spike trains
##'
##' Return a matrix of all STTC values
##' @title Compute STTC for all pairs of spike trains
##' @param spikes List of spike trains
##' @param dt tiling window
##' @param beg start time
##' @param end end time
##' @return Matrix of STTC values.  Upper diagonal matrix only; diagonal
##' elements should be 1.  
##' @author Stephen Eglen
"sttc_allspikes1"


## I create the templates in this file by copying the function from
## RcppExports.R into here and then deleting them once I've got the template.
