#!/usr/bin/python
# -*- coding: utf-8 -*-
import domoticz

debug = True

if changed_device.name == "PIR tvättstuga":
	if debug:
		domoticz.log("Start PIR tvättstuga")
	dev = domoticz.devices["Hemma"]
	dev.on()
	if debug:
		domoticz.log("Start PIR tvättstuga")
