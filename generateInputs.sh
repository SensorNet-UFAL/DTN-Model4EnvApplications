fieldLength=100 # meters

for numNodes in 50 # 25 75 100
do 
	for seed in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 21 22 23 24 25 26 27 28 29 30
	do

		echo "Evaluating SSI deployment and Voronoi Cells"
		Rscript Simulations/Parameters/headers/deployment.R $numNodes $fieldLength $seed

	done
done
