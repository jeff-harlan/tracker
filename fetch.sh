#!/usr/local/bin/bash

when=$(date +%s)
where=10.20.30.249:8080

wget http://$where/dump1090/data.json -O data/data.$when.json -o data/log.$when
