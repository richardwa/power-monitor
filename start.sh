#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo start power-monitor

mosquitto -d -c /app/mqtt.conf 
python /app/mqtt_logger.py

echo started
