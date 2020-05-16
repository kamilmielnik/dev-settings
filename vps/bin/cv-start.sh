#!/bin/bash
nohup $(cd /projects/cv && npm start) </dev/null >/var/log/cv/log.log 2>&1 &
