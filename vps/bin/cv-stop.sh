#!/bin/bash

ps aux | grep /projects/cv/ | grep node | awk '{print $2}' | xargs kill -9
