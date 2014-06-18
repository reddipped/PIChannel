#! /usr/bin/python
#

import re
import subprocess
import os


## retrieve available storage
def getAvailStorage():
  df = subprocess.Popen(["df", "-h", "/home/pi"], stdout=subprocess.PIPE)
  output = df.communicate()[0]
  if len(output.split("\n")) >= 2:
    filesystem, size, used, avail, useperc, mountpoint = \
    output.split("\n")[1].split()
  else:
    avail = "unknown"

  return avail


## retrieve wlan0 state
def getWlanState():
  wifistate="down"
  df=subprocess.Popen(["/sbin/ifconfig", "wlan0"], stdout=subprocess.PIPE)
  output = df.communicate()[0]
  splitoutput=output.split("\n")
  c=0
  while c < len(splitoutput):
      searchresult = re.search("^.*inet addr:(\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}) .* ", splitoutput[c])
      if searchresult: 
          wifistate="up (" + searchresult.group(1)  + ")"
      c=c+1

  return wifistate


## set wlan0 state
def setWlanState(state='down'):
  if state == 'down':
    df = subprocess.Popen(["sudo","sed","--in-place","s/^\(auto\s*wlan0.*\)$/#\\1/","/etc/network/interfaces"], stdout=subprocess.PIPE)
    df = subprocess.Popen(["sudo","ifdown","wlan0"], stdout=subprocess.PIPE)
  if state == 'up':
    # sudo sed --in-place  's/^\#\(auto\s*wlan0.*\)$/\1/' /etc/network/interfaces
    df = subprocess.Popen(["sudo","sed","--in-place","s/^#\(auto\s*wlan0.*\)$/\\1/","/etc/network/interfaces"], stdout=subprocess.PIPE)
    df = subprocess.Popen(["sudo","ifup","wlan0","--force"], stdout=subprocess.PIPE)

 
## count images
def getImgCount():
  directory = "/home/pi/pp_home/media"
  list_of_files = [file for file in os.listdir(directory) if file.lower().endswith('.png') or file.lower().endswith('.jpg') or file.lower().endswith('.jpeg')]
  imagecount = len(list_of_files)

  return imagecount


## count movies
def getMovCount():
  directory = "/home/pi/pp_home/media"
  list_of_files = [file for file in os.listdir(directory) if file.lower().endswith('.mov') or file.lower().endswith('.mp4')]
  movcount = len(list_of_files)
  
  return movcount
  

## Last mailretrieval status
def getMailstatus():
  f = open('/var/tmp/processmail.sts', 'r')
  mailstatus=""
  try:
    mailstatus = f.read()
  finally:
    f.close()
  
  return mailstatus

  
## get volume setting
def getVolume():
  f = open('/home/pi/pp_home/pp_profiles/livephoto/pp_showlist.json', 'r')
  currentvolume=0
  for line in f:
      searchresult = re.search('"omx-volume":\s\s*"(-*\d+)"\s*,', line) 
      if searchresult:
        currentvolume=int(searchresult.group(1))
  f.close()

  return currentvolume


## set volume
def setVolume(volume=0):
  filename='/home/pi/pp_home/pp_profiles/livephoto/pp_showlist.json'
  with open(filename) as f:
    file_str = f.read()
  file_str = re.sub(r'("omx-volume": )\s*"-*\d+"\s*,', r'\1"' + volume + '",',file_str)

  with open(filename, "w") as f:
    f.write(file_str) 

  
## get slide duration
def getSlideduration():

  f = open('/home/pi/pp_home/pp_profiles/livephoto/pp_showlist.json', 'r')
  currentslideduration=5
  for line in f:
      searchresult = re.search('"duration":\s\s*"(\d+)"', line)
      if searchresult:
        currentslideduration=int(searchresult.group(1))
  f.close()

  return currentslideduration


## set slide duration
def setSlideduration(duration=5):
  filename='/home/pi/pp_home/pp_profiles/livephoto/pp_showlist.json'
  with open(filename) as f:
    file_str = f.read()
    f.close()

  file_str = re.sub(r'("duration": )\s*"\d+"\s*,', r'\1"' + duration + '",',file_str)

  with open(filename, "w") as f:
    f.write(file_str)
    f.close()

  
## get wifi wpa-ssid
def getWpaSSID():

  f = open('/etc/network/interfaces','r') 
  wpassid=""
  for line in f:
      searchresult = re.search("^\s*wpa-ssid\s(.*)$", line)
      if searchresult:
        wpassid=searchresult.group(1)
  f.close()

  return wpassid
  
## set wifi wpa-ssid
def setWpaSSID(wpassid = ""):
  output = subprocess.check_output(["/usr/bin/sudo /bin/sed --in-place  's/^\(\s*wpa-ssid\s\).*$/\\1" + wpassid + "/' /etc/network/interfaces"], shell=True,stderr=subprocess.PIPE)


## get wifi wpa-psk
def getWpaPSK():

  ## get wifi wpa-psk
  f = open('/etc/network/interfaces','r') 
  wpapsk=""
  for line in f:
      searchresult = re.search("^\s*wpa-psk\s(.*)$", line)
      if searchresult:
        wpapsk=searchresult.group(1)

  f.close()
  return wpapsk


## set wifi wpa-psk
def setWpaPSK(wpapsk = ""):
  output = subprocess.check_output(["/usr/bin/sudo /bin/sed --in-place  's/^\(\s*wpa-psk\s\).*$/\\1" + wpapsk + "/' /etc/network/interfaces"], shell=True,stderr=subprocess.PIPE)


## get wifi adapter status
def getWifiStatus():
  wifienabled=""
  if wifistate != "down":
    wifienabled = "checked"
  
  return wifienabled

  
## get e-mail retrieval interval
def getEmailInterval():
  currentmailretrieveinterval=5
  df = subprocess.Popen(["/usr/bin/crontab", "-l"], stdout=subprocess.PIPE)
  output = df.communicate()[0]
  splitoutput=output.split("\n")
  c=0
  while c < len(splitoutput):
      searchresult = re.search("^\*\/(\d+)\s.*", splitoutput[c])
      if searchresult:
          currentmailretrieveinterval = searchresult.group(1)
      c=c+1

  return currentmailretrieveinterval


## set e-mail retrieval interval
def setEmailInterval(interval=5):
  output = subprocess.check_output(["/usr/bin/crontab -l | /bin/sed 's/^\(\*\/\)[0-9]\+\(.*processmail\.sh.*\)/\\1"+str(interval)+"\\2/' | /usr/bin/crontab -"], shell=True,stderr=subprocess.PIPE)

  
## get mailserver
def getMailserver():
  f = open('/home/pi/.getmail/getmailrc','r')
  mailserver=""
  for line in f:
      searchresult = re.search("^\s*server.*=\s(.*)$", line)
      if searchresult:
        mailserver=searchresult.group(1)
  f.close()
  return mailserver


## set mailserver
def setMailserver(mailserver = ""):
  output = subprocess.check_output(["/bin/sed --in-place  's/^\(server\s\+=\s\).*/\\1" + mailserver + "/' /home/pi/.getmail/getmailrc"], shell=True,stderr=subprocess.PIPE)


## get mail username
def getMailUsername():
  f = open('/home/pi/.getmail/getmailrc','r')
  mailuname=""
  for line in f:
      searchresult = re.search("^\s*username.*=\s(.*)$", line)
      if searchresult:
        mailuname=searchresult.group(1)
  f.close()
  return mailuname


## set mail username
def setMailUsername(username = ""):
  output = subprocess.check_output(["/bin/sed --in-place  's/^\(username\s\+=\s\).*/\\1" + username + "/' /home/pi/.getmail/getmailrc"], shell=True,stderr=subprocess.PIPE)


## get mail password
def getMailPassword():
  f = open('/home/pi/.getmail/getmailrc','r')
  mailpwd=""
  for line in f:
      searchresult = re.search("^\s*password.*=\s(.*)$", line)
      if searchresult:
        mailpwd=searchresult.group(1)
  f.close()
  return mailpwd


## set mail password
def setMailPassword(mailpwd = ""):
  output = subprocess.check_output(["/bin/sed --in-place  's/^\(password\s\+=\s\).*/\\1" + mailpwd + "/' /home/pi/.getmail/getmailrc"], shell=True,stderr=subprocess.PIPE)

  
## get powermanagement
def getPowerMgtEnabled():
  pmgtenabled='disabled'
  df = subprocess.Popen(["/usr/bin/sudo", "/usr/bin/crontab", "-l"], stdout=subprocess.PIPE)
  output = df.communicate()[0]
  splitoutput=output.split("\n")
  c=0
  while c < len(splitoutput):
    searchresult = re.search("^(\d*)\s(\d*)\s.*\/sbin\/shutdown.*", splitoutput[c])
    if searchresult:
      pmgtenabled='enabled' 
    c=c+1

  return pmgtenabled


## set powermananagement
def setPowerMgtEnabled(status='disabled'):
  if status == "enabled":
    output = subprocess.check_output(["/usr/bin/sudo /usr/bin/crontab -l | /bin/sed 's/^#\([0-9]\+\)\s\([0-9]\+\)\(\s.*\/sbin\/shutdown.*\)/\\1 \\2\\3/' | /usr/bin/sudo /usr/bin/crontab -"], shell=True,stderr=subprocess.PIPE)
  else:
    output = subprocess.check_output(["/usr/bin/sudo /usr/bin/crontab -l | /bin/sed 's/^\([0-9]\+\)\s\([0-9]\+\)\(\s.*\/sbin\/shutdown.*\)/#\\1 \\2\\3/' | /usr/bin/sudo /usr/bin/crontab -"], shell=True,stderr=subprocess.PIPE)


## get shutdownhour
def getShutdownHour():
  shutdownhour=0
  df = subprocess.Popen(["/usr/bin/sudo", "/usr/bin/crontab", "-l"], stdout=subprocess.PIPE)
  output = df.communicate()[0]
  splitoutput=output.split("\n")
  c=0
  while c < len(splitoutput):
    searchresult = re.search("^#?(\d*)\s(\d*)\s.*\/sbin\/shutdown.*", splitoutput[c])
    if searchresult:
      shutdownhour=searchresult.group(2)
    c=c+1

  return shutdownhour


## set shutdownhour
def setShutdownHour(hour=0):
  output = subprocess.check_output(["/usr/bin/sudo /usr/bin/crontab -l | /bin/sed 's/^\(#\?\)\([0-9]\+\)\s\([0-9]\+\)\(\s.*\/sbin\/shutdown.*\)/\\1\\2 "+str(hour)+"\\4/' | /usr/bin/sudo /usr/bin/crontab -"], shell=True,stderr=subprocess.PIPE)


## get shutdownminute
def getShutdownMinute():
  shutdownmin=0
  df = subprocess.Popen(["/usr/bin/sudo", "/usr/bin/crontab", "-l"], stdout=subprocess.PIPE)
  output = df.communicate()[0]
  splitoutput=output.split("\n")
  c=0
  while c < len(splitoutput):
    searchresult = re.search("^#?(\d*)\s(\d*)\s.*\/sbin\/shutdown.*", splitoutput[c])
    if searchresult:
      shutdownmin=searchresult.group(1)
    c=c+1

  return shutdownmin


## set shutdowminute
def setShutdownMinute(minute=0):
  output = subprocess.check_output(["/usr/bin/sudo /usr/bin/crontab -l | /bin/sed 's/^\(#\?\)\([0-9]\+\)\s\([0-9]\+\)\(\s.*\/sbin\/shutdown.*\)/\\1"+str(minute)+" \\3\\4/' | /usr/bin/sudo /usr/bin/crontab -"], shell=True,stderr=subprocess.PIPE)


## restartPi
def restartPi():
  output = subprocess.check_output(["/usr/bin/sudo /sbin/shutdown -rF 0"],shell=True,stderr=subprocess.PIPE)

