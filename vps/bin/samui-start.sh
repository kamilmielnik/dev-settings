#!/bin/bash

cd /projects/samui-home/
nohup npm start </dev/null >/var/log/samui/log.log 2>&1 &
