# Call this file with command: 
# nohup Rscript pairIndexes.R <samplingAlgorithm> <bufferSize> <seed> &
# Example: nohup Rscript pairIndexes-Model.R SampleCentral 1000 1 &
# Options: SampleCentral, DropRandom / 500, 1000, 1500, 2000, 2500 / [1:30]

evalType <- "varyModel" # Experiment under study

args <- commandArgs(TRUE)
args
samplingAlgorithm <- args[1] 
bufferSize <- evalParameter <- as.double(args[2])
seed <- as.double(args[3])

# Default parameters
fieldLenght <- 100
numNodes <- 50
inhibit <- 4
evalMetric <- "Coverage"

if(length(args) != 3) {
	print("WARNING: Number of parameters does not match, using defaults.")
	samplingAlgorithm <- "SampleCentral"
	sampleRate <- evalParameter <- 10 # 10% of data (1000 samples in a 100x100 grid)
	seed <- 1
} else {
	sampleRate <- (100*bufferSize)/(fieldLenght^2)
	if(sampleRate>100 || sampleRate<0)
		stop("Invalid sampleRate")
}



set.seed(1000*fieldLenght + 10*numNodes + seed + sample(10000,1))

	source("../../Parameters/headers/dependencies-InstallAndRun.R")
	require("hash")

	destinationFolder <- paste("../../Parameters/NodesData/")

	field = read.table(paste(destinationFolder,seed,"-",numNodes,"-field.dat",sep=''))
	field = as.matrix(field) # Change format to access elements by direct reference.
	fieldLength <- maxX <- maxY <- dim(field)[1]

	print("1: Field imported.")


	##########################################################################################
	# Code pasted from previous simulation V7 R-Only: Error/Coverage evaluation.
	# Israel, 2014

	# My libraries
	source("../../Parameters/headers/krigingFunctions.R")
	source("../../Parameters/headers/auxiliarFunctions.R")
	source("../../Parameters/headers/algorithms.R")

	# Keeping variables with old names to retrocompatibility
	r = seed
	n_sensores = numNodes
	percentualReducao = bufferSize # Show at fileName the status of current variable parameter
	campo = field

	# File names
	figName <- paste("imagens/campo_",samplingAlgorithm,"_",r,'_',n_sensores,'_',percentualReducao,'.eps',sep='')
	figName2 <- paste("imagens/",r,'_',n_sensores,"_",samplingAlgorithm,"_",percentualReducao,'.eps',sep='')
	figName3 <- paste("imagens/",r,'_',n_sensores,"_reconst_",samplingAlgorithm,"_",percentualReducao,'.eps',sep='')
	fileName <- paste("resultados-erro/",r,'_',n_sensores,'_',percentualReducao,'_erroReconstrucao_',samplingAlgorithm,'_Ideal.dat',sep='')
	fileName2 <- paste("resultados-cobertura/",r,'_',n_sensores,'_',percentualReducao,'_coverage_',samplingAlgorithm,'_Ideal.dat',sep='')

	# Gerando sensores
  	sensores = rSSI(n = n_sensores, r = inhibit, win = square(maxX), giveup = 10^5)

	# Calculando a rota
	route <- muleWalk(sensores,10)

	# Fixing variables with old names to retrocompatibility (again)
	percentualReducao <- sampleRate

	# Apenas excluindo o processamento inicial.    
	# Atribuindo dados a cada sensor pontualmente.
  	dados = readData(sensores,campo)
  	geoDados = geo(sensores,dados)
	geoDados$coords = trunc(geoDados$coords)

	# Atribuindo dados a cada sensor considerando a c??lula de voronoi.
  	hashDados = readDataVoronoi(sensores,campo)

###########################################################################################################

	hashDadosSampled = hash()

	if (samplingAlgorithm == "SampleCentral") {

	## Reducao dos dados com Sample Central, feita em cada no ##

		aux <- 0
	    	for(s in 1:n_sensores) {
			sampleSize = floor((length(hashDados[[as.character(s)]]$data))*percentualReducao/100)
			# Corresponde ao tamanho dividido pelo percentual de reducao

			# Erro desconhecido no algoritmo sampleCentral extrapola o bufferSize em 250 unidades, corrigindo na linha abaixo
			sampleSize = sampleSize - 250/n_sensores #TODO -> Esta solução é uma GAMBIARRA!!

			aux <- aux + sampleSize

			if(sampleSize < 1)
				sampleSize = 1

	      		hashDadosSampled[s] = as.geodata(sampleCentral(hashDados[[as.character(s)]], sampleSize))
	    	}

		#print(paste("Buffer Size:", aux)) # <- Real buffer size
		print(paste("Buffer Size:", fieldLength^2/percentualReducao)) # <- Ideal buffer size
	}

	if (samplingAlgorithm == "DropRandom"){
		# Redução considerando o DropRandom

		bufferSize = 0

		for(s in 1:n_sensores) {

			currentNode = route[s] #currentNode: double convertido p/ string

			bufferSize = bufferSize + floor((length(hashDados[[currentNode]]$data))*percentualReducao/100)

			if(bufferSize < 1)
				bufferSize = 1;
		}

	    	hashDadosSampled <- DropRandom(hashDados, bufferSize, route)
		print(paste("Buffer Size:", bufferSize))
	}

	print("Ok! (1/5)")

###########################################################################################################
    
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

#		    	GerarFigura(figName3, reconstrucao)

			print("Ok! (4/5)")

		#---------------------------------------------------------------------

		    # Erro comparando a dados pontuais com krig e o campo original.
		    	erroKrig = 0
		    	try(erroKrig <- erro(reconstrucao,field,fieldLength))
		    	write.table(erroKrig, file=fileName)

			print("Ok! (5/5)")
	}

print("Done!")
