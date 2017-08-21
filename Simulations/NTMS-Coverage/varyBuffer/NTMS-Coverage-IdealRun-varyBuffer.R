#!/usr/bin/Rscript

# Este script compara a cobertura produzida pelos algoritmos de descarte

replications <- 30

sumCoverageDN <- matrix(ncol=5,nrow=replications)
sumCoverageDR <- matrix(ncol=5,nrow=replications)
sumCoverageDL <- matrix(ncol=5,nrow=replications)
sumCoverageDF <- matrix(ncol=5,nrow=replications)
sumCoverageOGK <- matrix(ncol=5,nrow=replications)

redCol <- 0 # Coluna da matriz com respectivo percentual de reducao

for(percentualReducao in c(5,10,15,20,25)) {

	redCol <- redCol+1

	for(r in 1:replications) {

	#---------------------------------------------------------------------

	n_sensores <- 50
	inhibit <- 4

	if(percentualReducao < 1 || percentualReducao > 100)
		stop("Param. reducao invalido")

		source("../../Parameters/headers/dependencies-InstallAndRun.R")
		source("../../Parameters/headers/auxiliarFunctions.R")
		source("../../Parameters/headers/algorithms.R")


	#---------------------------------------------------------------------

		# Valores do campo a ser monitorado.
		fieldLength <- 100
		maxX = 100
		maxY = 100
	  
		x<-1:maxX
		y<-1:maxY
	  
		# Parâmetros para a geração dos dados e distribuição dos sensores.
		kappa <- 0.5
		phi <- 2
		mean <- 25
		variance <- 100

		## Start simulation
		set.seed(10000*kappa + 10*phi + r) # Semente ser unica para cada processo

		print(paste("Replicação ",r))
		print(paste("Percentual de reduçao: ", percentualReducao, "%"))

		print(paste("Numero de sensores: ", n_sensores))
	    
		# Gerando campo a ser sensoriado.
		campo = mygrf(kappa=kappa,phi=phi,mean=mean,var=variance,nugget=0)

		# Gerando sensores
	  	sensores = rSSI(n = n_sensores, r = inhibit, win = square(maxX), giveup = 10^5)
		print("SSI: OK!")

		route <- muleWalk(sensores,10)
		print("ROUTE: OK!")

		# Apenas excluindo o processamento inicial.    
		# Atribuindo dados a cada sensor pontualmente.
	  	dados = readData(sensores,campo)
	  	geoDados = geo(sensores,dados)
		geoDados$coords = trunc(geoDados$coords)

		# Atribuindo dados a cada sensor considerando a célula de voronoi.
	  	hashDados = readDataVoronoi(sensores,campo)
		print("VORONOI: OK!")

	###########################################################################################################

		# Redução

		bufferSize = 0

		hashDadosSampled = hash()

		for(s in 1:n_sensores) {
			currentNode = route[s] #currentNode: double convertido p/ string
			bufferSize = bufferSize + (length(hashDados[[currentNode]]$data))*percentualReducao/100 
			if(bufferSize < 1)
				bufferSize = 1;
		}

		aux <- 0
	    	for(s in 1:n_sensores) {
			sampleSize = (length(hashDados[[as.character(s)]]$data))*percentualReducao/100; 
			# Corresponde ao tamanho dividido pelo percentual de reducao

			aux <- aux + sampleSize

			if(sampleSize < 1)
				sampleSize = 1

	      		hashDadosSampled[s] = as.geodata(sampleCentral(hashDados[[as.character(s)]], sampleSize))
	    	}

		print(paste("Buffer Size:", bufferSize))

		for(j in 1:5) { #j==1 -> OGK

			if(j==2) { # DL
				clear(hashDadosSampled)
	    			hashDadosSampled <- DropLast(hashDados, bufferSize, route)
			} else if(j==3) { # DF
				clear(hashDadosSampled)
	    			hashDadosSampled <- DropFirst(hashDados, bufferSize, route)
			} else if(j==4) { # DR
				clear(hashDadosSampled)
	    			hashDadosSampled <- DropRandom(hashDados, bufferSize, route)
			} else if(j==5) { # BNDP
				clear(hashDadosSampled)
	    			hashDadosSampled <- BNDP(hashDados, bufferSize, sensores, route, ceiling(n_sensores/5))
			}


#######################################################################################

    # Contagem de quantos dados foram amostrados
    	listNamesHash <- names(hashDadosSampled)
	streamLength <- length(listNamesHash)
  	count = 0
  	for(s in 1:n_sensores){
  	  	geoTemp = hashDadosSampled[[as.character(s)]]
      		count = count + length(geoTemp$data)
  	}
    
	    # Separação dos dados para gerar figura e para obter o kriging
	dataToKrig = matrix(nrow=count, ncol = 3) # Dados para o krig
	dadosSampled = matrix(nrow = maxY, ncol = maxX) # Dados para a figura
	count = 1
	print(paste("Visited Nodes are displayed below."))

	for(s in 1:streamLength) {

		try( 
			if ( !is.na(as.double(listNamesHash[s])) )  {
	      			geoTemp = hashDadosSampled[[listNamesHash[s]]]
				print(paste("Node ID:",listNamesHash[s]))
		      		for(i in 1:length(geoTemp$data)){
					if(length(geoTemp$data) > 1) { # Detecção de erro sem causa identificada* em (Set/2016)
						dataToKrig[count,1] <- x_ <- geoTemp$coords[i,1] # Salvo na forma de matriz
						dataToKrig[count,2] <- y_ <- geoTemp$coords[i,2]
						dataToKrig[count,3] <- dadosSampled[x_,y_] <- geoTemp$data[i]
						#print(paste(geoTemp$coords[i,1], ",",geoTemp$coords[i,2], " / Data: ", geoTemp$data[i], sep=''))

						if(is.na(dataToKrig[count,1]) || is.na(dataToKrig[count,2]) || is.na(dataToKrig[count,3 ]))
							print("NA Detected!!")

						count = count + 1

					} else { # Solução de erro sem causa identificada* em (Set/2016): Desconsiderar streams de tamanho 1
					## (Fev/2017) *Causa do erro: Quando length(geoTemp$data)=1, geoTemp$coords perde uma dimensão e é deixa de ser uma matriz
					## Nova solução de erro em (Fev/2017): Declarar geoTemp$coords na forma vetorial
				
						try(print(paste("Single-Sample case detected and fixed at Node ID ", listNamesHash[s],".",sep='')))

						try(dataToKrig[count,1] <- x_ <- geoTemp$coords[1]) # Salvo na forma de vetor
						try(dataToKrig[count,2] <- y_ <- geoTemp$coords[2]) 
						try(dataToKrig[count,3] <- dadosSampled[x_,y_] <- geoTemp$data[i])

						#if(is.na(dataToKrig[count,1]) || is.na(dataToKrig[count,2]) || is.na(dataToKrig[count,3 ]))
							#print("NA Detected!!")

						count = count + 1
					}
		      		}
			} 
		)
	}

#######################################################################################

			if(j==1) { # OGK
				sumCoverageOGK[r,redCol] <- sum(coverage(dadosSampled))
				print("Sample Central")
			} else if(j==2) { # DL
				sumCoverageDL[r,redCol] <- sum(coverage(dadosSampled))
				print("Drop Last")
			} else if(j==3) { # DF
				sumCoverageDF[r,redCol] <- sum(coverage(dadosSampled))
				print("Drop First")
			} else if(j==4) { # DR
				sumCoverageDR[r,redCol] <- sum(coverage(dadosSampled))
				print("Drop Random")
			} else if(j==5) { # BNDP
				sumCoverageDN[r,redCol] <- sum(coverage(dadosSampled))
				print("Drop Neighbors")
				print("------------------------------------")
			}

		}
	}
}

write.table(sumCoverageOGK, "coverageOGK.dat")
write.table(sumCoverageDL, "coverageDL.dat")
write.table(sumCoverageDF, "coverageDF.dat")
write.table(sumCoverageDR, "coverageDR.dat")
write.table(sumCoverageDN, "coverageDN.dat")
