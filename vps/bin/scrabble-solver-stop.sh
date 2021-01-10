#!/bin/bash

ps aux | grep scrabble-solver-v2 | grep node | awk '{print $2}' | xargs kill -9
