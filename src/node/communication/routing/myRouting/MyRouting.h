/*******************************************************************************
 *  Copyright: National ICT Australia,  2007 - 2011                            *
 *  Developed at the ATP lab, Networked Systems research theme                 *
 *  Author(s): Athanassios Boulis, Yuriy Tselishchev                           *
 *  This file is distributed under the terms in the attached LICENSE file.     *
 *  If you do not find this file, copies can be found by writing to:           *
 *                                                                             *
 *      NICTA, Locked Bag 9013, Alexandria, NSW 1435, Australia                *
 *      Attention:  License Inquiry.                                           *
 *                                                                             *
 *******************************************************************************/

#ifndef _MYROUTING_H_
#define _MYROUTING_H_

#include <map>
#include "VirtualRouting.h"
#include "MyRoutingPacket_m.h"
#include "MyRoutingControl_m.h"

#define NO_LEVEL  -110
#define NO_SINK   -120

using namespace std;

enum MyRoutingTimers {
	TOPOLOGY_SETUP_TIMEOUT = 1,
};

class MyRouting: public VirtualRouting {
 private:
	int mpathRingsSetupFrameOverhead;	// in bytes
	double netSetupTimeout;

	// multipathRingsRouting-related member variables
	int currentSequenceNumber;
	int currentSinkID;
	int currentLevel;
	int tmpSinkID;
	int tmpLevel;
	bool isSink;		//is a .ned file parameter of the Application module
	bool isConnected;	//attached under a parent node
	bool isScheduledNetSetupTimeout;

 protected:
	void startup();
	void fromApplicationLayer(cPacket *, const char *);
	void fromMacLayer(cPacket *, int, double, double);

	void sendTopologySetupPacket();
	void sendControlMessage(MyRoutingControlDef);

	void timerFiredCallback(int);
	void processBufferedPacket();
};

#endif				//MULTIPATHRINGSROUTINGMODULE
