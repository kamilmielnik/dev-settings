#!/bin/bash
nohup (cd /projects/cv && $(which npm) start) </dev/null >/var/log/cv/log.log 2>&1 &
