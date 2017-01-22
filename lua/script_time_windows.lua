debug = false
if debug then print('Start Fönsterlampor') end

dofile("/opt/domoticz/scripts/parse_config.lua")

commandArray = {}

time = os.date("*t")
minutes = time.min + time.hour * 60
morgon = tonumber(conf['lightsAtMorning'])*60
natt = tonumber(conf['lightsAtNight'])*60

--tänd på morgonen
if (minutes < (timeofday['SunriseInMinutes']) and minutes > morgon and otherdevices[conf['windowLights']] == 'Off' ) then
  if debug then print('Fönsterlampor tänds på morgonen') end
  commandArray[conf['windowLightsScene']]='On'
end

--släck på dagen
if ( otherdevices[conf['windowLights']] == 'On' and minutes > (timeofday['SunriseInMinutes']) and minutes < (timeofday['SunsetInMinutes']) ) then
  if debug then print('Fönsterlampor är släckta på dagen') end
  commandArray[conf['windowLightsScene']]='Off'
  commandArray[conf['windowLightsEveningScene']]='Off'
end

--tänd på kvällen
if (minutes > (timeofday['SunsetInMinutes']) and otherdevices[conf['windowLights']] == 'Off' and otherdevices['Sover'] == 'Off' ) then
  if debug then print('Fönsterlampor tänds på kvällen') end
  commandArray[conf['windowLightsScene']]='On'
  commandArray[conf['windowLightsEveningScene']]='On'
end

--släck på natten
if ( otherdevices[conf['windowLights']] == 'On' and minutes >  natt and minutes < morgon and otherdevices['Hemma'] == 'Off' ) then
  if debug then print('Fönsterlampor är släckta på natten') end
  commandArray[conf['windowLightsScene']]='Off'
  commandArray[conf['windowLightsEveningScene']]='Off'
end

if debug then print('Slut Fönsterlampor') end

return commandArray
