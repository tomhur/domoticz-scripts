#!/usr/bin/python3
# -*- coding: utf-8 -*-
import sys
import json
import pytz
import urllib.request
sys.path.insert(0, '/opt/python-verisure/')
import verisure
import pickle
from datetime import datetime
from tzlocal import get_localzone

debug = False

if debug:
	print("Start testing temp hum dev")

try:
	execfile("/etc/domoticz/scripts.conf")
except:
	exec(open("/etc/domoticz/scripts.conf").read())

file = "/tmp/domoticz_verisure_session"
try:
	f = open(file, 'rb')
	myPages = pickle.load(f)
	f.close()
except:
	myPages = verisure.Session(email, verisurepass)
	myPages.login()
	f = open(file, 'wb')
	pickle.dump(myPages, f)
	f.close()
	if debug:
		print("Loading file failed.")

#Get overview
try:
	dev = myPages.get_overview()
except:
	myPages = verisure.Session(email, verisurepass)
	myPages.login()
	f = open(file, 'wb')
	pickle.dump(myPages, f)
	f.close()
	dev = myPages.get_overview()
	if debug:
		print("Session was timed out")

#Climate
for i in dev['climateValues']:
	if debug:
		print("time: " + i['time'] )
		print("location: " + i['deviceArea'] )
		print("serial: " + i['deviceLabel'] )
		print("temperature: " + str(i['temperature']))
	if 'humidity' in i:
		if debug:
			print("humidity: " + str(i['humidity']))
		if i['humidity'] < 20:
			comf = 2
		if i['humidity'] >= 20 and i['humidity'] <= 35:
			comf = 0
		if i['humidity'] > 35 and i['humidity'] <= 75:
			comf = 1
		if i['humidity'] > 75:
			comf = 3
		url = baseurl + "?type=command&param=udevice&idx=" + climate[i['deviceArea']] + "&nvalue=0&svalue=" + str(i['temperature']) + ";" + str(i['humidity']) + ";" + str(comf)
	else:
		url = baseurl + "?type=command&param=udevice&idx=" + climate[i['deviceArea']] + "&nvalue=0&svalue=" + str(i['temperature'])

	if debug:
		print('IDX: ' + climate[i['deviceArea']])
		print('URL: ' + url)

	request = urllib.request.Request(baseurl + "?type=devices&rid=" + climate[i['deviceArea']])
	request.add_header('Authorization', 'Basic ' + auth)
	r = urllib.request.urlopen(request)
	dev = json.loads(r.read().decode(r.info().get_param('charset') or 'utf-8'))
	domlastupdate = datetime.strptime(dev['result'][0]['LastUpdate'], '%Y-%m-%d %H:%M:%S')
	domlastupdate = domlastupdate.replace(tzinfo=get_localzone())
	verilastupdate = datetime.strptime(i['time'][:-5], '%Y-%m-%dT%H:%M:%S')
	verilastupdate = verilastupdate.replace(tzinfo=pytz.UTC)
	verilastupdate = verilastupdate.astimezone(get_localzone())
	if debug:
		print("dom: " + str(domlastupdate))
		print("ver: " + str(verilastupdate))

	if verilastupdate > domlastupdate:
		if debug:
			print("update domoticz")
		request = urllib.request.Request(url)
		request.add_header('Authorization', 'Basic ' + auth)
		r = urllib.request.urlopen(request)
		if debug:
			print("Status code: " + str(r.getcode()))
		if r.getcode() != 200:
			print("Error updating temp in Domoticz. HTTP code: " + str(r.getcode()))

if debug:
	print("End testing temp hum dev")
