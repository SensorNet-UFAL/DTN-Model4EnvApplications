/****************************************************************************
 *  Copyright: National ICT Australia,  2007 - 2011                         *
 *  Developed at the ATP lab, Networked Systems research theme              *
 *  Author(s): Dimosthenis Pediaditakis, Yuriy Tselishchev                  *
 *  This file is distributed under the terms in the attached LICENSE file.  *
 *  If you do not find this file, copies can be found by writing to:        *
 *                                                                          *
 *      NICTA, Locked Bag 9013, Alexandria, NSW 1435, Australia             *
 *      Attention:  License Inquiry.                                        *
 *                                                                          *
 ****************************************************************************/

#include "ValueReporting.h"

Define_Module(ValueReporting);

/********************************* ESSENTIALS ****************************************************************/

void ValueReporting::startup()
{
	// Importing defaults from .ned
	maxSampleInterval = ((double)par("maxSampleInterval")) / 1000.0;
	minSampleInterval = ((double)par("minSampleInterval")) / 1000.0;
	currSentSampleSN = 0;
	randomBackoffIntervalFraction = genk_dblrand(0);
	sentOnce = false;
	setTimer(REQUEST_SAMPLE, maxSampleInterval * randomBackoffIntervalFraction);
	loopControl=0;
	keepSampling=1;

	// Output file info
	seed = par("seed");
	numNodes = par("nodes");
	sinkSpeed = par("sinkSpeed");
	sampleRate = par("sampleRate");
	bufferSize = par("bufferSize");
	contamination = par("contamination");
	evaluation = par("evaluation").stringValue();
	samplingAlgorithm = par("samplingAlgorithm").stringValue();
	string tx = getParentModule()->getSubmodule("Communication")->getSubmodule("Radio")->par("TxOutputPower");
	txPower = tx;

	// Getting simulation time limit
	string simTimeToStr(ev.getConfig()->getConfigValue("sim-time-limit"));
	simTimeToStr.pop_back();
	timeLimit = stod(simTimeToStr);

	// Sink parameters
	hold = false;
	notifyLocationPeriod = 20;
	bufferFree = par("bufferSize");

	// Node parameter
	done = false;
	displaySampleSensing = par("displaySampleSensing");

	double x_coor = mobilityModule->getLocation().x;
	double y_coor = mobilityModule->getLocation().y;
	trace() << "Current location: (" << x_coor << "," << y_coor << ")";

}

void ValueReporting::handleSensorReading(SensorReadingMessage * rcvReading)
{
	if (!isSink) {
		double sensValue = rcvReading->getSensedValue();
		nodeBuffer.push(sensValue);

		if(displaySampleSensing)
			trace() << "Sensed = " << sensValue; // Uncomment to display the samples
	}

	sentOnce = true;
}

void ValueReporting::sampleWith(string name) { // Add here a call for new sampling algorithms

	if(name=="DropRandom")
		sinkBuffer = dropRandom(sinkBuffer);
	
	else if(name=="SampleCentral") { 

		for(int i=0; i<dropQueue.size()-1; i++) // Empty the drop queue with pending nodes (keep the last element because its data maybe incomplete)
			sinkBuffer = sampleCentral(sinkBuffer, sampleRate, dropQueue.at(i));

		if(dropQueue.size()==1) // If there is a single element, sample it
			sinkBuffer = sampleCentral(sinkBuffer, sampleRate, dropQueue.front());

		dropQueue.clear();
		sampleRate = par("sampleRate");
	} 

	else
		name = "None";

	trace() << "Sampling algorithm: " << name;
	updateFreeBuffer();
	avoidLoop();
}

/********************************* COMMUNICATION *************************************************************/

void ValueReporting::timerFiredCallback(int index)
{
	// Getting simulation time | [Sep, 2016]: Moved to startup(), timeLimit became a global variable
	//string simTimeToStr(ev.getConfig()->getConfigValue("sim-time-limit"));
	//simTimeToStr.pop_back();
	//double timeLimit = stod(simTimeToStr);

	if (isSink) { // STEP (1) SINK: Send a broadcast message requesting the readings from nodes, nodes just a toggle boolean to true when receive
		
		/*if(simTime() > notifyLocationPeriod) { // Just notifying the location periodically 
			notifyLocationPeriod = notifyLocationPeriod+20;

			double x_coor = mobilityModule->getLocation().x;
			double y_coor = mobilityModule->getLocation().y;
			trace() << "[SINK] Current location: (" << x_coor << "," << y_coor << ")" << endl;

		}*/

		if (simTime()>50 && keepSampling) { // Broadcasting
			ValueReportingDataPacket *packet2Net = createControlPkt("broadcast");
			toNetworkLayer(packet2Net, BROADCAST_NETWORK_ADDRESS);
		} 
	}

	switch (index) {
		case REQUEST_SAMPLE:{
			requestSensorReading();
			setTimer(REQUEST_SAMPLE, minSampleInterval);
			break;
		}
	}

	if(isSink && simTime() > timeLimit-maxSampleInterval) // Write to a file the last state of sink buffer
		outputSinkBuffer();
}

/********************************* COMMUNICATION *************************************************************/

void ValueReporting::fromNetworkLayer(ApplicationPacket * genericPacket,
		 const char *source, double rssi, double lqi)
{

	double x_coor = mobilityModule->getLocation().x;
	double y_coor = mobilityModule->getLocation().y;

	if (!isSink) { // STEP (2) Nodes: Check broadcast messages, if received: just toggle a boolean to true  
		ValueReportingDataPacket *rcvPacket = check_and_cast<ValueReportingDataPacket*>(genericPacket);
		ValueReportData theData = rcvPacket->getExtraData();

		string command(theData.command.buffer()); //theData.command is a type of opp_string, method .buffer() asserts it to char* -> string.
		double dist = sqrt(pow(theData.locX-x_coor,2) + pow(theData.locY-y_coor,2));

		if(command == "broadcast") {// Check broadcast msg -> Enabling the data exchange
			if(!done) {
				ValueReportingDataPacket *packet2Net = createControlPkt("withinRange"); // Notifies sink that this node is near
				toNetworkLayer(packet2Net, SINK_NETWORK_ADDRESS);
			}
		}

		if(command == "ackReady") { // ACK to ensure proximity = Send the samples now
			trace() << "Received an ACK from sink: Starting the transmission.";
			trace() << "Distance to sink: " << dist << "m.";

			if(!done && simTime()>50) { // STEP (3) Send the data ##########
				if (nodeBuffer.size() > 0) {

					int bufferLength = nodeBuffer.size();
					int toSend = 15; // 4x bursts of 15 = 60 pkt/s
					
					if (bufferLength < toSend) 
						toSend = bufferLength;

					for(int i=0; i<toSend; i++) {
						ValueReportingDataPacket* packet2Net = createDataPkt(nodeBuffer.front(), currSentSampleSN); //sensVal nodeBuffer[0]
						nodeBuffer.pop();
						currSentSampleSN++;
						toNetworkLayer(packet2Net, SINK_NETWORK_ADDRESS); // SENDING DATA HERE: ToNetworkLayer()
					}

					trace() << "[DONE!] " << toSend-1 << " samples was sent successfully. / " << nodeBuffer.size() << " samples pending." << endl;
				} 
			
				if (nodeBuffer.size() == 0 && !done) // if(done == true) -> stop the sending of all packets
					done=true;
			}
		}
	}

/********************************* COMMUNICATION *************************************************************/

	else { // STEP (4) Sink: Check and execute the command received

		ValueReportingDataPacket *rcvPacket = check_and_cast<ValueReportingDataPacket*>(genericPacket);
		ValueReportData theData = rcvPacket->getExtraData(); 
		string command(theData.command.buffer()); //theData.command is a type of opp_string, method .buffer() asserts it to char* -> string.

		string ID = to_string(theData.nodeID);
		const char * senderID = ID.c_str(); // Just converting string to const char*

		double dist = sqrt(pow(theData.locX-x_coor,2) + pow(theData.locY-y_coor,2));

		// Check control messages
		if (command == "withinRange") {
			trace() << "Node " << ID << " is near: " << dist << "m.";
			trace() << "[SINK] Current location: (" << x_coor << "," << y_coor << ")" << endl;
			ValueReportingDataPacket *packet2Net = createControlPkt("ackReady"); // ACK to ensure proximity = Send the samples now
			toNetworkLayer(packet2Net, senderID); //senderID
		 }

		/****************************************************/

		if (command == "data_pkt" && bufferFree > 0) {

			unordered_map<string, vector< pair<double,int> > >::const_iterator check = sinkBuffer.find(ID); //Check: ID's already in the hash

			pair<double,int> sample(rcvPacket->getData(),rcvPacket->getSequenceNumber()); // Seq. number to avoid loss of (x,y) location

			if(check != sinkBuffer.end()) { // Hit the data location
				sinkBuffer.at(ID).push_back(sample); 
				//trace() << "Sink received from: " << theData.nodeID << " \tvalue=" << rcvPacket->getData();

			} else { // First data entry from this node
				vector< pair<double,int> > tempVector;
				tempVector.push_back(sample);

				sinkBuffer.insert({ID, tempVector});
				trace() << "New hash entry added (!)";
				trace() << "Sink received from: " << theData.nodeID << " \tvalue=" << rcvPacket->getData();
			}

			bufferFree--;
			dropQueueAppend(ID); // Add the current node to the drop queue
		}

		/****************************************************/

		if (bufferFree <= 10) {
			trace() << "Buffer is full.";
			sampleWith(samplingAlgorithm);
		}

		//else { if(hold==true ) {wait n times -> hold = false} } : control stop forever
	}
}

/***************************** PACKET HANDLER **************************************************************/

ValueReportingDataPacket* ValueReporting::createControlPkt(string command)
{
	char* comm = strdup(command.c_str()); // coercing to the accepted type: char*
	int sensValue = 0;

	ValueReportData tmpData;
	tmpData.nodeID = (unsigned short)self;
	tmpData.locX = mobilityModule->getLocation().x;
	tmpData.locY = mobilityModule->getLocation().y;
	tmpData.command = comm;

	ValueReportingDataPacket *packet2Net =
	    new ValueReportingDataPacket(comm, APPLICATION_PACKET);

	packet2Net->setExtraData(tmpData);
	packet2Net->setData(sensValue);

	return(packet2Net);
}

ValueReportingDataPacket* ValueReporting::createDataPkt(double sensValue, int seqNumber)
{
	ValueReportData tmpData;
	tmpData.nodeID = (unsigned short)self;
	tmpData.locX = mobilityModule->getLocation().x;
	tmpData.locY = mobilityModule->getLocation().y;
	tmpData.command = "data_pkt";

	ValueReportingDataPacket *packet2Net =
	    new ValueReportingDataPacket("data_pkt", APPLICATION_PACKET);
	packet2Net->setExtraData(tmpData);
	packet2Net->setData(sensValue);
	packet2Net->setSequenceNumber(currSentSampleSN);

	return(packet2Net);
}

/************************************** AUXILIAR *************************************************************/

// Bugs may occur with higher sample rates.
// To avoid the errors in runtime: This function stops the overall procedure to avoid simulation crashes
void ValueReporting::avoidLoop()
{
	int currentSize=0;
	int maxSize=par("bufferSize");
	
	for (auto& x: sinkBuffer) {
		for(int i=0; i<x.second.size(); i++)
			currentSize++;
	}

	if(currentSize > 0.95*maxSize)
		loopControl++;
	else 
		loopControl=0;

	if(loopControl>350) { // Control here the threshold for non-effectives algorithm run
		trace() << "Emergency loop avoidance routine running: Stopping Sampling Algorithm.";
		keepSampling=false;

	//if(samplingAlgorithm == "DropRandom")
			//keepSampling=false;

	//if(samplingAlgorithm == "SampleCentral")
			//sampleRate=80;
	}
}

void ValueReporting::updateFreeBuffer()
{
	int currentSize=0;
	int maxSize=par("bufferSize");
	
	for (auto& x: sinkBuffer) {
		for(int i=0; i<x.second.size(); i++)
			currentSize++;
	}

	if(currentSize <= maxSize)
		bufferFree = maxSize - currentSize; // Update the buffer-free control variable ONLY HERE

	else
		trace() << "ERROR! SINK BUFFER OVERHEAD.";

	trace() << "Current size: " << currentSize << "/ From: " << maxSize << " units" << endl;
}

void ValueReporting::dropQueueAppend(string ID)
{
	bool addToQueue=true;

 	for(int i=0; i<dropQueue.size(); i++) { // Check if this ID is already in queue 

		if(ID == dropQueue.at(i)) { // Avoid duplicate IDs
			addToQueue=false;
			break;
		}
	}

	if(addToQueue)
		dropQueue.push_back(ID); // Add the last sending node to drop queue
}

string ValueReporting::generateFileNamePrefix()
{

	trace() << "Obs.: REMEMBER TO CREATE SUBFOLDER /RemainingIndexes IN SIMULATION FOLDER (!)";
	string fileNamePrefix = "RemainingIndexes/"+to_string(seed)+"-";

	if (evaluation == "varyPower")
		fileNamePrefix.append(evaluation+"-"+txPower+"-");

	if (evaluation == "varySpeed")
		fileNamePrefix.append(evaluation+"-"+to_string(sinkSpeed)+"-");

	if (evaluation == "varyNodes")
		fileNamePrefix.append(evaluation+"-"+to_string(numNodes)+"-");	

	if (evaluation == "varyTime")
		fileNamePrefix.append(evaluation+"-"+to_string(timeLimit)+"-");

	if (evaluation == "varyBuffer")
		fileNamePrefix.append(evaluation+"-"+to_string(bufferSize)+"-");

	if (evaluation == "varyEvent")
		fileNamePrefix.append(evaluation+"-"+to_string(contamination)+"-");

	if (evaluation == "varySampleRate")
		fileNamePrefix.append(evaluation+"-"+to_string(bufferSize)+"-"+to_string(sampleRate)+"-");
	
	fileNamePrefix.append(samplingAlgorithm+"-");

	return fileNamePrefix;
}

/************************************** EXPORT *************************************************************/

void ValueReporting::outputSinkBuffer() // OBS.: The first element from each line is the respective node ID
{
	// Exporting remaining indexes to match with initial hash
	ofstream outputSinkBuffer;
	string strSinkBuffer = "";
	string fileName = generateFileNamePrefix()+"remainingIndexes.csv";
	
	outputSinkBuffer.open (fileName);

	for (auto& x: sinkBuffer) {
		strSinkBuffer.append(x.first+","); // First element of line,  x.first, is a string containing the node ID:
		for(int i=0; i<x.second.size(); i++)
			strSinkBuffer.append(to_string(get<1>(x.second[i]))+","); // x.second[i] is a pair<double,int> | Get the indexes with get<1>

		strSinkBuffer.append("\n"); 
	}

	outputSinkBuffer << strSinkBuffer;
	outputSinkBuffer.close();

	trace() << "Last state of sink buffer was exported to " << fileName;
}

void ValueReporting::outputSinkBufferSamples() // OBS.: The first element from each line is the respective node ID
{
	ofstream outputSinkBuffer;

	// Exporting samples
	string strSinkBuffer = "";
	string fileName = generateFileNamePrefix()+"remainingSamples.csv";
	outputSinkBuffer.open (fileName);

	for (auto& x: sinkBuffer) {
		strSinkBuffer.append(x.first+","); // First element of line is the node
		for(int i=0; i<x.second.size(); i++)
			strSinkBuffer.append(to_string(get<0>(x.second[i]))+","); // x.second[i] is a pair<double,int> | Get the samples with get<0>

		strSinkBuffer.append("\n"); 
	}

	outputSinkBuffer << strSinkBuffer;
	outputSinkBuffer.close();

	trace() << "Last state of sink buffer was exported to " << fileName;

}
