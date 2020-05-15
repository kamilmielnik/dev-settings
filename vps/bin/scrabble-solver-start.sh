#!/bin/bash
nohup $(which node) /projects/scrabble-solver/dist/scrabble-solver-backend/index.js /projects/scrabble-solver/dictionaries/ </dev/null >/var/log/scrabble-solver/log.log 2>&1 &
