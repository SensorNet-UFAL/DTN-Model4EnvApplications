# DTN-Model4EnvApplications Quick Start

This guide works on Ubuntu 14.04 (recommended), or 16.04.

1) Installing and configuring:

Part 1.1) Installing Dependencies: OMNeT++ 4.6

	- Castalia is a simulator which works as an expansion of OMNeT ++ libraries, downloadable through the link: 

		https://omnetpp.org/component/jdownloads/download/32-release-older-versions/2290-omnet-4-6 -source-ide-tgz

	1) Uncompress the file in your Home folder.

	2) Press the shortcut ctrl + alt + T and type in the terminal the command:

		sudo gedit .bashrc

	2.1) This command will open a text file with the environment variables, at the end of this file, add the line:

		export PATH=$PATH:$HOME/omnetpp-4.6/bin

	2.2) Save and close the file. Close the terminal to update the added line in the system.

	3) Enter the folder omnetpp-4.6, open terminal inside the folder (right mouse button -> open terminal here) and run the commands:

		sudo apt-get install build-essential gcc g++ bison flex perl tcl-dev tk-dev libxml2-dev zlib1g-dev default-jre doxygen graphviz libwebkitgtk-1.0-0

		./configure

		make

	4) After completing the procedure above, test the installation of OMNeT ++ with the commands:

		cd samples/dyna

		./dyna

	For further information about OMNeT++, the complete installation guide is available at the following link: https://omnetpp.org/doc/omnetpp/InstallGuide.pdf

Part 1.2) Configuring Castalia

	1) Press the shortcut ctrl + alt + T and clone the git files on your home folder.

		git clone https://github.com/isrvasconcelos/DTN-Model4EnvApplications.git

	2) On the same terminal window, type the command:

		sudo gedit .bashrc

	2.1) This command will open a text file with the environment variables, at the end of this file, add the line:

		export PATH=$PATH:$HOME/DTN-Model4EnvApplications/bin

	2.2) Save and close the file. Close the terminal to update the added line in the system.

	3) Enter the folder Castalia-3.2, open terminal inside the folder and run the following command to compile the simulator:

		sh fastMake.sh

	3.1) Note: Whenever you change some source file from the /src folder, you need to recompile the simulator via the command above in order to update the changes.

	4) Go to the folder /Simulations/other-simulations/valueReporting-untouched and test the sample simulations with the command:

		Castalia -c General

--------------------------------------------------------------------------------------------------------------------------------------------------------

2) Running the simulations

Part 2.1) Installing dependencies and generating inputs:

	1) Go to the folder /DTN-Model4EnvApplications/Parameters/headers, install dependencies for R Scripts:

		sudo apt-get install r-base

		Rscript dependencies-InstallAndRun.R

	2) All Input files with field samples, nodes deployment and Voronoi diagrams was already generated, but if you want to generate again, run the command:

		sh generateInputs.sh
		

Part 2.2) Running the simulations:

	1) All the files generated at command above will be saved at the folder /DTN-Model4EnvApplications/Parameters/NodesData


	2) Simulations are located at folder /DTN-Model4EnvApplications/Simulations, on the subfolders:

		2.1) /varyBuffer

		2.2) /varyModel

		2.3) /varyNodes

		2.4) /varyPower

		2.5) /varySampleRate

		2.6) /varySpeed

		2.7) /varyTime


	Run the .sh script inside the choosen subfolder, for example, at /DTN-Model4EnvApplications/Simulations/varyBuffer:

		sh varyBuffer.sh

	Note: these .sh scripts have a parallelism parameter to control how many processes will run simultaneously called "threads", set to 8 by default. Increase it if you have a strong machine or will run it on a server will many CPU-cores.


Part 2.3) Evaluate results and Generate the plots:

	1) When the simulation finish, run the script to evaluate the results:
		
		Rscript pairIndexes-Nodes.R

	 Results will be stored at subfolders /resultados-erro and /resultados-cobertura


	2) Inside the folders /resultados-erro and /resultados-cobertura, search for R scripts to plot the graphics, for example,
	at /DTN-Model4EnvApplications/Simulations/varyBuffer/resultados-erro:

		Rscript plotGraphic-Error-Buffer.R

--------------------------------------------------------------------------------------------------------------------------------------------------------
