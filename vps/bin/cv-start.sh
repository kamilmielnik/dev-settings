#!/bin/bash

cd /projects/cv/
nohup npm start </dev/null >/var/log/cv/log.log 2>&1 &

