#!/bin/bash

ps aux | grep /projects/scrabble-solver-v2/ | grep node | awk '{print $2}' | xargs kill -9
