# This script generates automatically a code for Castalia config file (omnetpp.ini)
# That assigns inidivually a position to each node according to SSI distribution
# The generated file coords.dat is ready to be copied to any .ini castalia script
#
# Author: Israel Vasconcelos
# Federal University of Alagoas
# Sep, 2015

source("dependencies-InstallAndRun.R")

print("Number of nodes/ Field length/ Seed displayed below:")
args <- commandArgs(TRUE)

args
numNodes <- as.double(args[1]) # Qtd nodes
fieldLenght <- as.double(args[2]) # Length of the monitored area
seed <- as.double(args[3])
inhibit = 4 # Default value to inhibittion radius

if(length(args) != 3) {

	print("WARNING: Number of parameters does not match.")
	print("Setting values to default: numNodes=100, fieldLength=750")

	numNodes=100
	fieldLenght=100
	seed = sample(100,1)
}

####################################################################################

#destinationFolder <- paste("Simulations/valueReporting/parameters/")
destinationFolder <- paste("")
prefix <- paste(seed,"-",numNodes,"-",sep='')

set.seed(1) # Same field for all deployments

field = round(mygrf(kappa=0.5,phi=4,mean=25,var=50,nugget=0, fieldLength=fieldLenght),2)

fieldToFile <- paste(destinationFolder,prefix,"field.dat", sep='')

write.table(field,fieldToFile, row.names=FALSE, col.names=FALSE, quote=FALSE)
print("Random Field: Done!")

######------------------------------######

set.seed(1000*fieldLenght + 10*numNodes + seed) # Change only Voronoi Cells

sensors = rSSI(n = numNodes, r = inhibit, win = square(fieldLenght), giveup = 10^5)

xCoords = trunc(sensors$x)
yCoords = trunc(sensors$y)

assignment = 'SN.node['
toXCoord = '].xCoor = '
toYCoord = '].yCoor = '

numLines <- length(xCoords) + length(yCoords)
toCastaliaIni <- matrix("",nrow=numLines)

j=1
for(i in 1:numNodes) {
	toCastaliaIni[j] = paste(assignment, i, toXCoord, xCoords[i], sep='')
	toCastaliaIni[j+1] = paste(assignment, i, toYCoord, yCoords[i], sep='')

	j=j+2
}

nodesCoordsIni <- paste(destinationFolder,prefix,"nodesCoords.ini", sep='')

write.table(toCastaliaIni,nodesCoordsIni, row.names=FALSE, col.names=FALSE, quote=FALSE)
print("Deployment: Done!")

######------------------------------######

voronoi = readDataVoronoi(sensors,field)

output=""

for(i in 1:numNodes) { #[x,y] = [x+(y-1)*fieldLength] / Vetorização: Transformando matriz N x N em vetor N^2 x 1

	output <- paste(output,i,",",sep='')

	for(j in 1:length(voronoi[[as.character(i)]]$data)) {

		x <- voronoi[[as.character(i)]]$coords[j,1]
		y <- voronoi[[as.character(i)]]$coords[j,2]

		index = x+(y-1)*fieldLenght
		output=paste(output,index,",",sep='')

		cat('\r',format(paste("[Checkpoint 2] Progress: ",round(j*100/length(voronoi[[as.character(i)]]$data),2),"% - ",i,"/",numNodes,"  ",sep='')))
		flush.console() 
	}

	if(i != numNodes)
		output=paste(output,"\n",sep='')
}

voronoiCoordsCsv <- paste(destinationFolder,prefix,"voronoiCoords.csv",sep='')
write.table(output,voronoiCoordsCsv, row.names=FALSE, col.names=FALSE, quote=FALSE)
print("Voronoi Coords: Done!")

			#----------------------------------------------------#

toCastaliaIni="(0)"

for(i in 1:numNodes) { 

	cat('\r',format(paste("Checkpoint 3: ", i , "/", numNodes ,sep='')))
	flush.console() 

	toCastaliaIni <- paste(toCastaliaIni," ",i,":{",sep='')

	for(j in 1:length(voronoi[[as.character(i)]]$data)) {

		if(j!=1)
			toCastaliaIni=paste(toCastaliaIni,",",sep='')

		index <- round(voronoi[[as.character(i)]]$data[j],2)

		toCastaliaIni=paste(toCastaliaIni,index,sep='')

		cat('\r',format(paste("[Checkpoint 3] Progress: ",round(j*100/length(voronoi[[as.character(i)]]$data),2),"% - ",i,"/",numNodes,"  ",sep='')))
		flush.console() 

	}

	toCastaliaIni=paste(toCastaliaIni,"}",sep='')
}


nodesDataIni <- paste(destinationFolder,prefix,"nodesData.ini",sep='')
write.table(toCastaliaIni,nodesDataIni, row.names=FALSE, col.names=FALSE, quote=FALSE)
print("Voronoi Data: Done!")
