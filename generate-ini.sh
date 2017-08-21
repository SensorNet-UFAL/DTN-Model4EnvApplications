simPath=Simulations/ogk/
fileName='Simulations/ogk/omnetpp.ini'

echo "Generating Castalia configuration file omnetpp.ini"

echo "" >> $fileName # simply to avoid warning outputs if the file doesn't exist
rm $fileName # overwrite the old file

############### Simulation parameters #####################################################

simTime=1000 # seconds

numNodes=100
fieldLength=100 # meters
speed=5 # m/s

deployment='""'
power='"-5dBm"'
appName='"ThroughputTest"'

applicationTrace='true'
mobilityTrace='true'

pktRate=5
pktSize=32

################ .ini file generation #####################################################

information='# This script was generated automatically.
# Coordinates of nodes were set individually following SSI deployment from file "deployment.R"
# Author: Israel Vasconcelos
# Federal University of Alagoas
# Sep, 2015

[General]

include ../Parameters/Castalia.ini'

echo "$information" >> $fileName

echo "
sim-time-limit = ${simTime}s

SN.field_x = $fieldLength # meters
SN.field_y = $fieldLength # meters

SN.numNodes = $numNodes
SN.deployment = $deployment # SSI (Baddeley, 2007)

SN.wirelessChannel.onlyStaticNodes = false
SN.wirelessChannel.sigma = 0
SN.wirelessChannel.bidirectionalSigma = 0

SN.node[*].Communication.Radio.RadioParametersFile = \"../Parameters/Radio/CC2420.txt\"
SN.node[*].Communication.Radio.TxOutputPower = $power

SN.node[*].ApplicationName = $appName
SN.node[*].Application.packet_rate = $pktRate
SN.node[*].Application.constantDataPayload = $pktSize # Packet size in bytes

SN.node[0].Application.collectTraceInfo = $applicationTrace # Application Trace
SN.node[0].MobilityManager.collectTraceInfo = $mobilityTrace # Mobility Trace

SN.node[0].xCoor = 0
SN.node[0].yCoor = 0

# Mobility parameters
SN.node[0].MobilityManagerName = \"RandomWalk\"
SN.node[0].MobilityManager.updateInterval = 100
SN.node[0].MobilityManager.xCoorDestination = 0
SN.node[0].MobilityManager.yCoorDestination = 0
SN.node[0].MobilityManager.speed = $speed
" >> $fileName

echo "Evaluating SSI deployment"

Rscript deployment.R $numNodes $fieldLength

echo "# Coordinates set individually following SSI deployment." >> $fileName

coordsInfo=`cat coords.dat`
echo "$coordsInfo" >> $fileName

################ #################### #####################################################

echo "omnetpp.ini Generated!"

cd $simPath
#Castalia -c General
