fieldLength=100 # meters
event=0

for numNodes in 50 20 35 100
do 
	for seed in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
	do

		echo "Evaluating SSI deployment and Voronoi Cells"

			if [ `expr $seed % 6` -eq 0 ] # Parallelism control HERE 
			then
			    Rscript deployment.R $numNodes $fieldLength $seed $event
			else
			    nohup Rscript deployment.R $numNodes $fieldLength $seed $event &
			fi
	done
done

event=1
for numNodes in 50
do 
	for seed in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
	do

		echo "Evaluating SSI deployment and Voronoi Cells"

			if [ `expr $seed % 6` -eq 0 ] # Parallelism control HERE 
			then
			    Rscript deployment.R $numNodes $fieldLength $seed $event
			else
			    nohup Rscript deployment.R $numNodes $fieldLength $seed $event &
			fi
	done
done
