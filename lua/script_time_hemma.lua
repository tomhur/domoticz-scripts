dofile("/opt/domoticz/scripts/parse_config.lua")
debug = false

commandArray = {}

time = os.date("*t")
minutes = time.min + time.hour * 60

if debug then print('light=' .. otherdevices[conf['lightIntensity']]) end
if (tonumber(otherdevices[conf['lightIntensity']]) < tonumber(conf['switchOnLux'])) then
	switchOnLux = true
else
	switchOnLux = false
end

if ((minutes > (timeofday['SunsetInMinutes']) or switchOnLux) and otherdevices[conf['atHome']] == 'On' and otherdevices[conf['eveningLights']] == 'Off'  and otherdevices[conf['atSleep']] == 'Off' ) then
  commandArray[conf['eveningLightsScene']]='On'
end
if ((minutes < (timeofday['SunriseInMinutes']) or switchOnLux ) and otherdevices[conf['atHome']] == 'On' and otherdevices[conf['atSleep']] == 'Off' and otherdevices[conf['eveningLights']] == 'Off' ) then
  commandArray[conf['eveningLightsScene']]='On'
end
if (minutes > (timeofday['SunriseInMinutes']) and minutes < (timeofday['SunsetInMinutes']) and otherdevices[conf['eveningLights']] == 'On' ) then
  if ( otherdevices[conf['atHome']] == 'On' and switchOnLux ) then
    if debug then print('It is still dark. Do not turn off lights') end
  else
    commandArray[conf['eveningLightsScene']]='Off'
  end
end

if (otherdevices[conf['atHome']] == 'Off' ) then
  commandArray[conf['theRestScene']]='Off'
end

return commandArray
