#!/bin/bash

tailleMAX=$3
ajoutTaille=$2

nbTourParTaille=$4


rm -Rf "Resultat"
mkdir "Resultat"

echo "NumAlgo,TailleMat,RunId,Temps" > "Resultat/Resultat.csv"

for algo in 0 2 3
do
	erreur=0
	mkdir "Resultat/Resultat_$algo"
	echo "Algo $algo : "
	taille=$1
	while [ $taille -le $tailleMAX ]
	do
		if [ $taille -le 32 ] || [ $algo -ne 1 ]
		then
			tour=1
			while [ $tour -le $nbTourParTaille ]
			do
				./Test -t $taille -G $algo -n 1 -c 1
				res=`cat "Resultat.txt"`
				rm "Resultat.txt"
				echo "$algo,$taille,$tour,$res" >> "Resultat/Resultat.csv"
				echo "$res" >> "Resultat/Resultat_$algo/taille_$taille" 
				tour=$(($tour+1))
			done
			echo -n "|"
			#mv "Resultat.txt" "Resultat/Resultat_$algo/taille_$taille" 
			#if [ ! -f "Resultat/Resultat_$algo/taille_$taille" ]
			#then
			#	erreur=$erreur:$taille
			#fi
		fi
		taille=$(($taille+$ajoutTaille))
	done
	echo
	echo $erreur > "Resultat/Erreur_$algo.txt"
done

