# domoticz-scripts
These are some scripts to be used with [Domoticz](http://domoticz.com/) to enable some extra functionality and integration

### Legal Disclaimer
These scripts are not affiliated with other software or servicecs that they use and/or depend on. The developers take no legal responsibility for the functionality or security if you chose to use the scripts.

## Installation
### Dependencies
A working installation of [Domoticz](http://domoticz.com/) and to use python scripts you also have to have python enabled in it.

To interface with [Verisure Home Alarm](https://www.verisure.se/) you need [python-verisure](https://github.com/persandstrom/python-verisure) in /opt/python-verisure

[Mimic](https://mimic.mycroft.ai/) installed in /opt/mimic/ or espeak for voice feedback.

A speaker connected to the system to enable voice feedback and door chimes.

[Tasker](https://tasker.dinglisch.net/) is used to automaticaly update a varible in Domoticz then I set the alarm to go up in the morning.

### Clone or download
Clone or download the scripts and place the content within the scripts folder of your Domoticz installation. In my case /opt/domoticz/scripts/

### Configuration
Copy scripts.conf to /etc/domoticz/ and modify the variables to your liking.

Any devices on Verisure MyPages and in Domoticz are expected to have the same name.

### Explanation of language
Since some names of switches are in Swedish a translation migh make it easier to understand:

Hemma = At home
Sover = Sleeping
Väckarklock = Alarm clock

## The scripts
### groventre
Script that plays a specific sound then doorbell chime at secondary entrence is pressed.

### parse-email.py
Script to trigger acctions based on push messages from Verisure. Sets switch HOme to on then a e-mail with status DISARMED is recived. Enabled with a line in /etc/aliases like this:
	e-mailaddress:        "|/opt/domoticz/scripts/parse-email.py"

### speach
Script to be called from within Domoticz for voice output. Select tts engine, tts engine parameters and  greting phrase in scripts.conf.

In Domoticz Settings->Notifications add "script://speach #MESSAGE" as an URL/Action in section Custom HTTP/Action. Remember to enable Custom HTTP/Action. Now you can add a notification to anything in Domoticz and the contents of "Custom Message" will be read out through your speaker.

### storentre
Script that plays a specific sound then doorbell chime at primary entrence is pressed.

### verisure_update_devs.py
Script called by cron to get Verisure climate devices data and update a dummy device in Domoticz with that data. The script expects that the device have the same name in both Domoticz and on Verisures MyPages.

If the climate device only have temperature information the device in Domoticz should only be a temperature device.

If the climate device hav both temperature and humidity the device in Domiticz is expected to be a temperature and hunidity device.

### lua/script_device_hemma.lua
Switches of a group of lights then no one is home

### lua/script_time_hemma.lua
Switches on a group off lights when someone is home and the sun is down. Switches of lights at sunrise or at bedtime which happens then switch Sover is turned on.

### lua/script_time_motorvarmare.lua
If Domoticz variable Väckarklocka is not false and time is set to format hour.minute it will start the car heater. The car heater will be switched of 45 min after the alarm. How long time before that depends on the temperature outside.

### lua/script_time_wakuplight.lua
Turns a dimmable ligt into a wakeup light. It uses the same varible Väckarklocka as script lua/script_time_motorvarmare.lua does.

### lua/script_time_windows.lua
Sceduling of window lights. Lights in bedrroms will not be turned on in the morning. No lights will be on in then the sun is up.

### python/script_device_PIR_hallway.py
Take house out off sleep mode when there is movement in the hallway.

### python/script_device_verisure.py
Turn on or off Verisure SmartPlug devices.

Switches Verisure alarm status to ARMED_HOME from DISARMED then switch Sover is turned on.

Switches Verisure alarm status from ARMED_HOME to DISARMED then switch Sover is turned off.

### python/script_time_verisure.py
Periodicaly get status for Verisure devices. Does not yet work with climate devices (use verisure_update_devs.py for that).
