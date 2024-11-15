#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mosquitto -d -c /app/mqtt.conf 
python $DIR/mqtt_logger.py
