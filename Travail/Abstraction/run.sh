#/bin/bash

./test.sh 10 10 1000 32 1 CPU1
./test.sh 10 10 1000 32 1 GPU1 -G
./test.sh 10 10 1000 32 2 GPU2 -G
