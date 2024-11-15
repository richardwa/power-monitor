#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
for  i in 1 2 3
do
  curl -s http://powermon${i}/cm?cmnd=Status%208  -w "\n" | jq "{
    id: ${i}, 
    power_watts: .StatusSNS.ENERGY.Power, 
    total_kwh: .StatusSNS.ENERGY.Total,
    time:  .StatusSNS.ENERGY.TotalStartTime,
  }"
done
