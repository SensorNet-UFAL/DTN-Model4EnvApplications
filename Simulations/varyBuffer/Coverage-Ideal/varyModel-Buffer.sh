# Parallelism control HERE
threads=2

# Seed Replications
replications=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30)
bufferSizes=(500 1000 1500 2000 2500)
algorithms=('DropRandom' 'SampleCentral')

################ ###### COVERAGE ##### #####################################################

for repeat in 1
do

for algorithm in "${algorithms[@]}"
do 
	for bufferSize in "${bufferSizes[@]}"
	do 
		for seed in "${replications[@]}"
		do 
		#---------------------------------------------------------------------
			if [ ! -e resultados-cobertura/$seed'_50_'$bufferSize'_coverage_'$algorithm'_Ideal.dat' ] # Check if this seed is already evaluated
			then 	
				if [ `expr $seed % $threads` -eq 0 ] # Parallelism control HERE 
				then
				    Rscript pairIndexes-Model-Buffer.R $algorithm $bufferSize $seed
				else
				    nohup Rscript pairIndexes-Model-Buffer.R $algorithm $bufferSize $seed &
				fi
			fi
done
done
done

done
