## flash engery monitoring plug with tasmota using tuya conver

### setup raspberry pi zero w
* we need to ssh into the pi via usb, that way when we perform the flash with wifi chip, our ssh session will stay connection
> echo dtoverlay=dwc2 >> config.txt

* ensure the extra text comes after rootwait with a space separating it
> echo -e " modules-load=dwc2,g_ether" >> cmdline.txt

* pi will show up as ethernet device to the host computer
* note pi will not have internet connection without further setup on host (not required)
> ssh pi@raspberrypi.local


### tuya-convert
in the pi, do:
> git clone https://github.com/ct-Open-Source/tuya-convert
> cd tuya-convert
> sudo ./start_flash.sh
* hold button on plug to enter flash mode
* connect to virt-flash access point created by the pi with a phone
* resume flashing, enter: yes

tasmota is now flashed, tasmota will show up as another access point

### tasmota
1. connect to tasmota AP on phone
2. configure home network wifi (SSID,PW) via phone browser
3. on any local network browser, navigate to the plug (check router page for new client/IP)
4. update tasmota firmware
5. configure plug using template:
{"NAME":"BNC-60/U133TJ","GPIO":[0,56,0,17,134,132,0,0,131,57,21,0,0],"FLAG":0,"BASE":18}

6. disable poweroff, the plug to be always on (even through a reboot)
> PowerOnState 4 

7. enable and configure mqtt, tasmota will automatically send status updates periodically

* set ntp server to local network machine
> ntpserver1 192.168.1.105

* set timezone to utc
> Timezone 0
