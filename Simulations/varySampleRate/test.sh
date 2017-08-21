# Seed Replications
replications=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30)
algorithms=('SampleCentral' 'DropRandom') # Keep DropRandom on the last position in order to breakpoints at loops work correctly
bufferSizes=(500 1000 1500 2000)
sampleRates=(5 10 25 50)

for i in {1..2} # Repeat until succeed
do

# Variable paraters
for algorithm in "${algorithms[@]}"
do 
	for sampleRate in "${sampleRates[@]}"
	do 
		for bufferSize in "${bufferSizes[@]}"
		do
			for seed in "${replications[@]}"
			do
				echo "$algorithm $sampleRate $bufferSize $seed"

done
done
	if [ "$algorithm" = "DropRandom" ] # SampleRate varying is not applicable on DropRandom
	then
		echo "DropRandom Breakpoint1"
		break
	fi
done
done

# Variable paraters
for algorithm in "${algorithms[@]}"
do 
	for sampleRate in "${sampleRates[@]}"
	do 
		for bufferSize in "${bufferSizes[@]}"
		do
			for seed in "${replications[@]}"
			do
				echo "$algorithm $sampleRate $bufferSize $seed"

done
done
	if [ "$algorithm" = "DropRandom" ] # SampleRate varying is not applicable on DropRandom
	then
		echo "DropRandom Breakpoint2"
		break
	fi
done
done

done
