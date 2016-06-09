#!/bin/bash

tailleMAX=$3
ajoutTaille=$2

nbTourParTaille=$4

rm -Rf "Resultat"
mkdir "Resultat"

for algo in 2 3
do
	mkdir "Resultat/Resultat_$algo"
	echo "Algo $algo : "
	taille=$1
	while [ $taille -le $tailleMAX ]
	do
		./Test -t $taille -G $algo -n $nbTourParTaille -c 1
		echo -n "|"
		mv "Resultat.txt" "Resultat/Resultat_$algo/taille_$taille" 
		if [ ! -f "Resultat/Resultat_$algo/taille_$taille" ]
		then
			erreur=$erreur:$taille
		fi
		taille=$(($taille + $ajoutTaille))
	done
	echo
done
