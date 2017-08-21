// unordered_map::insert
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

using namespace std;

int main () {

	unordered_map<string,vector<double>> maptest;

	vector <double> temp;
	vector <double> temp2;

	temp.push_back(2);
	temp.push_back(3);
	temp.push_back(4);

	pair<string,vector<double>> data1("1",temp);
	pair<string,vector<double>> data2("5",temp);
	pair<string,vector<double>> data3("12",temp);
	pair<string,vector<double>> data4("9",temp);

	temp.push_back(8);
	temp.push_back(5);

	pair<string,vector<double>> data5("3",temp);

	maptest.insert(data1);
	maptest.insert(data2);
	maptest.insert(data3);
	maptest.insert(data4);
	maptest.insert(data5);

	for (auto& x: maptest) {
		cout << "Element " << x.first;
		cout << " is in bucket #" << maptest.bucket (x.first) << " -> ";

		temp2 = maptest.at(x.first);

		for (int j=0;j<temp2.size();j++)
			cout << temp2[j] << " ";

		cout << endl;
	}

	for (auto& x: maptest) {
		cout << "Element " << x.first;
		cout << " is in bucket #" << maptest.bucket (x.first) << " -> ";

		maptest.at(x.first).push_back(22); // Appending a new element
		temp2 = maptest.at(x.first);

		for (int j=0;j<temp2.size();j++)
			cout << temp2[j] << " ";

		cout << endl;
	}

	unordered_map<string,vector<double>>::const_iterator got = maptest.find("3");

	if(got == maptest.end()) {
		cout << "OI" << endl;
	} else {
		cout << got->first << endl;
		maptest.at(got->first).push_back(9);
	}

	for (auto& x: maptest) {
		cout << "Element " << x.first;
		cout << " is in bucket #" << maptest.bucket (x.first) << " -> ";

		temp2 = maptest.at(x.first);

		for (int j=0;j<temp2.size();j++)
			cout << temp2[j] << " ";

		cout << endl;
	}

	return 0;
}
