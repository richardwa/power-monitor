#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

COMMAND='mosquitto_sub -v -t #'

while true; do
    current_time=$(date +%s)
    midnight=$(date -d "tomorrow 00:00:00" +%s)
    seconds_remaining=$((midnight - current_time))
    log_file="/data/power-$(date +%Y-%m-%d).log"

    timeout $seconds_remaining $COMMAND >> $log_file
    sleep 10
done
