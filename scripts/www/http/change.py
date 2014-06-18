#! /usr/bin/python
#
#

import cgi
import sys
sys.path.append('/home/pi/www/py')
from genfunctions import *

# uncomment to debug
#import cgitb
#cgitb.enable()

form=cgi.FieldStorage()
message=""
restartNecessary = False

if "volume" in form:
    newVolume=form["volume"].value
    if newVolume != str(getVolume()):
      message=message+"Changing volume to " + newVolume + "</br>"
      setVolume(newVolume)

if "slideduration" in form:
    newSlideduration=form["slideduration"].value
    if newSlideduration != str(getSlideduration()):
      message=message+"Changing slideduration to " + newSlideduration + " seconds</br>"
      setSlideduration(newSlideduration)

if "wifienabled" in form:
    if getWlanState() == "down":
      message=message+"Enabling Wlan</br>"
      setWlanState('up')
else:
    if getWlanState() != "down":
      message=message+"Disabling Wlan</br>"
      setWlanState('down')

if "wpassid" in form:
	newWpaSSID=form["wpassid"].value
	if newWpaSSID != str(getWpaSSID()):
	  setWpaSSID(newWpaSSID)
	  message=message+"WPA SSID changed to " + newWpaSSID  + "</br>"

if "wpapsk" in form:
	newWpaPSK=form["wpapsk"].value
	if newWpaPSK != str(getWpaPSK()):
	  setWpaPSK(newWpaPSK)
	  message=message+"WPA PSK changed</br>"

if "mailinterval" in form:
    newMailInterval=form["mailinterval"].value
    if newMailInterval != str(getEmailInterval()):
      message=message+"Changing Mailinterval to " + str(newMailInterval) + "min.</br>"
      setEmailInterval(newMailInterval) 

if "mailserver" in form:
    newMailserver=form["mailserver"].value
    if newMailserver != str(getMailserver()):
       message=message+"Changing mailserver to " + newMailserver + "</br>"
       setMailserver(newMailserver) 

if "mailuname" in form:
    newMailUsername=form["mailuname"].value
    if newMailUsername != str(getMailUsername()):
       message=message+"Changing mail username to " + newMailUsername + "</br>"
       setMailUsername(newMailUsername)

if "mailpwd" in form:
    newMailPassword=form["mailpwd"].value
    if newMailPassword != str(getMailPassword()):
       message=message+"Changing mail password to</br>"
       setMailPassword(newMailPassword)

if "autoshutdown" in form:
    if getPowerMgtEnabled() != "enabled":
	setPowerMgtEnabled("enabled")
        message=message+"Powersavings enabled</br>"
else:
    if getPowerMgtEnabled() == "enabled":
        setPowerMgtEnabled("disabled")
        message=message+"Powersavings disabled</br>"

if "shutdownhour" in form:
    newShutdownHour=form["shutdownhour"].value
    if newShutdownHour != str(getShutdownHour()):
      message=message+"changing shutdownhour to " + newShutdownHour + "</br>"
      setShutdownHour(newShutdownHour)

if "shutdownminute" in form:
    newShutdownMinute=form["shutdownminute"].value
    if newShutdownMinute != str(getShutdownMinute()):
      message=message+"changing shutdownminute to " + newShutdownMinute + "</br>"
      setShutdownMinute(newShutdownMinute)

## Generate HTML

if restartNecessary:
  message=message+"Rebooting to activate changes</br>"

f = open('../stz/wait.stz', 'r')
for line in f:
	line = re.sub(r'\[\[-MESSAGE-\]\]', message, line)
        print line

f.close()

if restartNecessary:
  restartPi() 
