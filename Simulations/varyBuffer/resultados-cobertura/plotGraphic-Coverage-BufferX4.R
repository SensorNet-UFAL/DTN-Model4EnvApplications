r1 <- 1:30

sc500 <- vector()
dr500 <- vector()
idealsc500 <- vector()
idealdr500 <- vector()

sc1000 <- vector()
dr1000 <- vector()
idealsc1000 <- vector()
idealdr1000 <- vector()

sc1500 <- vector()
dr1500 <- vector()
idealsc1500 <- vector()
idealdr1500 <- vector()

sc2000 <- vector()
dr2000 <- vector()
idealsc2000 <- vector()
idealdr2000 <- vector()

sc2500 <- vector()
dr2500 <- vector()
idealsc2500 <- vector()
idealdr2500 <- vector()

for(i in r1) {
	try(sc500[i] <- read.table(paste(i,"_50_500_coverage_SampleCentral.dat",sep=''))[[1]])
	try(dr500[i] <- read.table(paste(i,"_50_500_coverage_DropRandom.dat",sep=''))[[1]])
	try(idealsc500[i] <- read.table(paste(i,"_50_500_coverage_SampleCentral_Ideal.dat",sep=''))[[1]])
	try(idealdr500[i] <- read.table(paste(i,"_50_500_coverage_DropRandom_Ideal.dat",sep=''))[[1]])

	try(sc1000[i] <- read.table(paste(i,"_50_1000_coverage_SampleCentral.dat",sep=''))[[1]])
	try(dr1000[i] <- read.table(paste(i,"_50_1000_coverage_DropRandom.dat",sep=''))[[1]])
	try(idealsc1000[i] <- read.table(paste(i,"_50_1000_coverage_SampleCentral_Ideal.dat",sep=''))[[1]])
	try(idealdr1000[i] <- read.table(paste(i,"_50_1000_coverage_DropRandom_Ideal.dat",sep=''))[[1]])

	try(sc1500[i] <- read.table(paste(i,"_50_1500_coverage_SampleCentral.dat",sep=''))[[1]])
	try(dr1500[i] <- read.table(paste(i,"_50_1500_coverage_DropRandom.dat",sep=''))[[1]])
	try(idealsc1500[i] <- read.table(paste(i,"_50_1500_coverage_SampleCentral_Ideal.dat",sep=''))[[1]])
	try(idealdr1500[i] <- read.table(paste(i,"_50_1500_coverage_DropRandom_Ideal.dat",sep=''))[[1]])

	try(sc2000[i] <- read.table(paste(i,"_50_2000_coverage_SampleCentral.dat",sep=''))[[1]])
	try(dr2000[i] <- read.table(paste(i,"_50_2000_coverage_DropRandom.dat",sep=''))[[1]])
	try(idealsc2000[i] <- read.table(paste(i,"_50_2000_coverage_SampleCentral_Ideal.dat",sep=''))[[1]])
	try(idealdr2000[i] <- read.table(paste(i,"_50_2000_coverage_DropRandom_Ideal.dat",sep=''))[[1]])

	try(sc2500[i] <- read.table(paste(i,"_50_2500_coverage_SampleCentral.dat",sep=''))[[1]])
	try(dr2500[i] <- read.table(paste(i,"_50_2500_coverage_DropRandom.dat",sep=''))[[1]])
	try(idealsc2500[i] <- read.table(paste(i,"_50_2500_coverage_SampleCentral_Ideal.dat",sep=''))[[1]])
	try(idealdr2500[i] <- read.table(paste(i,"_50_2500_coverage_DropRandom_Ideal.dat",sep=''))[[1]])
}

sc500 <- sc500[!is.na(sc500)]
dr500 <- dr500[!is.na(dr500)]
idealsc500 <- idealsc500[!is.na(idealsc500)]
idealdr500 <- idealdr500[!is.na(idealdr500)]

sc1000 <- sc1000[!is.na(sc1000)]
dr1000 <- dr1000[!is.na(dr1000)]
idealsc1000 <- idealsc1000[!is.na(idealsc1000)]
idealdr1000 <- idealdr1000[!is.na(idealdr1000)]

sc1500 <- sc1500[!is.na(sc1500)]
dr1500 <- dr1500[!is.na(dr1500)]
idealsc1500 <- idealsc1500[!is.na(idealsc1500)]
idealdr1500 <- idealdr1500[!is.na(idealdr1500)]

sc2000 <- sc2000[!is.na(sc2000)]
dr2000 <- dr2000[!is.na(dr2000)]
idealsc2000 <- idealsc2000[!is.na(idealsc2000)]
idealdr2000 <- idealdr2000[!is.na(idealdr2000)]

sc2500 <- sc2500[!is.na(sc2500)]
dr2500 <- dr2500[!is.na(dr2500)]
idealsc2500 <- idealsc2500[!is.na(idealsc2500)]
idealdr2500 <- idealdr2500[!is.na(idealdr2500)]

######################################

# Obs.: Ideal Sample Central is always 100%, causing an "essentially constant error" in t.test
# Fixing it by adding manually the constant value to each slot in these cases using mean() instead

sc500 <- t.test(sc500)
dr500 <- t.test(dr500)
idealdr500 <- t.test(idealdr500)
idealsc500 <- mean(idealsc500) #

sc1000 <- t.test(sc1000)
dr1000 <- t.test(dr1000)
idealdr1000 <- t.test(idealdr1000)
idealsc1000 <- mean(idealsc1000) #

sc1500 <- t.test(sc1500)
dr1500 <- t.test(dr1500)
idealdr1500 <- t.test(idealdr1500)
idealsc1500 <- mean(idealsc1500) #

sc2000 <- t.test(sc2000)
dr2000 <- t.test(dr2000)
idealdr2000 <- t.test(idealdr2000)
idealsc2000 <- mean(idealsc2000) #

sc2500 <- t.test(sc2500)
dr2500 <- t.test(dr2500)
idealdr2500 <- t.test(idealdr2500)
idealsc2500 <- mean(idealsc2500) #

sc_tt <- rbind(
	c(sc500$conf.int[1], sc500$estimate , sc500$conf.int[2]),
	c(sc1000$conf.int[1], sc1000$estimate , sc1000$conf.int[2]),
	c(sc1500$conf.int[1], sc1500$estimate , sc1500$conf.int[2]),
	c(sc2000$conf.int[1], sc2000$estimate , sc2000$conf.int[2])
)

idealsc_tt <- rbind(
	c(idealsc500, idealsc500 , idealsc500),
	c(idealsc1000, idealsc1000 , idealsc1000),
	c(idealsc1500, idealsc1500 , idealsc1500),
	c(idealsc2000, idealsc2000 , idealsc2000)
)

dr_tt <- rbind(
	c(dr500$conf.int[1], dr500$estimate , dr500$conf.int[2]),
	c(dr1000$conf.int[1], dr1000$estimate , dr1000$conf.int[2]),
	c(dr1500$conf.int[1], dr1500$estimate , dr1500$conf.int[2]),
	c(dr2000$conf.int[1], dr2000$estimate , dr2000$conf.int[2])
)

idealdr_tt <- rbind(
	c(idealdr500$conf.int[1], idealdr500$estimate , idealdr500$conf.int[2]),
	c(idealdr1000$conf.int[1], idealdr1000$estimate , idealdr1000$conf.int[2]),
	c(idealdr1500$conf.int[1], idealdr1500$estimate , idealdr1500$conf.int[2]),
	c(idealdr2000$conf.int[1], idealdr2000$estimate , idealdr2000$conf.int[2])
)

# How many % sample central COVERAGE is higher than drop random
comparisonMatrix <- 1-(dr_tt/sc_tt) 
comparisonMatrixIdeal <- 1-(idealdr_tt/idealsc_tt)

write.csv(cbind(comparisonMatrix ,comparisonMatrixIdeal), file="Buffer-coverage (Comparison Matrix SC vs DR - Realistic and Ideal).csv")

##########################################################################
y_lim <- c(min(0,sc_tt, dr_tt, idealsc_tt, idealdr_tt), max(sc_tt, dr_tt, idealsc_tt, idealdr_tt))
x <- c(500,1000,1500,2000)

setEPS()
postscript("graphic_varyBufferCoverageX4.eps")

plot(x, sc_tt[,2] ,ylim=y_lim, type='b', pch=4, col='black', ylab='Coverage (%)', xlab='Buffer Size (Maximum amount of samples).', xaxt="n")
axis(1, at=x, labels=c("500","1000","1500","2000"))
legend("left", legend=c("Data-Aware Drop (Realistic)", "Data-Aware Drop (Ideal)", "Random Packet Drop (Realistic)","Random Packet Drop (Ideal)"), lty=c(1,2,4,5), col=c("black","blue", "red", "chartreuse4"), bty="n", pch=c(4,5,6,7))

matpoints(, sc_tt[,2],  pch = 4, col = 1, cex=1.2)
arrows(x, sc_tt[,1], x, sc_tt[,3], length = .05, angle = 90, code = 3) 
segments(x, sc_tt[,1], x, sc_tt[,3])
lines(1:length(x), sc_tt[,1], lty = 1, lwd = 1.5) 

points(x, idealsc_tt[,2], type='b', pch=5, col='blue', lty=2)
points(x, idealsc_tt[,1], type='p', pch="-", col='blue')
points(x, idealsc_tt[,3], type='p', pch="-", col='blue')
segments(x, idealsc_tt[,1], x, idealsc_tt[,3], col='blue')

points(x, dr_tt[,2], type='b', pch=6, col='red', lty=4)
points(x, dr_tt[,1], type='p', pch="-", col='red')
points(x, dr_tt[,3], type='p', pch="-", col='red')
segments(x, dr_tt[,1], x, dr_tt[,3], col='red')

points(x, idealdr_tt[,2], type='b', pch=7, col='chartreuse4', lty=5)
points(x, idealdr_tt[,1], type='p', pch="-", col='chartreuse4')
points(x, idealdr_tt[,3], type='p', pch="-", col='chartreuse4')
segments(x, idealdr_tt[,1], x, idealdr_tt[,3], col='chartreuse4')

dev.off()

