###########################################################################################################

# Calculando intervalo de confiança


dropNeighbor_valores_erro <- read.table("coverageDN.dat")
dropRandom_valores_erro <- read.table("coverageDR.dat")
dropFirst_valores_erro <- read.table("coverageDF.dat")
dropLast_valores_erro <- read.table("coverageDL.dat")
ogk_valores_erro <- read.table("coverageOGK.dat")

##########################################################################

dropNeighbor_tt5 <- t.test(dropNeighbor_valores_erro[,1])
dropNeighbor_tt10 <- t.test(dropNeighbor_valores_erro[,2])
dropNeighbor_tt15 <- t.test(dropNeighbor_valores_erro[,3])
dropNeighbor_tt20 <- t.test(dropNeighbor_valores_erro[,4])
dropNeighbor_tt25 <- t.test(dropNeighbor_valores_erro[,5])

dropNeighbor_tt <- rbind(

c(dropNeighbor_tt5$conf.int[1], dropNeighbor_tt5$estimate, dropNeighbor_tt5$conf.int[2]),
c(dropNeighbor_tt10$conf.int[1], dropNeighbor_tt10$estimate, dropNeighbor_tt10$conf.int[2]),
c(dropNeighbor_tt15$conf.int[1], dropNeighbor_tt15$estimate, dropNeighbor_tt15$conf.int[2]),
c(dropNeighbor_tt20$conf.int[1], dropNeighbor_tt20$estimate, dropNeighbor_tt20$conf.int[2]),
c(dropNeighbor_tt25$conf.int[1], dropNeighbor_tt25$estimate, dropNeighbor_tt25$conf.int[2])

)

##########################################################################

dropRandom_tt5 <- t.test(dropRandom_valores_erro[,1])
dropRandom_tt10 <- t.test(dropRandom_valores_erro[,2])
dropRandom_tt15 <- t.test(dropRandom_valores_erro[,3])
dropRandom_tt20 <- t.test(dropRandom_valores_erro[,4])
dropRandom_tt25 <- t.test(dropRandom_valores_erro[,5])

dropRandom_tt <- rbind(

c(dropRandom_tt5$conf.int[1], dropRandom_tt5$estimate, dropRandom_tt5$conf.int[2]),
c(dropRandom_tt10$conf.int[1], dropRandom_tt10$estimate, dropRandom_tt10$conf.int[2]),
c(dropRandom_tt15$conf.int[1], dropRandom_tt15$estimate, dropRandom_tt15$conf.int[2]),
c(dropRandom_tt20$conf.int[1], dropRandom_tt20$estimate, dropRandom_tt20$conf.int[2]),
c(dropRandom_tt25$conf.int[1], dropRandom_tt25$estimate, dropRandom_tt25$conf.int[2])

)

##########################################################################

dropFirst_tt5 <- t.test(dropFirst_valores_erro[,1])
dropFirst_tt10 <- t.test(dropFirst_valores_erro[,2])
dropFirst_tt15 <- t.test(dropFirst_valores_erro[,3])
dropFirst_tt20 <- t.test(dropFirst_valores_erro[,4])
dropFirst_tt25 <- t.test(dropFirst_valores_erro[,5])

dropFirst_tt <- rbind(

c(dropFirst_tt5$conf.int[1], dropFirst_tt5$estimate, dropFirst_tt5$conf.int[2]),
c(dropFirst_tt10$conf.int[1], dropFirst_tt10$estimate, dropFirst_tt10$conf.int[2]),
c(dropFirst_tt15$conf.int[1], dropFirst_tt15$estimate, dropFirst_tt15$conf.int[2]),
c(dropFirst_tt20$conf.int[1], dropFirst_tt20$estimate, dropFirst_tt20$conf.int[2]),
c(dropFirst_tt25$conf.int[1], dropFirst_tt25$estimate, dropFirst_tt25$conf.int[2])

)


##########################################################################

dropLast_tt5 <- t.test(dropLast_valores_erro[,1])
dropLast_tt10 <- t.test(dropLast_valores_erro[,2])
dropLast_tt15 <- t.test(dropLast_valores_erro[,3])
dropLast_tt20 <- t.test(dropLast_valores_erro[,4])
dropLast_tt25 <- t.test(dropLast_valores_erro[,5])

dropLast_tt <- rbind(

c(dropLast_tt5$conf.int[1], dropLast_tt5$estimate, dropLast_tt5$conf.int[2]),
c(dropLast_tt10$conf.int[1], dropLast_tt10$estimate, dropLast_tt10$conf.int[2]),
c(dropLast_tt15$conf.int[1], dropLast_tt15$estimate, dropLast_tt15$conf.int[2]),
c(dropLast_tt20$conf.int[1], dropLast_tt20$estimate, dropLast_tt20$conf.int[2]),
c(dropLast_tt25$conf.int[1], dropLast_tt25$estimate, dropLast_tt25$conf.int[2])

)

##########################################################################
#Valor constante dá erro no ttest

ogk_tt5 <- mean(ogk_valores_erro[,1])
ogk_tt10 <- mean(ogk_valores_erro[,2])
ogk_tt15 <- mean(ogk_valores_erro[,3])
ogk_tt20 <- mean(ogk_valores_erro[,4])
ogk_tt25 <- mean(ogk_valores_erro[,5])

ogk_tt <- rbind(

c(ogk_tt5, ogk_tt5, ogk_tt5),
c(ogk_tt10, ogk_tt10, ogk_tt10),
c(ogk_tt15, ogk_tt15, ogk_tt15),
c(ogk_tt20, ogk_tt20, ogk_tt20),
c(ogk_tt25, ogk_tt25, ogk_tt25)

)

##########################################################################
y_lim <- c(min(0,ogk_tt, dropLast_tt, dropFirst_tt, dropRandom_tt, dropNeighbor_tt), max(ogk_tt, dropLast_tt, dropFirst_tt, dropRandom_tt, dropNeighbor_tt))
x <- c(5,10,15,20,25)

setEPS()
postscript("NTMS_cobertura_varyBuffer.eps")

plot(x, ogk_tt[,2] ,ylim=y_lim, type='b', pch=5, col='blue', ylab='Field Coverage (%)', xlab='Buffer Size (Maximum amount of samples).', xlim=c(5,25),xaxt='n')

axis(1, at=x, labels=c("500","1000","1500","2000","2500"))

legend("left", legend=c("Data-Aware Drop", "Random Packet Drop", "Last-Received Drop Policy", "First-Received Drop Policy","Coverage-Based Drop Policy"), lty=c(1,2,3,4,5), col=c("blue","chartreuse4", "gray40", "brown", "darkorange2"), bty="n", pch=c(5,7,8,11,10))

points(x, dropRandom_tt[,2], type='b', pch=7, col='chartreuse4', lty=2)
points(x, dropRandom_tt[,1], type='p', pch="-", col='chartreuse4')
points(x, dropRandom_tt[,3], type='p', pch="-", col='chartreuse4')
segments(x, dropRandom_tt[,1], x, dropRandom_tt[,3], col='chartreuse4')

points(x, dropLast_tt[,2], type='b', pch=8, col='gray40', lty=3)
points(x, dropLast_tt[,1], type='p', pch="-", col='gray40')
points(x, dropLast_tt[,3], type='p', pch="-", col='gray40')
segments(x, dropLast_tt[,1], x, dropLast_tt[,3], col='gray40')

points(x, dropFirst_tt[,2], type='b', pch=11, col='brown', lty=4)
points(x, dropFirst_tt[,1], type='p', pch="-", col='brown')
points(x, dropFirst_tt[,3], type='p', pch="-", col='brown')
segments(x, dropFirst_tt[,1], x, dropFirst_tt[,3], col='brown')

points(x, dropNeighbor_tt[,2], type='b', pch=10, col='darkorange2', lty=5)
points(x, dropNeighbor_tt[,1], type='p', pch="-", col='darkorange2')
points(x, dropNeighbor_tt[,3], type='p', pch="-", col='darkorange2')
segments(x, dropNeighbor_tt[,1], x, dropNeighbor_tt[,3], col='darkorange2')

dev.off()
