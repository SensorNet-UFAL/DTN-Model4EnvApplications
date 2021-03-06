/****************************************************************************
 *  Copyright: National ICT Australia,  2007 - 2010                         *
 *  Developed at the ATP lab, Networked Systems research theme              *
 *  Author(s): Yuriy Tselishchev                                            *
 *  This file is distributed under the terms in the attached LICENSE file.  *
 *  If you do not find this file, copies can be found by writing to:        *
 *                                                                          *
 *      NICTA, Locked Bag 9013, Alexandria, NSW 1435, Australia             *
 *      Attention:  License Inquiry.                                        *
 *                                                                          *  
 ****************************************************************************/

#include "randomWalk.h"
#include <cstdlib>

#include <iostream>
using namespace std;

Define_Module(RandomWalk);

void RandomWalk::initialize()
{
	VirtualMobilityManager::initialize();

	updateInterval = par("updateInterval");
	updateInterval = updateInterval / 1000;

	loc1_x = nodeLocation.x;
	loc1_y = nodeLocation.y;
	loc1_z = nodeLocation.z;

	xCoorDest = par("xCoorDestination");
	yCoorDest = par("yCoorDestination");
	zCoorDest = par("zCoorDestination");

	xLength = network->par("field_x");
	yLength = network->par("field_y");

	speed = par("speed");
	hold = par("hold");

	reached = 0;
	keepWalking = true;

	if (speed > 0) {

		double xNextRandomPoint = rand() % (int) xLength;
		double yNextRandomPoint = rand() % (int) yLength;

		lineMobility(xNextRandomPoint, yNextRandomPoint);

		setLocation(loc1_x, loc1_y, loc1_z);
		scheduleAt(simTime() + updateInterval,
			new MobilityManagerMessage("Periodic location update message", MOBILITY_PERIODIC));
	}

	setTimeToBack();
	outputInfo();
}

void RandomWalk::handleMessage(cMessage * msg)
{
	int msgKind = msg->getKind();

	switch (msgKind) {

		case MOBILITY_PERIODIC:{

			if (simTime() > timeToBack && keepWalking != false) {
				keepWalking = false;
				trace() << "Time to go to the last point.";

				lineMobility(xCoorDest, yCoorDest); // Destination coords
			}

			if (reached == 0) { // Go on a straight line
				nodeLocation.x += incr_x;
				nodeLocation.y += incr_y;
				nodeLocation.z += incr_z;

				if (   (incr_x > 0 && nodeLocation.x > loc2_x)
				    || (incr_x < 0 && nodeLocation.x < loc2_x)
				    || (incr_y > 0 && nodeLocation.y > loc2_y)
				    || (incr_y < 0 && nodeLocation.y < loc2_y)
				    || (incr_z > 0 && nodeLocation.z > loc2_z)
				    || (incr_z < 0 && nodeLocation.z < loc2_z)) {
					nodeLocation.x -= (nodeLocation.x - loc2_x) * 2;
					nodeLocation.y -= (nodeLocation.y - loc2_y) * 2;
					nodeLocation.z -= (nodeLocation.z - loc2_z) * 2;
					reached = 1;
				}
			}

			else {
				if(keepWalking == true) { // Set new random points
					double xNextRandomPoint = rand() % (int) xLength;
					double yNextRandomPoint = rand() % (int) yLength;

					lineMobility(xNextRandomPoint, yNextRandomPoint);
					reached = 0;
				}
			}

			notifyWirelessChannel();
			scheduleAt(simTime() + updateInterval,
				new MobilityManagerMessage("Periodic location update message", MOBILITY_PERIODIC));

			break;
		}

		default:{
			trace() << "WARNING: Unexpected message " << msgKind;
		}
	}

	delete msg;
	msg = NULL;
}


void RandomWalk::lineMobility(double xNextPoint, double yNextPoint) {

	trace() << "Next points: " << xNextPoint << "," << yNextPoint;

	loc1_x = nodeLocation.x;
	loc1_y = nodeLocation.y;
	loc1_z = nodeLocation.z;

	loc2_x = xNextPoint;
	loc2_y = yNextPoint;

	distance = sqrt(pow(loc1_x - loc2_x, 2) + pow(loc1_y - loc2_y, 2) +
		 pow(loc1_z - loc2_z, 2));

	double tmp = (distance / speed) / updateInterval;
	incr_x = (loc2_x - loc1_x) / tmp;
	incr_y = (loc2_y - loc1_y) / tmp;
	incr_z = (loc2_z - loc1_z) / tmp;

}

/* Israel:
* This function evaluates the time when the mobile node should finish its displacement 
* based on the longest time to move from a point to other inside the area, i.e., the diagonal.
*
* When the time remaining until the simulation finish is equals than the time for cross the diagonal,
* mobile node will be able to arrive at end point before simulation ends, in worst case.
*/ 
void RandomWalk::setTimeToBack() {

	string strSimuTime = ev.getConfig()->getConfigValue("sim-time-limit"); // Getting value from sim-time-limit
	strSimuTime.pop_back(); // Fix the value by deleting last letter 's'

	simuTime = stoi(strSimuTime); 

	double maxDist = sqrt(pow(xLength, 2) + pow(yLength, 2)); // Evaluating diagonal's length
	double maxTime = maxDist/speed; // Time in seconds	

	timeToBack = simuTime - maxTime;
}

void RandomWalk::outputInfo() {

	trace() << "Time to back: " << timeToBack;
	trace() << "Field Size: " << xLength << "," << yLength;
	trace() << "Simulation time: " << simuTime << " seconds";
	trace() << "Sink speed: " << speed << " m/s";
}
