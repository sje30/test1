# test1

This package is a testing ground for converting the C code from sjemea
over to RCpp.  This is non-trivial, as it seems that I cannot include
C code written in the .C() style with RCpp code.

The C functions are used in several parts of sjemea, and I plan to
convert them over one-by-one.  Here is where the .C() interface is
currently used in meaRtools

```
corrIndex.R:    z <- .C("count_overlap_arr",
corrIndex.R:  z <- .C("tiling_arr",
networkspikes.R:  z <- .C("ns_count_activity",
spikes.R:  z <- .C("frate",
```



