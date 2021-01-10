#!/bin/bash

cd /projects/scrabble-solver/packages/scrabble-solver
nohup npm start </dev/null >/var/log/scrabble-solver/log.log 2>&1 &

