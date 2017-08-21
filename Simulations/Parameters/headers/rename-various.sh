# Seed Replications
replications=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30)
algorithms=('SampleCentral' 'DropRandom')
events=(0 1)


################ ###### KRIGING ##### #####################################################

for algorithm in "${algorithms[@]}"
do 
	for event in "${events[@]}"
	do
		for seed in "${replications[@]}"
		do 	

			oldFileName=$seed'_50_'$event'_erroReconstrucao_'$algorithm'.dat'
			newFileName=$seed'_50_'$event'_erroReconstrucao_'$algorithm'_Ideal.dat'

			    mv  $oldFileName $newFileName

done
done
done


