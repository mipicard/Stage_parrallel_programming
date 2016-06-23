#/bin/bash

./test.sh 1 1 100 32 1 CPU1
./test.sh 100 10 1000 32 1 CPU1
mv Resultat.csv Resultat_CPU.csv
./test.sh 10 10 1000 32 1 GPU1 -G
./test.sh 10 10 1000 32 2 GPU2 -G
./test.sh 10 10 1000 32 3 GPU2 -G
mv Resultat.csv Resultat_GPU.csv
