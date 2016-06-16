#!/bin/bash

algo=CPU1
arg=

tailleMAX=$3
ajoutTaille=$2

nbTourParTaille=$4


if [ ! -d "Resultat" ]
then
	mkdir "Resultat"
fi

if [ ! -f "Resultat.csv" ]
then
	echo "Algo,TailleMat,RunId,Temps" > "Resultat.csv"
fi

if [ ! -d "Resultat/Resultat_$algo" ]
then
	mkdir "Resultat/Resultat_$algo"
fi

taille=$1
while [ $taille -le $tailleMAX ]
do
	tour=1
	while [ $tour -le $nbTourParTaille ]
	do
		./TestVitesse -t $taille $arg
		res=`cat "Resultat.txt"`
		rm "Resultat.txt"
		echo "$algo,$taille,$tour,$res" >> "Resultat.csv"
		echo "$res" >> "Resultat/Resultat_$algo/taille_$taille" 
		tour=$(($tour+1))
	done
	taille=$(($taille+$ajoutTaille))
done

