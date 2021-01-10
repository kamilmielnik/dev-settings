#!/bin/bash

nohup node /projects/scrabble-solver-v1/dist/scrabble-solver-backend/index.js /projects/scrabble-solver-v1/dictionaries/ </dev/null >/var/log/scrabble-solver-v1/log.log 2>&1 &
