# Call this file with command: 
# nohup Rscript pairIndexes.R <samplingAlgorithm> <bufferSize> &
# Example: nohup Rscript pairIndexes.R SampleCentral 20 &
# Options: SampleCentral, DropRandom / 20, 35, 50, 100

evalType <- "varyNodes" # Experiment under study

args <- commandArgs(TRUE)

args
samplingAlgorithm <- args[1] 
numNodes <- evalParameter <- as.double(args[2])
seed <- as.double(args[3])
evalMetric <- args[4]

sampleRate <- 25

if(length(args) != 4) {
	print("WARNING: Number of parameters does not match.")
	stop()
}

##############################################################################################################

	source("../Parameters/headers/dependencies-InstallAndRun.R")
	require("hash")

	destinationFolder <- paste("../Parameters/NodesData/")

	field = read.table(paste(destinationFolder,seed,"-",numNodes,"-field.dat",sep=''))
	field = as.matrix(field) # Change format to access elements by direct reference.
	fieldLength <- maxX <- maxY <- dim(field)[1]

	print("1: Field imported.")

	voronoiCoords = read.tcsv(paste(destinationFolder,seed,"-",numNodes,"-voronoiCoords.csv",sep=''))
	print("2: Voronoi Cells imported.")

	remainingIndexes = read.tcsv(paste("RemainingIndexes/",seed,"-",evalType,"-",evalParameter,"-",samplingAlgorithm,"-remainingIndexes.csv",sep=''))
	print("3: Sample-indexes imported.")

	remainingIndexes=remainingIndexes+1 # Fixing first index (C++: [0], R: [1])
	remainingIndexesID = names(remainingIndexes)
	hashDadosSampled = hash() # Get index-elements by calling (ie.:) remainingCoords[["1"]] (any node ID)

	newField = matrix(NA,nrow=dim(field)[1], ncol=dim(field)[2])

	for (i in remainingIndexesID) {

		currentList = voronoiCoords[[i]][remainingIndexes[[i]]]
		indexes_removedNAs = vector()

		for(j in 1:length(currentList)) {
			if(!is.na(currentList[j]))
				indexes_removedNAs[j]=currentList[j]

			else
				break
		}

		# Keeping retrocompatible with previous scripts
		newField[indexes_removedNAs] = field[indexes_removedNAs]

		unvectorized_coords <- matrix(nrow=length(indexes_removedNAs), ncol=2)
		colnames(unvectorized_coords) <- c("Coord1","Coord2")

		for (j in 1:length(indexes_removedNAs)) { # Converting back indexes to x,y format
			coords <- unvectorize_xy(indexes_removedNAs[j], fieldLength)
			unvectorized_coords[j,1] <- coords[1]
			unvectorized_coords[j,2] <- coords[2]
		}

		unvectorized_coords = unvectorized_coords[order(unvectorized_coords[,1]),] # Just sorting

		hashDadosSampled[[i]]$coords <- unvectorized_coords
		hashDadosSampled[[i]]$data <- field[indexes_removedNAs]
		hashDadosSampled[[i]]$ID = i
	}

	print("Pairing done!")

	##########################################################################################
	# Code pasted from previous simulation V7 R-Only: Error/Coverage evaluation.
	# Israel, 2014

		# My libraries
		source("../Parameters/headers/krigingFunctions.R")
		source("../Parameters/headers/auxiliarFunctions.R")

		# Temporary variables
		r = seed
		n_sensores = numNodes
		percentualReducao = "x" # Keeping variables with old names to retrocompatibility

		## File names
		figName <- paste("imagens/campo_",samplingAlgorithm,"_",r,'_',n_sensores,'_',percentualReducao,'.eps',sep='')
		figName2 <- paste("imagens/",r,'_',n_sensores,"_",samplingAlgorithm,"_",percentualReducao,'.eps',sep='')
		figName3 <- paste("imagens/",r,'_',n_sensores,"_reconst_",samplingAlgorithm,"_",percentualReducao,'.eps',sep='')
		fileName <- paste("resultados-erro/",r,'_',n_sensores,'_',percentualReducao,'_erroReconstrucao_',samplingAlgorithm,'.dat',sep='')
		fileName2 <- paste("resultados-cobertura/",r,'_',n_sensores,'_',percentualReducao,'_coverage_',samplingAlgorithm,'.dat',sep='')

		print("Settings loaded.")

		GerarFigura(figName, field)

	#---------------------------------------------------------------------

	    # Contagem de quantos dados foram amostrados
	    	listNamesHash <- names(hashDadosSampled)
		streamLength <- length(listNamesHash)
	    	count = 0

	    	for(s in 1:streamLength){
	      		geoTemp = hashDadosSampled[[listNamesHash[s]]]
	      		count = count + length(geoTemp$data)
	    	}

		print("Ok! (1/5)")

	    # Separação dos dados para gerar figura e para obter o kriging
	    	dataToKrig = matrix(nrow=count, ncol = 3) # Dados para o krig
	    	dadosSampled = matrix(nrow = maxY, ncol = maxX) # Dados para a figura
	    	count = 1
		print(paste("Visited Nodes are displayed below."))
	    	for(s in 1:streamLength){
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
				
					print(paste("Single-Sample case detected and fixed at Node ID ", listNamesHash[s],".",sep=''))

					dataToKrig[count,1] <- x_ <- geoTemp$coords[1] # Salvo na forma de vetor
					dataToKrig[count,2] <- y_ <- geoTemp$coords[2] 
					dataToKrig[count,3] <- dadosSampled[x_,y_] <- geoTemp$data[i]

					if(is.na(dataToKrig[count,1]) || is.na(dataToKrig[count,2]) || is.na(dataToKrig[count,3 ]))
						print("NA Detected!!")

					count = count + 1

				}
	      		}
	    	}

		GerarFigura(figName2, dadosSampled)


	##########################################################################################

		if (evalMetric == "Coverage") {
			print("Ok! (5/5)")
			sumCoverage <- sum(coverage(dadosSampled))
			write.table(sumCoverage, file=fileName2)
		}

		#---------------------------------------------------------------------

		if (evalMetric == "Error") {

			print("Ok! (2/5)")

			num_indexes <- which(is.na(dadosSampled)==FALSE) #Armazena os indices dos valores amostrados
		    	#Alguns valores podem ser perdidos na reconstrucao, o vetor acima garante que estes valores possam ser recuperados

			print(paste("Qt. samples: ",length(num_indexes)))

		    # Dados geo para calcular o krig
		    	geoDados = as.geodata(dataToKrig)
		    
			print("Kriging...")
		    # Reconstrução dos dados da área de cada sensor utilizando Kriging Simples
		    	krig <- 0
		    	try(krig <- simpleKriging(geoDados, fieldDimensions=fieldLength))
		    	reconstrucao = matrix(krig$predict,ncol=maxX)

			print("Ok! [Kriging Done] (3/5)")

			print("Merging samples.")
		    	####################
		    	# Mesclando os valores amostrados com a reconstrucao
		    	
		    	for(i in 1:length(num_indexes)) { 
		    	  index <- num_indexes[i] # Indices dos valores amostrados
		    	  sampled_value <- dadosSampled[index] # Valor original amostrado
		    	  
			#print("#")
			#print(reconstrucao[index])
		    	#print(sampled_value)
			#print("#")
		
		    	  reconstrucao[index] <- sampled_value
		    	} 
		    	###################

		    	GerarFigura(figName3, reconstrucao)

			print("Ok! (4/5)")

		#---------------------------------------------------------------------

		    # Erro comparando a dados pontuais com krig e o campo original.
		    	erroKrig = 0
		    	try(erroKrig <- erro(reconstrucao,field,fieldLength))
		    	write.table(erroKrig, file=fileName)

			print("Ok! (5/5)")
	}

print("Done!")
