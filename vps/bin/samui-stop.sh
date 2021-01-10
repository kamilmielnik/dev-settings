#!/bin/bash

ps aux | grep samui | grep node | awk '{print $2}' | xargs kill -9
