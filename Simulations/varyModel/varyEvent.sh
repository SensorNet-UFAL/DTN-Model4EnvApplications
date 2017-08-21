for i in {1..5} # Repeat until succeed
do

############### Simulation parameters #####################################################

# How many parallel threads
threads=8

# Always Constant parameters
appName='"ValueReporting"'
speed=2 # m/s
simTime=5000
fieldLength=100
deployment='""'

# This Evaluation Constant parameters
power='"-25dBm"'
sampleRate=25
evaluation='"varyEvent"'
bufferSize=1000
numNodes=50

# Seed Replications
replications=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30)
algorithms=('SampleCentral' 'DropRandom')
events=(0 1)

# Variable paraters
for algorithm in "${algorithms[@]}"
do 
	for event in "${events[@]}"
	do 
		for seed in "${replications[@]}"
		do

############### .ini file configuration #####################################################

fileName='omnetpp.ini'

if [ "$event" = 1 ]
	then
		coords='include ../Parameters/NodesData/'$seed'-'$numNodes'-'$event'-nodesCoords.ini'
		voronoiData='include ../Parameters/NodesData/'$seed'-'$numNodes'-'$event'-nodesData.ini'
	else
		coords='include ../Parameters/NodesData/'$seed'-'$numNodes'-nodesCoords.ini'
		voronoiData='include ../Parameters/NodesData/'$seed'-'$numNodes'-nodesData.ini'
	fi

echo "Generating Castalia configuration file omnetpp.ini"

echo "" >> $fileName # simply to avoid warning outputs if the file doesn't exist
rm $fileName # overwrite the old file

################ .ini file generation #####################################################

information='# This script was generated automatically.
# Coordinates of nodes were set individually following SSI deployment from file "deployment.R"
# Author: Israel Vasconcelos
# Federal University of Alagoas
# Ago, 2016
# [Obs.: If occur some numerical error, vary slightly the bufferSize]

[General]

include ../Parameters/Castalia.ini'

echo "$information" >> $fileName

echo "
sim-time-limit = ${simTime}s 
SN.field_x = $fieldLength # meters
SN.field_y = $fieldLength # meters

SN.numNodes = $(($numNodes+1))
SN.deployment = $deployment # SSI (Baddeley, 2007)

# Physical process
SN.physicalProcessName = \"CustomizablePhysicalProcess\"
SN.physicalProcess[0].inputType = 3" >> $fileName

echo $voronoiData >> $fileName

echo "
# Enabling mobility
SN.wirelessChannel.sigma = 0
SN.wirelessChannel.onlyStaticNodes = false
SN.wirelessChannel.bidirectionalSigma = 0

# Communication settings
SN.node[*].Communication.RoutingProtocolName = \"MyRouting\" # Single-hop routing
SN.node[*].Communication.Radio.RadioParametersFile = \"../Parameters/Radio/CC2420.txt\"
SN.node[*].Communication.Radio.TxOutputPower = $power

# Application parameters
SN.node[*].ApplicationName = $appName
SN.node[*].Application.evaluation = $evaluation
SN.node[*].Application.samplingAlgorithm = \"$algorithm\"
SN.node[*].Application.seed = $seed
SN.node[*].Application.sampleRate = $sampleRate
SN.node[*].Application.bufferSize = $bufferSize
SN.node[0].Application.isSink = true
SN.node[0].Application.collectTraceInfo = true 
SN.node[*].Application.contamination = $event
SN.node[*].Application.displaySampleSensing = false

# Mobility parameters
SN.node[0].MobilityManager.collectTraceInfo = true # Mobility Trace
SN.node[0].MobilityManagerName = \"RandomWalk\"
SN.node[0].MobilityManager.updateInterval = 100
SN.node[0].MobilityManager.xCoorDestination = 0
SN.node[0].MobilityManager.yCoorDestination = 0
SN.node[0].MobilityManager.speed = $speed
SN.node[0].xCoor = 0
SN.node[0].yCoor = 0
" >> $fileName

echo "# Coordinates set individually following SSI deployment." >> $fileName
echo $coords >> $fileName

################ #################### #####################################################

if [ ! -e resultados-erro/$seed'_50_'$event'_erroReconstrucao_'$algorithm'.dat' ] # Check if this seed is already evaluated
then
	echo "omnetpp.ini Generated!"
	nohup Castalia -c General &
	sleep 1s
fi

################ #################### #####################################################

done
done
done

sleep 2m # Wait 2 minutes for Castalia finish until run kriging

#mv Castalia-Trace.txt Castalia-Trace.txt.keep
rm *.txt
#mv Castalia-Trace.txt.keep Castalia-Trace.txt

################ ###### KRIGING ##### #####################################################

for algorithm in "${algorithms[@]}"
do 
	for event in "${events[@]}"
	do
		for seed in "${replications[@]}"
		do 	

			if [ ! -e resultados-erro/$seed'_50_'$event'_erroReconstrucao_'$algorithm'.dat' ] # Check if this seed is already evaluated
			then
				if [ `expr $seed % $threads` -eq 0 ] # Parallelism control HERE 
				then
				    Rscript pairIndexes-Event.R $algorithm $event $seed
				else
				    nohup Rscript pairIndexes-Event.R $algorithm $event $seed &
				fi
			fi
done
done
done

done
