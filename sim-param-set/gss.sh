#Gera o script para ser executado

for reducao in 10 25 50
do 

	for sensores in 100
	do

			for seed in 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77
			do 

				for contaminacao in 0 1
				do

echo "nohup Rscript df-script.R $reducao $contaminacao $sensores $seed &"
echo "nohup Rscript dl-script.R $reducao $contaminacao $sensores $seed &"
echo "nohup Rscript dr-script.R $reducao $contaminacao $sensores $seed &"
echo "nohup Rscript ogk-script.R $reducao $contaminacao $sensores $seed &"
echo "\n"
done
done
done
done
