#!/bin/bash
nohup $(which node) (cd /projects/cv && npm start -- --cv-server </dev/null >/var/log/cv/log.log 2>&1 &)
