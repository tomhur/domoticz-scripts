#!/usr/bin/python
# -*- coding: utf-8 -*-
import domoticz as d
import sys
sys.path.insert(0, '/opt/python-verisure/')
import verisure
import pickle

debug = True

try:
    execfile("/etc/domoticz/scripts.conf")
except:
    exec(open("/etc/domoticz/scripts.conf").read())

#Load old session
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

# Smartplugs
if changed_device.name in sp:
	if debug:
		d.log("Start device change: " + changed_device.name + ", " + sp[changed_device.name])
	if changed_device.n_value == 1:
		myPages.set_smartplug_state(sp[changed_device.name], True )
		if debug:
			d.log("Device " + changed_device.name + " is turned on")
	if changed_device.n_value == 0:
		myPages.set_smartplug_state(sp[changed_device.name], False )
		if debug:
			d.log("Device " +changed_device.name + " is turned off")
	if debug:
		d.log("End Smartplug device change")

#Arm then sleeping
if changed_device.name == "Sover":
	if debug:
		d.log("Start device change: " + changed_device.name )

	alarmstatus = overview['armState']['statusType']
	if debug:
		d.log("Verisure Alarm status: ", alarmstatus )

	if changed_device.n_value == 1 and alarmstatus == "DISARMED":
		myPages.set_arm_state(pin, "ARMED_HOME")
		if debug:
			d.log("Device " + changed_device.name + " is turned on")

	if changed_device.n_value == 0 and alarmstatus == "ARMED_HOME":
		myPages.set_arm_state(pin, "DISARMED")
		if debug:
			d.log("Device " + changed_device.name + " is turned off")
