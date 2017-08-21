#include "algorithms.h"

bool compareSample(pair<double,int> s1, pair<double,int> s2) {

	double i = get<0>(s1);
	double j = get<0>(s2);

	return (i<j);
}

unordered_map<string, vector< pair<double,int> >> dropRandom(unordered_map<string, vector< pair<double,int> >> sinkBuffer) {

	cout << "Running Drop Random." << endl;
	unordered_map<string, vector< pair<double,int> >> reducedBuffer = sinkBuffer;
	vector <string> keys;

	for (auto& x: reducedBuffer)
		keys.push_back(x.first); // Check the keys inside the hash

	int dropPointer = rand() % keys.size(); // Point to a random key (node)

	reducedBuffer.erase(keys[dropPointer]); // Drop it
	cout << keys[dropPointer] << " Removed." << endl;

	return reducedBuffer;
}

unordered_map<string, vector< pair<double,int> >> sampleCentral(unordered_map<string, vector< pair<double,int> >> sinkBuffer, int sampleRate, string nodeID)
{
	cout << "Running Sampling Central." << endl;
	unordered_map<string, vector< pair<double,int> >> reducedBuffer = sinkBuffer;
	vector < pair<double,int> > newData;

	int dataLength = reducedBuffer.at(nodeID).size();

	sort(reducedBuffer.at(nodeID).begin(), reducedBuffer.at(nodeID).end(), compareSample);
	
	int newSize = dataLength*sampleRate/100; // Length of reduced sample vector
	if(!newSize)
		newSize++;

	int sampleIndex = (dataLength - newSize)/2; // Pointer to the index which will start the sampling

	for(int i=sampleIndex; i<(sampleIndex+newSize); i++) // Sampling central data
		newData.push_back(reducedBuffer.at(nodeID)[i]);

	reducedBuffer.at(nodeID) = newData;
	newData.clear();

	return reducedBuffer;
}
