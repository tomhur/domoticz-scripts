debug = false
if debug then print('Start window lights script') end

dofile("/opt/domoticz/scripts/parse_config.lua")

commandArray = {}

time = os.date("*t")
minutes = time.min + time.hour * 60
morning = tonumber(conf['lightsAtMorning'])*60
night = tonumber(conf['lightsAtNight'])*60

if debug then print('light=' .. otherdevices[conf['lightIntensity']]) end
if (tonumber(otherdevices[conf['lightIntensity']]) < tonumber(conf['switchOnLux'])) then 
    switchOnLux = true
else
    switchOnLux = false
end


--turn on at morning
if (minutes < (timeofday['SunriseInMinutes']) and minutes > morning and otherdevices[conf['windowLights']] == 'Off' ) then
  if debug then print('Turn on lights at morning') end
  commandArray[conf['windowLightsScene']]='On'
end

--turn off during day
if ( otherdevices[conf['windowLights']] == 'On' and minutes > (timeofday['SunriseInMinutes']) and minutes < (timeofday['SunsetInMinutes']) ) then
  if ( otherdevices[conf['atHome']] == 'On' and switchOnLux ) then
    if debug then print('It is still dark. Keep lights on') end
  else
  if debug then print('Turn of lights during day') end
    commandArray[conf['windowLightsScene']]='Off'
    commandArray[conf['windowLightsEveningScene']]='Off'
  end
end

--turn on at evening
if ( (minutes > (timeofday['SunsetInMinutes']) or switchOnLux ) and otherdevices[conf['windowLights']] == 'Off' and otherdevices[conf['atSleep']] == 'Off' ) then
  if debug then print('Turn on lights at evening') end
  commandArray[conf['windowLightsScene']]='On'
  commandArray[conf['windowLightsEveningScene']]='On'
end

--turn off during night
if ( otherdevices[conf['windowLights']] == 'On' and minutes >  night and minutes < morning and otherdevices[conf['atHome']] == 'Off' ) then
  if debug then print('Turn off lights during night') end
  commandArray[conf['windowLightsScene']]='Off'
  commandArray[conf['windowLightsEveningScene']]='Off'
end

if debug then print('End window lights script') end

return commandArray
