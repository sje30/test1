##devtools::install_github("sje30/test1")
require(test1)
require(devtools)
require(sjemea)


data.file <- system.file("examples", "P9_CTRL_MY1_1A.txt",
                         package = "sjemea")
sj <- jay.read.spikes( data.file)
s = sj

dt = 0.05; beg = s$rec.time[1]; end = s$rec.time[2]
o1 = sttc_allspikes1(s$spikes, dt, beg, end)
o2 = tiling.allpairwise(s, dt)
all.equal(o1, o2)


## test the frate_counts - working.t
c1 = make.spikes.to.frate(s$spikes)
c2 = make.spikes.to.frate2(s$spikes)
all.equal(c1, c2)


## isn't network spikes just the same calculation???

data.file <- system.file("examples", "TC89_DIV15_A.nexTimestamps",
                         package = "sjemea")
s <- sanger.read.spikes( data.file)
s$ns <- compute.ns(s, ns.T=0.003, ns.N=10,sur=100)
  
plot(s$ns$mean, xlab='Time (s)', ylab='Count', main='Mean NS')



######################################################################


.spikes.to.count3(list( c(0, 6.9), c( 2, 4)))
sjemea::spikes.to.count2(list( c(0, 6.9), c( 2, 4)))

spikes1 = s$spikes
o1 = .spikes.to.count3(spikes1)
o2 = sjemea::spikes.to.count2(spikes1)
all.equal(o1, o2)


spikes1 = sj$spikes
all.equal(.spikes.to.count3(spikes1), sjemea::spikes.to.count2(spikes1))


######################################################################

tilingcpp<-tiling_correlogramcpp(unlist(s$spikes),length(s$channels),
                                                s$nspikes,cumsum(c(1,s$nspikes[-length(s$nspikes)])),
                                                s$rec.time[1],s$rec.time[2],0.05,0.1,5)

res <- sttcp(s$spikes[[12]], s$spikes[[15]], beg=s$rec.time[1],
             end=s$rec.time[2])
plot(res)

plot(sttcp(s$spikes[[5]], s$spikes[[10]]))

par(mfrow=c(2,3),las=1)
for(i in 1:6) {
  plot(sttcp(s$spikes[[19]], s$spikes[[4+i]], tau_max=20))
}

#x1=7;x2=12
x1=19;x2=11
delta = 0
beg = s$rec.time[1] - delta
end = s$rec.time[2] + delta
o1 = sttcp(s$spikes[[x1]], s$spikes[[x2]], tau_max=3, beg=beg, end=end)$y
sttc(s$spikes[[x1]], s$spikes[[x2]], rec_time = c(beg, end))
o2 = sttcp(s$spikes[[x2]], s$spikes[[x1]], tau_max=3, beg=beg, end=end)$y

diff = o1 - rev(o2)
plot(diff)
all.equal(o1, rev(o2))

plot(o1)

## be careful about step size in ab -- helps to be "exact" in binary
## floating point representation.
o1 = sttcp_ab(s$spikes[[x1]], s$spikes[[x2]], beg, end, 0.05, 1/64, 20)
o2 = sttcp_ab(s$spikes[[x2]], s$spikes[[x1]], beg, end, 0.05, 1/64, 20)
diff = abs(o1 - rev(o2))
plot(diff)
all.equal(o1, rev(o2))
