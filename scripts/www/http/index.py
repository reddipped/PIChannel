#! /usr/bin/python
#
#

import re
import subprocess
import os
import sys

sys.path.append('/home/pi/www/py')
from genfunctions import *


availStorage = getAvailStorage()
wifistate = getWlanState()
imagecount = getImgCount()
movcount = getMovCount()
mailstatus = getMailstatus()
currentvolume= getVolume()
currentslideduration=getSlideduration()
wpassid=getWpaSSID()
wpapsk=getWpaPSK()
mailserver=getMailserver()
mailuname=getMailUsername()
mailpwd=getMailPassword()
mailretrieveinterval=getEmailInterval()
pmgtenabled=""
if getPowerMgtEnabled()=="enabled":
  pmgtenabled="checked"
currentmailretrieveinterval=getEmailInterval()
shutdownmin=getShutdownMinute()
shutdownhour=getShutdownHour()

# Volume levels
volume = 0
volhtml=""
selected=""
while volume >= -60:
    if volume == currentvolume:
        volhtml = volhtml + "<option SELECTED value=\"" + str(volume) + "\">" + str(volume) + "dB</option>"
    else:
        volhtml = volhtml + "<option value=\"" + str(volume) + "\">" + str(volume) + "dB</option>"
    volume=volume-5

# Slide interval duration
slideduration=5
slidehtml=""
while slideduration <= 60:
    if slideduration == currentslideduration:
        slidehtml = slidehtml + "<option SELECTED value=\"" + str(slideduration) + "\">" + str(slideduration) + " sec.</option>"
    else:
        slidehtml = slidehtml + "<option value=\"" + str(slideduration) + "\">" + str(slideduration) + " sec.</option>"
    slideduration=slideduration+5


## get wifi adapter status
wifienabled=""
if wifistate != "down":
  wifienabled = "checked"

## get wifi ssids
ssidset = set()
ssids = ""
df = subprocess.Popen(["sudo", "/sbin/iwlist", "wlan0", "scan"], stdout=subprocess.PIPE)
output = df.communicate()[0]
splitoutput=output.split("\n")
c=0
while c < len(splitoutput):
    searchresult = re.search("^.*ESSID:\"(.*)\".*", splitoutput[c])
    if searchresult:
	ssidset.update([searchresult.group(1)])
    c=c+1

for ssid in ssidset:
  if ssid == wpassid:
    ssids = ssids + "<option SELECTED value=\"" + ssid + "\">" + ssid + "</option>"
  else:
    ssids = ssids + "<option value=\"" + ssid + "\">" + ssid + "</option>"


## Mail retrieve intervals
mailretrieveintervals=""
mailint=5
while mailint <= 55:
    if str(mailint) == currentmailretrieveinterval:
        mailretrieveintervals= mailretrieveintervals + "<option SELECTED value=\"" + str(mailint) + "\">" + str(mailint) + " min.</option>"
    else:
        mailretrieveintervals = mailretrieveintervals + "<option value=\"" + str(mailint) + "\">" + str(mailint) + " min.</option>"
    mailint = mailint + 5


## shutdown time minutes
shutmin=0
shutdownminoption=""
while shutmin <= 55:
    if shutmin == int(shutdownmin):
        shutdownminoption = shutdownminoption+ "<option SELECTED value=\"" + str(shutmin) + "\">" + str(shutmin) + "</option>"
    else:
        shutdownminoption= shutdownminoption+ "<option value=\"" + str(shutmin) + "\">" + str(shutmin) + "</option>"
    shutmin=shutmin+5

## shudown time hours
shuthour=0
shutdownhouroption=""
while shuthour <= 23:
    if shuthour == int(shutdownhour):
        shutdownhouroption = shutdownhouroption+ "<option SELECTED value=\"" + str(shuthour) + "\">" + str(shuthour) + "</option>"
    else:
        shutdownhouroption= shutdownhouroption+ "<option value=\"" + str(shuthour) + "\">" + str(shuthour) + "</option>"
    shuthour=shuthour+1


## Generate HTML
f = open('../stz/index.stz', 'r')
for line in f:
	line = re.sub(r'\[\[-STORAGE-\]\]', availStorage, line)
	line = re.sub(r'\[\[-WIFISTATE-\]\]', wifistate, line)
	line = re.sub(r'\[\[-IMGCOUNT-\]\]', str(imagecount), line)
	line = re.sub(r'\[\[-MOVCOUNT-\]\]', str(movcount), line)
	line = re.sub(r'\[\[-AUDIOVOLUME-\]\]', volhtml, line)
	line = re.sub(r'\[\[-SLIDEDURATION-\]\]', slidehtml, line)
	line = re.sub(r'\[\[-SSIDS-\]\]', ssids, line)
	line = re.sub(r'\[\[-WPAPSK-\]\]', wpapsk, line)
	line = re.sub(r'\[\[-WIFIENABLED-\]\]', wifienabled, line)
	line = re.sub(r'\[\[-MAILINTERVAL-\]\]', mailretrieveintervals, line)
	line = re.sub(r'\[\[-MAILSERVER-\]\]', mailserver, line)
	line = re.sub(r'\[\[-MAILUNAME-\]\]', mailuname, line)
	line = re.sub(r'\[\[-MAILPWD-\]\]', mailpwd, line)
	line = re.sub(r'\[\[-MAILSTATUS-\]\]', mailstatus, line)
	line = re.sub(r'\[\[-PMENABLED-\]\]', pmgtenabled, line)
	line = re.sub(r'\[\[-SHUTDOWNH-\]\]', shutdownhouroption, line)
	line = re.sub(r'\[\[-SHUTDOWNM-\]\]', shutdownminoption, line)

        print line

f.close()
