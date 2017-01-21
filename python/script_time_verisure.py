#!/usr/bin/python
# -*- coding: utf-8 -*-
import domoticz as d
import sys
import time
sys.path.insert(0, '/opt/python-verisure/')
import verisure
import pickle
import pytz
import urllib3
from datetime import datetime
from tzlocal import get_localzone

debug = True

try:
    execfile("/etc/domoticz/scripts.conf")
except:
    exec(open("/etc/domoticz/scripts.conf").read())

d.log("Getting status from Verisure...")

if int(time.time()) % frequency < 60 :

	#Login
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
			d.log("Loading file failed.")

	#Get overview
	try:
		overview = myPages.get_overview()
	except:
		myPages = verisure.Session(email, verisurepass)
		myPages.login()
		f = open(file, 'wb')
		pickle.dump(myPages, f)
		f.close()
		overview = myPages.get_overview()
		if debug:
			d.log("Session was timed out")

	#Alarm
	status = overview['armState']['statusType']
	if debug:
		d.log("Verisure Alarm status: ", status )
	device = d.devices["Hemma"]
	if status == "DISARMED" or status == "ARMED_HOME":
		device.on()
	else:
		device.off()

	#Smartplugs
	for i in overview['controlPlugs']:
		if debug:
			d.log("Verisure Smartplug status for " + i['area'].encode("ascii","ignore") + ": ", i['currentState'] )
		device = d.devices[i['area'].encode("utf-8","ignore")]
		if i['currentState'] == "ON":
			device.on()
		else:
			device.off()

	#Climate
	for i in overview['climateValues']:
		if debug:
			d.log("time: " + i['time'] )
			d.log("location: " + i['deviceArea'].encode("ascii","ignore") )
			d.log("serial: " + i['deviceLabel'] )
			d.log("temperature: " + str(i['temperature']))
		if 'humidity' in i:
			if debug:
				d.log("humidity: " + str(i['humidity']))
			if i['humidity'] < 20:
				comf = 2
			if i['humidity'] >= 20 and i['humidity'] <= 35:
				comf = 0
			if i['humidity'] > 35 and i['humidity'] <= 75:
				comf = 1
			if i['humidity'] > 75:
				comf = 3
			url = baseurl + "?type=command&param=udevice&idx=" + climate[i['deviceArea'].encode("utf-8","ignore")] + "&nvalue=0&svalue=" + str(i['temperature']) + ";" + str(i['humidity']) + ";" + str(comf)
		else:
			url = baseurl + "?type=command&param=udevice&idx=" + climate[i['deviceArea'].encode("utf-8","ignore")] + "&nvalue=0&svalue=" + str(i['temperature'])

		if debug:
			d.log('URL: ' + url)

		device = d.devices[i['deviceArea'].encode("utf-8","ignore")]
		domlastupdate = datetime.strptime(device.last_update_string, '%Y-%m-%d %H:%M:%S')
		domlastupdate = domlastupdate.replace(tzinfo=get_localzone())
		verilastupdate = datetime.strptime(i['time'][:-5], '%Y-%m-%dT%H:%M:%S')
		verilastupdate = verilastupdate.replace(tzinfo=pytz.UTC)
		verilastupdate = verilastupdate.astimezone(get_localzone())
		if debug:
			d.log("Domoticz last update: " + str(domlastupdate))
			d.log("Verisure last update: " + str(verilastupdate))

		if verilastupdate > domlastupdate:
			if debug:
				d.log("update domoticz")

			#http = urllib3.PoolManager()
			#http = urllib3.PoolManager(cert_reqs='CERT_REQUIRED',ca_certs=certifi.where())
			#r = http.request('GET', url, headers={'Authorization': 'Basic ' + auth})
			#if debug:
			#	d.log("Status code: " + str(r.status) + "\n" + r.data)
			#if r.status != 200:
			#	d.log("Error updating temp in Domoticz. HTTP code: " + str(r.status) + " " + r.data)

else:
	if debug:
		d.log("Only runs every " + str(frequency/60) + " min.")

d.log("done getting status from Verisure")
