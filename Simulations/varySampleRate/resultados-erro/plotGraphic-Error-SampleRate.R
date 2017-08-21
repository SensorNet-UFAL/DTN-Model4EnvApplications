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

for(i in r1) {
	try(sc500[i] <- read.table(paste(i,"_10_500_erroReconstrucao_SampleCentral.dat",sep=''))[[1]])
	try(sc1000[i] <- read.table(paste(i,"_10_1000_erroReconstrucao_SampleCentral.dat",sep=''))[[1]])
	try(sc1500[i] <- read.table(paste(i,"_10_1500_erroReconstrucao_SampleCentral.dat",sep=''))[[1]])
	try(sc2000[i] <- read.table(paste(i,"_10_2000_erroReconstrucao_SampleCentral.dat",sep=''))[[1]])

	try(dr500[i] <- read.table(paste(i,"_25_500_erroReconstrucao_SampleCentral.dat",sep=''))[[1]])
	try(dr1000[i] <- read.table(paste(i,"_25_1000_erroReconstrucao_SampleCentral.dat",sep=''))[[1]])
	try(dr1500[i] <- read.table(paste(i,"_25_1500_erroReconstrucao_SampleCentral.dat",sep=''))[[1]])
	try(dr2000[i] <- read.table(paste(i,"_25_2000_erroReconstrucao_SampleCentral.dat",sep=''))[[1]])

	try(idealsc500[i] <- read.table(paste(i,"_50_500_erroReconstrucao_SampleCentral.dat",sep=''))[[1]])
	try(idealsc1000[i] <- read.table(paste(i,"_50_1000_erroReconstrucao_SampleCentral.dat",sep=''))[[1]])
	try(idealsc1500[i] <- read.table(paste(i,"_50_1500_erroReconstrucao_SampleCentral.dat",sep=''))[[1]])
	try(idealsc2000[i] <- read.table(paste(i,"_50_2000_erroReconstrucao_SampleCentral.dat",sep=''))[[1]])

	try(idealdr500[i] <- read.table(paste(i,"_5_500_erroReconstrucao_DropRandom.dat",sep=''))[[1]])
	try(idealdr1000[i] <- read.table(paste(i,"_5_1000_erroReconstrucao_DropRandom.dat",sep=''))[[1]])
	try(idealdr1500[i] <- read.table(paste(i,"_5_1500_erroReconstrucao_DropRandom.dat",sep=''))[[1]])
	try(idealdr2000[i] <- read.table(paste(i,"_5_2000_erroReconstrucao_DropRandom.dat",sep=''))[[1]])
}

# Multiplying by 100 to show in % notation

sc500 <- sc500[!is.na(sc500)]*100
dr500 <- dr500[!is.na(dr500)]*100
idealsc500 <- idealsc500[!is.na(idealsc500)]*100
idealdr500 <- idealdr500[!is.na(idealdr500)]*100

sc1000 <- sc1000[!is.na(sc1000)]*100
dr1000 <- dr1000[!is.na(dr1000)]*100
idealsc1000 <- idealsc1000[!is.na(idealsc1000)]*100
idealdr1000 <- idealdr1000[!is.na(idealdr1000)]*100

sc1500 <- sc1500[!is.na(sc1500)]*100
dr1500 <- dr1500[!is.na(dr1500)]*100
idealsc1500 <- idealsc1500[!is.na(idealsc1500)]*100
idealdr1500 <- idealdr1500[!is.na(idealdr1500)]*100

sc2000 <- sc2000[!is.na(sc2000)]*100
dr2000 <- dr2000[!is.na(dr2000)]*100
idealsc2000 <- idealsc2000[!is.na(idealsc2000)]*100
idealdr2000 <- idealdr2000[!is.na(idealdr2000)]*100

######################################

sc500 <- t.test(sc500)
dr500 <- t.test(dr500)
idealdr500 <- t.test(idealdr500)
idealsc500 <- t.test(idealsc500) #

sc1000 <- t.test(sc1000)
dr1000 <- t.test(dr1000)
idealdr1000 <- t.test(idealdr1000)
idealsc1000 <- t.test(idealsc1000) #

sc1500 <- t.test(sc1500)
dr1500 <- t.test(dr1500)
idealdr1500 <- t.test(idealdr1500)
idealsc1500 <- t.test(idealsc1500) #

sc2000 <- t.test(sc2000)
dr2000 <- t.test(dr2000)
idealdr2000 <- t.test(idealdr2000)
idealsc2000 <- t.test(idealsc2000) #

sc_tt <- rbind( # 10%
	c(sc500$conf.int[1], sc500$estimate , sc500$conf.int[2]),
	c(sc1000$conf.int[1], sc1000$estimate , sc1000$conf.int[2]),
	c(sc1500$conf.int[1], sc1500$estimate , sc1500$conf.int[2]),
	c(sc2000$conf.int[1], sc2000$estimate , sc2000$conf.int[2])
)

dr_tt <- rbind( # 25%
	c(dr500$conf.int[1], dr500$estimate , dr500$conf.int[2]),
	c(dr1000$conf.int[1], dr1000$estimate , dr1000$conf.int[2]),
	c(dr1500$conf.int[1], dr1500$estimate , dr1500$conf.int[2]),
	c(dr2000$conf.int[1], dr2000$estimate , dr2000$conf.int[2])
)

idealsc_tt <- rbind( # 50%
	c(idealsc500$conf.int[1], idealsc500$estimate , idealsc500$conf.int[2]),
	c(idealsc1000$conf.int[1], idealsc1000$estimate , idealsc1000$conf.int[2]),
	c(idealsc1500$conf.int[1], idealsc1500$estimate , idealsc1500$conf.int[2]),
	c(idealsc2000$conf.int[1], idealsc2000$estimate , idealsc2000$conf.int[2])
)

idealdr_tt <- rbind( # Drop Random
	c(idealdr500$conf.int[1], idealdr500$estimate , idealdr500$conf.int[2]),
	c(idealdr1000$conf.int[1], idealdr1000$estimate , idealdr1000$conf.int[2]),
	c(idealdr1500$conf.int[1], idealdr1500$estimate , idealdr1500$conf.int[2]),
	c(idealdr2000$conf.int[1], idealdr2000$estimate , idealdr2000$conf.int[2])
)

# How many % sample central is lower than:
SC10_SC25 <- 1-(sc_tt/dr_tt) 
SC10_DR <- 1-(sc_tt/idealdr_tt)

write.csv(cbind(SC10_SC25 ,SC10_DR), file="SampleRate-error (Comparison Matrix SC vs DR - SC10:SC25 and SC10:DR).csv")

##########################################################################
lowerBound <- min(7, sc_tt, dr_tt, idealsc_tt, idealdr_tt) # Obs.: 7 is a quick fix for normalize the y-range 
upperBound <- max(40, sc_tt, dr_tt, idealsc_tt, idealdr_tt)  # Obs.: 40 is a quick fix for normalize the y-range
y_lim <- c(lowerBound, upperBound)
x <- c(500,1000,1500,2000)

setEPS()
postscript("graphic_varySampleRate.eps")

plot(x, sc_tt[,2] ,ylim=y_lim, type='b', pch=4, col='black', ylab='Error (%)', xlab='Buffer Size (Maximum amount of samples).', xaxt="n")
axis(1, at=x, labels=c("500","1000","1500","2000"))
legend("topright", legend=c("Data-Aware Drop (10%)", "Data-Aware Drop (25%)", "Data-Aware Drop (50%)","Random Packet Drop"), lty=c(1,2,3,4), col=c("black","blue", "red", "chartreuse4"), bty="n", pch=c(4,1,2,7))

# 10%
matpoints(, sc_tt[,2],  pch = 4, col = 1, cex=1.2)
arrows(x, sc_tt[,1], x, sc_tt[,3], length = .05, angle = 90, code = 3) 
segments(x, sc_tt[,1], x, sc_tt[,3])
lines(1:length(x), sc_tt[,1], lty = 1, lwd = 1.5) 

# 25%
points(x, dr_tt[,2], type='b', pch=1, col='blue', lty=2)
points(x, dr_tt[,1], type='p', pch="-", col='blue')
points(x, dr_tt[,3], type='p', pch="-", col='blue')
segments(x, dr_tt[,1], x, dr_tt[,3], col='blue')

# 50%
points(x, idealsc_tt[,2], type='b', pch=2, col='red', lty=3)
points(x, idealsc_tt[,1], type='p', pch="-", col='red')
points(x, idealsc_tt[,3], type='p', pch="-", col='red')
segments(x, idealsc_tt[,1], x, idealsc_tt[,3], col='red')

# Drop Random
points(x, idealdr_tt[,2], type='b', pch=7, col='chartreuse4', lty=4)
points(x, idealdr_tt[,1], type='p', pch="-", col='chartreuse4')
points(x, idealdr_tt[,3], type='p', pch="-", col='chartreuse4')
segments(x, idealdr_tt[,1], x, idealdr_tt[,3], col='chartreuse4')

dev.off()

