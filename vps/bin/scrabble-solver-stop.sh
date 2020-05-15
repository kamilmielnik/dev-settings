#!/bin/bash
ps aux | grep scrabble-scrabble | grep node | awk '{print $2}' | xargs kill -9
