/******************************************************************
*								  *
* Israel Vasconcelos 						  *
* Mar, 2016							  *
* Data reduction algorithms for intermettently connected networks *
*								  *
*	      [Define a new algorithm for test here]		  *
*								  *
*******************************************************************/

#ifndef __ALGORITHMS_H_INCLUDED__
#define __ALGORITHMS_H_INCLUDED__

#include <unordered_map>
#include <algorithm>
#include <iostream>
#include <utility>
#include <fstream>
#include <vector>
#include <queue> 

using namespace std;

bool compareSample(pair<double,int> s1, pair<double,int> s2);
unordered_map<string, vector< pair<double,int> >> dropRandom(unordered_map<string, vector< pair<double,int> >> sinkBuffer);
unordered_map<string, vector< pair<double,int> >> sampleCentral(unordered_map<string, vector< pair<double,int> >> sinkBuffer, int sampleRate, string nodeID);

#endif
