# Parallelism control HERE
threads=3

# Seed Replications
replications=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30)
algorithms=('DropRandom' 'SampleCentral')
events=(0 1)

################ ###### KRIGING ##### #####################################################

for repeat in 1 2 3
do

for algorithm in "${algorithms[@]}"
do 
	for event in "${events[@]}"
	do
		for seed in "${replications[@]}"
		do 

			if [ ! -e resultados-erro/$seed'_50_'$event'_erroReconstrucao_'$algorithm'_Ideal.dat' ] # Check if this seed is already evaluated
			then
				if [ `expr $seed % $threads` -eq 0 ] # Parallelism control HERE 
				then
				    Rscript pairIndexes-Model.R $algorithm $event $seed
				else
				    nohup Rscript pairIndexes-Model.R $algorithm $event $seed &
				fi
			fi
done
done
done

done
