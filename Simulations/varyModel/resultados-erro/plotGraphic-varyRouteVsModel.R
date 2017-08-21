r1 <- 1:30

sc500 <- vector()
dr500 <- vector()

sc1000 <- vector()
dr1000 <- vector()

sc1500 <- vector()
dr1500 <- vector()

sc2000 <- vector()
dr2000 <- vector()

for(i in r1) {

	try(sc500[i] <- read.table(paste(i,"_50_0_erroReconstrucao_SampleCentral_Ideal.dat",sep=''))[[1]]) # Sweep-Grid, Ideal, No event
	try(dr500[i] <- read.table(paste(i,"_50_0_erroReconstrucao_DropRandom_Ideal.dat",sep=''))[[1]]) # Sweep-Grid, Ideal, No event

	try(sc1000[i] <- read.table(paste(i,"_50_1_erroReconstrucao_SampleCentral_Ideal.dat",sep=''))[[1]]) # Sweep-Grid, Ideal, With event
	try(dr1000[i] <- read.table(paste(i,"_50_1_erroReconstrucao_DropRandom_Ideal.dat",sep=''))[[1]]) # Sweep-Grid, Ideal, With event

	try(sc1500[i] <- read.table(paste(i,"_50_0_erroReconstrucao_SampleCentral.dat",sep=''))[[1]])  # Random Walk, Realistic, No event 
	try(dr1500[i] <- read.table(paste(i,"_50_0_erroReconstrucao_DropRandom.dat",sep=''))[[1]]) # Random Walk, Realistic, No event 

	try(sc2000[i] <- read.table(paste(i,"_50_1_erroReconstrucao_SampleCentral.dat",sep=''))[[1]]) # Random Walk, Realistic, With event
	try(dr2000[i] <- read.table(paste(i,"_50_1_erroReconstrucao_DropRandom.dat",sep=''))[[1]]) # Random Walk, Realistic, With event
}

sc500 <- sc500[!is.na(sc500)]*100 # Quick fix (temporary)
dr500 <- dr500[!is.na(dr500)]*100 # Quick fix (temporary)

sc1000 <- sc1000[!is.na(sc1000)]*100 # Quick fix (temporary)
dr1000 <- dr1000[!is.na(dr1000)]*100 # Quick fix (temporary)

sc1500 <- sc1500[!is.na(sc1500)]*100
dr1500 <- dr1500[!is.na(dr1500)]*100

sc2000 <- sc2000[!is.na(sc2000)]*100
dr2000 <- dr2000[!is.na(dr2000)]*100


######################################

sc500 <- t.test(sc500)
dr500 <- t.test(dr500)

sc1000 <- t.test(sc1000)
dr1000 <- t.test(dr1000)

sc1500 <- t.test(sc1500)
dr1500 <- t.test(dr1500)

sc2000 <- t.test(sc2000)
dr2000 <- t.test(dr2000)

sc_tt <- rbind(
	c(sc500$conf.int[1], sc500$estimate , sc500$conf.int[2]),
	c(sc1000$conf.int[1], sc1000$estimate , sc1000$conf.int[2]),
	c(sc1500$conf.int[1], sc1500$estimate , sc1500$conf.int[2]),
	c(sc2000$conf.int[1], sc2000$estimate , sc2000$conf.int[2])
)

dr_tt <- rbind(
	c(dr500$conf.int[1], dr500$estimate , dr500$conf.int[2]),
	c(dr1000$conf.int[1], dr1000$estimate , dr1000$conf.int[2]),
	c(dr1500$conf.int[1], dr1500$estimate , dr1500$conf.int[2]),
	c(dr2000$conf.int[1], dr2000$estimate , dr2000$conf.int[2])
)

comparisonMatrix <- 1-(sc_tt/dr_tt) # How many % sample central is lower than drop random

write.csv(comparisonMatrix, file="Buffer-model (Comparison Matrix SC vs DR).csv")

##########################################################################

#function for error bars
error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
   if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
   stop("vectors must be same length")
   arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length, ...)
}

##########################################################################

setEPS()
postscript("graphic_varyModel.eps")

d <- data.frame(sc=sc_tt[,2], dr=dr_tt[,2] ,row.names=c("INE","IWE","RNE","RWE")) 
d<-do.call(rbind, d)

stdevs <- matrix(nrow=2, ncol=4)
means <- matrix(nrow=2, ncol=4)

stdevs[1,] <- sc_tt[,3]-sc_tt[,2]
stdevs[2,] <- dr_tt[,3]-dr_tt[,2]

means[1,] <- sc_tt[,2]
means[2,] <- dr_tt[,2]

bp <- barplot(d, beside = TRUE, ylim=c(0,100), names.arg=c("Ideal, No Event.","Ideal, With Event.","Real, No Event.","Real, With Event."), legend.text = c("Data-Aware Drop","Random Packet Drop"), args.legend = list(x = "topleft", bty="n"), col=c("gray80","cyan4"), ylab="Error (%)", xlab="Buffer Size")

error.bar(bp, means, stdevs)

dev.off()
