dofile("/opt/domoticz/scripts/parse_config.lua")

commandArray = {}

time = os.date("*t")
minutes = time.min + time.hour * 60

if (minutes > (timeofday['SunsetInMinutes']) and otherdevices[conf['atHome']] == 'On' and otherdevices[conf['eveningLights']] == 'Off'  and otherdevices[conf['atSleep']] == 'Off' ) then
  commandArray[conf['eveningLightsScene']]='On'
end
if (minutes < (timeofday['SunriseInMinutes']) and otherdevices[conf['atHome']] == 'On' and otherdevices[conf['atSleep']] == 'Off' and otherdevices[conf['eveningLights']] == 'Off' ) then
  commandArray[conf['eveningLightsScene']]='On'
end
if (minutes > (timeofday['SunriseInMinutes']) and minutes < (timeofday['SunsetInMinutes']) and otherdevices[conf['eveningLights']] == 'On' ) then
  commandArray[conf['eveningLightsScene']]='Off'
end

if (otherdevices[conf['atHome']] == 'Off' ) then
  commandArray[conf['theRestScene']]='Off'
end

return commandArray
