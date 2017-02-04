#!/usr/bin/python
# -*- coding: utf-8 -*-
import domoticz

try:
    execfile("/etc/domoticz/scripts.conf")
except:
    exec(open("/etc/domoticz/scripts.conf").read())

debug = True

if changed_device.name == pir:
	if debug:
		domoticz.log("Start " + pir)
	dev = domoticz.devices[atSleep]
	dev.off()
	if debug:
		domoticz.log("End " + pir)
