#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mosquitto -d -c /app/mqtt.conf 
mosquitto_sub -v -t "#" >> /data/power.log