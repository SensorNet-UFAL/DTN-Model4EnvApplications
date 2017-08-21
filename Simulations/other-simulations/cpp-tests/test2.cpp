
#include <stdio.h>
#include <string.h>
#include <typeinfo>
#include <iostream>
#include <queue>
using namespace std;

int main ()
{
	queue<double> x;

	x.push(10);
	x.push(1);
	x.push(20);

	cout << x.front() << endl;
	x.pop();
	cout << x.front() << endl;

}
