#!/bin/bash
ps aux | grep cv-server | grep node | awk '{print $2}' | xargs kill -9
