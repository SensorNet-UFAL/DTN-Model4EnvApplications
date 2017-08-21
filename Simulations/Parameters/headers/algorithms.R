################################################################################

# Sampling Central: Alla
# Cria um stream simples para cada coluna do histograma dos dados 
# Usa os elementos mais centrais de cada coluna do histograma para fazer a amostragem

sampleCentral <- function(dataGeo_, sampleSize_){
  histNum = 10;

  dataFrame <- as.data.frame(dataGeo_)
  
#   if(nrow(dataFrame) <= histNum){
#     return(dataFrame)
#   }
  
  attach(dataFrame)
  dataOrder <- dataFrame[order(data),]
  detach(dataFrame)
  
  size = nrow(dataOrder)
  histScale = (dataOrder[size,3] - dataOrder[1,3])/histNum;
  
  firstIndex = 1;
  fGen = 0; 
  countGen = 1;
  CHECK = FALSE;
  histOut = data.frame();
  for(i in 1:histNum){
    while(countGen < size && dataOrder[countGen,3] <= (dataOrder[firstIndex,3] + histScale)){
      fGen = fGen + 1;
      countGen = countGen + 1;
      CHECK = TRUE;
    }
    if(CHECK){
      aux = (floor(sampleSize_*(fGen/size)));
      index = firstIndex + floor((fGen/2) - (aux/2));
      histOut <- rbind(histOut, dataOrder[index:(index+aux),])
      fGen = 0;
      CHECK = FALSE;
      firstIndex = countGen;
    }
  }
  dataOut <- histOut[order(as.numeric(row.names(histOut))),] 
  return(dataOut)
}

################################################################################

# Tamanho do sensor stream: Israel (04/2014)
# Função para medir o tamanho do sensor stream. Retorna: Tamanho do sensor stream: [1] Quantidade de nós / [2] Total de amostras (Data Frame)
dataStreamLength <- function(dataStream_) {

ret <- data.frame("qtdSensors", "totalStreamLength")
ret$qtdSensors <- length(names(dataStream_))
ret$totalStreamLength <- 0

	for(i in names(dataStream_)) {
		ret$totalStreamLength <- ret$totalStreamLength + length(dataStream_[[i]]$data)
	}

return(ret)

}

################################################################################

# Drop First
# Editado: Israel (04/2014) - Buffer em função do tamanho do sensor-stream
DropFirst <- function(allSensors_, bufferSize_, route){ # Primeiros nós visitados

newAllSensors = hash()
fullBuffer <- FALSE
counter <- 0 #Contador auxiliar para controlar o tamanho do vetor que guarda as amostras

	for(i in length(route):1) { #DropLast de trás para frente	

		currentNode <- route[i]
		streamLength <- length(hashDados[[currentNode]]$data) #Armazenando a quantidade de amostras

		for(j in 1:streamLength) { #Checar se o buffer enche no nó corrente
			counter <- counter+1
			if(counter > bufferSize_)
				fullBuffer <- TRUE		
		}

	if(fullBuffer == FALSE) {
		newAllSensors[[currentNode]] <- allSensors_[[currentNode]] #Pega todos os dados de um nó (de trás p/ frente)
	}

	else
		break
	}
	
return(newAllSensors)
}

################################################################################

# Drop Last
# Editado: Israel (04/2014) - Buffer em função do tamanho do sensor-stream
DropLast <- function(allSensors_, bufferSize_, route, printSBS = FALSE){ # Primeiros nós visitados

newAllSensors = hash()
fullBuffer <- FALSE
counter <- 0 #Contador auxiliar para controlar o tamanho do vetor que guarda as amostras

	for(i in 1:length(route)) {

		currentNode <- route[i]
		streamLength <- length(hashDados[[currentNode]]$data) #Armazenando a quantidade de amostras

		for(j in 1:streamLength) { #Checar se o buffer enche no nó corrente
			counter <- counter+1
			if(counter > bufferSize_)
				fullBuffer <- TRUE		
		}

		if(fullBuffer == FALSE) {
			newAllSensors[[as.character(i)]] <- allSensors_[[currentNode]] #Pega todos os dados de um nó
			newAllSensors[[as.character(i)]]$ID <- currentNode

			if(printSBS == TRUE)
				print_SBS(toString(i), newAllSensors) #imprime o algoritmo passo a passo 
	
		} else
			break
	}

	
return(newAllSensors)
}

################################################################################

#Drop Random
# Editado: Israel (04/2014) - Buffer em função do tamanho do sensor-stream
DropRandom <- function(allSensors_, bufferSize_, route){ # Primeiros nós visitados

newAllSensors = hash()
fullBuffer <- FALSE

newStartPoint <- 1 #Aponta para o último índice atingido na amostragem inicial, ponto de partida para o processo drop random
dropPointer <- 1 #Auxiliar que aponta para o próximo índice do sensor stream a ser descartado (Nesse caso, os mais antigos)
counter <- 0 #Contador para controlar o uso do buffer

	newAllSensors <- DropLast(allSensors_, bufferSize_, route) #Na primeira etapa, o algoritmo executa o drop last

	newStartPoint <- dataStreamLength(newAllSensors)$qtdSensors
	counter <- dataStreamLength(newAllSensors)$totalStreamLength

	for(i in (newStartPoint+1):length(route)) { #Buffer cheio
		
		dropPointer <- sample(names(newAllSensors), 1) #Apontando para o proximo conjunto de amostras que serao descartadas
		dropStreamLength <- length(newAllSensors[[dropPointer]]$data) #Tamanho do conjunto apontado
		currentStreamLength <- length(allSensors_[[route[i]]]$data) #Armazenando a quantidade de amostras

		#print(paste("drop pointer: ",dropPointer))
		#print(paste(counter," + ",streamLength," - ",dropStreamLength))

		for(j in 1:currentStreamLength) { # Obs.: A primeira iteraçao irá encher o buffer
			counter <- counter+1
			if(counter > bufferSize_)
				fullBuffer <- TRUE		
		}

		if(fullBuffer == FALSE) {
			newAllSensors[[route[i]]] <- allSensors_[[route[i]]] #Pega todos os dados de um nó
		}

		else { #Tenta liberar espaço: Escolhe aleatoriamente um nó para descartar seus dados

			#Checa se o buffer tem espaço suficiente para remover um data-stream e adicionar outro
			if((counter - dropStreamLength) < bufferSize_) {
				fullBuffer <- FALSE #Avisa que o buffer possui espaço livre
				del(dropPointer, newAllSensors)
				newAllSensors[[as.character(route[i])]] <- allSensors_[[route[i]]] #Pega todos os dados de um nó
			} 

			counter <- dataStreamLength(newAllSensors)$totalStreamLength # Recalcula o espaço ocupado no buffer
		}
	}	

print(paste("Final buffer usage: ", counter))
return(newAllSensors)
}


################################################################################
# Based Neighborhood Drop Policy (Israel 02/2015)
# Adaptado de: Coverage Drop Policy (Maurício ISCC 2012)

BNDP <- function(allSensors_, bufferSize_, sensors, route, range, printSBS = FALSE) {
	

	newAllSensors <- DropLast(allSensors_, bufferSize_, route, printSBS) # Na primeira etapa, o algoritmo executa o drop last

	newStartPoint <- dataStreamLength(newAllSensors)$qtdSensors #Aponta para o último índice atingido na amostragem inicial
	counter <- dataStreamLength(newAllSensors)$totalStreamLength #Contador para controlar o uso do buffer
	turnsWithoutDrop <- 0 # Variável para controle de rodadas sem descarte

	for(i in (newStartPoint+1):length(route)) { # Buffer cheio

		if(printSBS == TRUE)
			print_SBS(toString(i), newAllSensors) #imprime o algoritmo passo a passo 

		streamLength <- length(allSensors_[[route[i]]]$data) # Armazenando a quantidade de amostras
		#print(paste("Current Node:", route[i]))

		for(j in 1:streamLength) { # Obs.: A primeira iteraçao irá encher o buffer
			counter <- counter+1
			if(counter > bufferSize_)
				fullBuffer <- TRUE		
		}

		if(fullBuffer == FALSE) {
			newAllSensors[[route[i]]] <- allSensors_[[route[i]]] # Pega todos os dados de um nó
			#print(paste(route[i], "Received."))
			#print(paste("Buffer", counter))

		} else { # Se o buffer estiver cheio

			#print("Full buffer.")

			oldNewAllSensors <- length(names(newAllSensors)) # Variável para controle de rodadas sem descarte
			newAllSensors <- dropNeighbors(newAllSensors, sensors, range) # Redução baseada na vizinhança

			if(oldNewAllSensors ==  length(names(newAllSensors))) { # Checa se houve mudança no buffer
				turnsWithoutDrop <- turnsWithoutDrop + 1
			} else {
				turnsWithoutDrop <- 0
			}

			if(turnsWithoutDrop > ceiling(n_sensores/20)) { # Após um determinado tempo sem descartar nada, descartar o maior pacote
				newAllSensors <- dropBiggestStream(newAllSensors)
				turnsWithoutDrop <- 0
				#print("Drop the biggest pack.")
			}

			counter <- dataStreamLength(newAllSensors)$totalStreamLength # Atualizando o espaço ocupado no buffer
			#print(paste("Reduced Buffer:", counter))

			if((counter + streamLength) <= bufferSize_) {
				newAllSensors[[route[i]]] <- allSensors_[[route[i]]] # Pega todos os dados de um nó
				counter <- counter+streamLength # Atualizando o espaço ocupado no buffer
				fullBuffer = FALSE
				#print(paste(route[i], "Received."))
			}
		}

	#print(names(newAllSensors))

	}

	print(paste("Final buffer usage: ", counter))
	return(newAllSensors)
}

dropNeighbors <- function(newAllSensors, sensors, range) { # Calcula a vizinhança e descarta o nó que tiver mais vizinhos

	nodes <- names(newAllSensors)
	xcoords <- ceiling(sensors$x)
	ycoords <- ceiling(sensors$y)

	maxNeighborsList <- vector() # Hash temporária para fazer a contagem dos vizinhos

	# Calculando os vizinhos
	dropPointer <- ""
	maxNeighbors <- 0

	for(i in nodes) { # Compara todos com todos
	
		#print(paste(i))
		qtNeighbors <- 0
		neighbors <- vector()

		for(j in nodes) {
			xDist <- xcoords[as.double(i)]-xcoords[as.double(j)]
			yDist <- ycoords[as.double(i)]-ycoords[as.double(j)]
			euclideanDistance = sqrt(xDist^2 + yDist^2)

			if(i!=j && (euclideanDistance <= range)) { # Se a dist entre os nós for inferior ao limiar, considerar vizinho
				qtNeighbors <- qtNeighbors+1
				neighbors[qtNeighbors] = j
				#print(paste(j, "is", i, "neighbor."))
			}

		}

		if(qtNeighbors > maxNeighbors) {
			maxNeighbors <- qtNeighbors
			maxNeighborsList <- neighbors
			dropPointer <- i
		}
	}

	if(dropPointer != "") {
		del(dropPointer, newAllSensors)
		#print(paste(dropPointer, "Dropped."))

	} 

	return(newAllSensors)
}

dropBiggestStream <- function(newAllSensors) {
		
		biggestStream <- 0		
		nodes <- names(newAllSensors)
		for(i in nodes) {

			dataStreamLength <- length(newAllSensors[[i]]$data)
			if(dataStreamLength > biggestStream) {
				biggestStream <- dataStreamLength
				dropPointer <- i
			}
		}

		del(dropPointer, newAllSensors)

return(newAllSensors)

}

################################################################################

# Walk: Israel (02/2015)
# Representa o movimento de uma MULE através do campo
# Retorna uma lista que mostra em sequência a ordem dos IDs que devem ser visitados
# printSBS = TRUE, caso queira imprimir o passo a passo da rota

muleWalk <- function(sensores, range, printSBS=FALSE) {

	# Variaveis de Controle p/ printSBS
	nodeCounter <- 0 
	fileName <- ""
	nodeFound <- FALSE

	route <- vector()
	xcoords <- ceiling(sensores$x)
	ycoords <- ceiling(sensores$y)

	fieldMatrix <- matrix(0, nrow=maxX, ncol=maxY)
	auxMatrix <- matrix(1, nrow=100,ncol=100)

	print("Sweep-Grid Walk.")

	# Marca as posições dos sensores no campo com o ID do nó corrente
	for(i in 1:length(xcoords)) {
		fieldMatrix[xcoords[i], ycoords[i]] = i
	}

	y=1
	endOfMatrix = FALSE
	while(y <= maxY) {

		# Correção para valores de range não divisiveis por maxY
		if(y+range > maxY)
			range = 1+maxY-y

		# Caminhando no sentido horizontal ------> (Direção inversa se endOfMatrix == TRUE)
		for(x in 1:maxX) {

			# Varrendo 5 unidades de baixo para cima 
			for(auxY in 0:(range-1)) {
				currY = y+auxY
				currX = x

				# Caminhando no sentido inverso
				if(endOfMatrix == TRUE) {
					currX = 1+abs(maxX-x)
				}

				auxMatrix[currX, currY] = 0.5

				# Gerando a sequência de nós a serem visitados
				if(currY<=maxY && fieldMatrix[currX, currY]>0) {
					route <- append(route, as.character(fieldMatrix[currX, currY]), length(route))

					# Controle p/ printSBS = TRUE
					nodeFound <- TRUE
					auxMatrix[currX, currY] = 0
					nodeCounter=nodeCounter+1

				}
			}

			if(printSBS == TRUE) { # Print step by step
				fileName <- paste("animation-route/",
					toString(nodeCounter), ".ps" ,sep='')
				nodeFound <- FALSE

				printWalk(fileName,auxMatrix)
			}
		}

		outputProgess(y)

		# Marcando posição do ponteiro para o lado oposto da matriz
		endOfMatrix= abs(endOfMatrix-1)
		y=y+range
	}

	cat("Done!", collapse="\n")
	return(route)	
}

printWalk <- function(fileName,walkMatrix) {
	graphics.off()
	postscript(fileName,horizontal=FALSE,onefile=FALSE,height=8,width=8,pointsize=14)
	image(walkMatrix, col=gray((1:32)/32), xaxt="n", yaxt="n", xlab="", ylab="")
	graphics.off()
}


print_SBS <- function(a,hashDadosSampled) { # Plota a execução do algoritmo passo a passo

    # Contagem de quantos dados foram amostrados
    	listNamesHash <- names(hashDadosSampled)
	streamLength <- length(listNamesHash)
    	count = 0

    	for(s in 1:streamLength){
      		geoTemp = hashDadosSampled[[listNamesHash[s]]]
      		count = count + length(geoTemp$data)
    	}



    # Separação dos dados para gerar figura e para obter o kriging
    	dataToKrig = matrix(nrow=count, ncol = 3) # Dados para o krig
    	dadosSampled = matrix(nrow = maxY, ncol = maxX) # Dados para a figura
    	count = 1
    	for(s in 1:streamLength){
      		geoTemp = hashDadosSampled[[listNamesHash[s]]]
      		for(i in 1:length(geoTemp$data)){
        		dataToKrig[count,1] <- x_ <- geoTemp$coords[i,1]
        		dataToKrig[count,2] <- y_ <- geoTemp$coords[i,2]
        		dataToKrig[count,3] <- dadosSampled[x_,y_] <- geoTemp$data[i]
        		count = count + 1
      		}
    	}
	name <- paste("animation/",a, ".ps",sep='')
	GerarFiguraRedPalette(name, dadosSampled)

}

outputProgess <- function(i) { # Avisa no console que há uma operação em andamento

				# Output progresso
				output <- ""
				if(i%%3==0) {
					output<-"Working."
				} else if(i%%3==1) {
					output<-"Working.. "
				} else if(i%%3==2){
					output<-"Working..."
				}

  
				cat('\r',format(paste(output, sep='')))
				flush.console() 
}

