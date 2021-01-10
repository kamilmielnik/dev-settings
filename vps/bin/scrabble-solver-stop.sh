#!/bin/bash

ps aux | grep /projects/scrabble-solver/ | grep node | awk '{print $2}' | xargs kill -9
