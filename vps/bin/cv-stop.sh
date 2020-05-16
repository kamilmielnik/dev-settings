#!/bin/bash
ps aux | grep cv | grep node | awk '{print $2}' | xargs kill -9
