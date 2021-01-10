#!/bin/bash

ps aux | grep scrabble-solver | grep node | awk '{print $2}' | xargs kill -9
