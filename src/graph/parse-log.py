#!/usr/bin/python3
import json
import dateutil.parser as dp
import fileinput

# sample line
# tele/power1/SENSOR {"Time":"2020-10-04T04:02:35","ENERGY":{"TotalStartTime":"2020-09-30T02:29:05","Total":8.315,"Yesterday":1.717,"Today":0.350,"Period":8,"Power":87,"ApparentPower":89,"ReactivePower":22,"Factor":0.97,"Voltage":121,"Current":0.736}}

format  = "%Y-%m-%d-%H:%M:%S"

prev = {}
series = {}
for i, line in enumerate(fileinput.input()):
    if "SENSOR" in line:
        [name_str, json_str] = line.split(" ", 1)
        data = json.loads(json_str)
        # print("time", data["Time"])

        name = name_str.split("/")[1]
        time = dp.isoparse(data["Time"] + "Z")
        total = int(data["ENERGY"]["Total"] * 1000)  # kWh -> Wh
        power = int(data["ENERGY"]["Power"])  # Watts

        if name not in prev:
            prev[name] = (time, total)
        else:
            prevTime, prevTotal = prev[name]
            delta = total - prevTotal  # Wh
            deltaT = time - prevTime
            # print(time, prevTime, deltaT.total_seconds())
            mytime = time.astimezone().strftime(format)
            if name not in series:
                series[name] = []

            deltaT_hours = deltaT.total_seconds() / (60 * 60)
            series[name].append((mytime, delta / deltaT_hours))
            prev[name] = (time, total)
            # print("mytime", mytime)


def rowRender(x):
    (a, b) = x
    return f"{a} {b}"


for i, value in enumerate(["mercury", "tv", "mars"], start=1):
    name = f"power{i}"
    print(f'"{value}"')
    print("\n".join(map(rowRender, series[name])))
    print("E")