#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo start power-monitor

mosquitto -d -c $DIR/mqtt.conf 
$DIR/loop.sh

echo stopped

