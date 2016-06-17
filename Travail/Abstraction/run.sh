#!/bin/bash

./run.sh 10 10 1000 1 CPU1
./run.sh 10 10 1 1000 1 GPU1 -G
./run.sh 10 10 2 1000 GPU2 -G
