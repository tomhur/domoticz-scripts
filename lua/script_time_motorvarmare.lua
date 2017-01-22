debug = false
if debug then print('Start motorvärmare') end

dofile("/opt/domoticz/scripts/parse_config.lua")

timeAfterAlarm = tonumber(conf['timeAfterAlarm'])

commandArray = {}

if ( uservariables[conf['alarmClock']] ~= 'false') then
  h = uservariables[conf['alarmClock']]:match("([^%.]+)")
  if debug then print('Timme=' .. h) end
  m = uservariables[conf['alarmClock']]:match("%d+$")
  if debug then print('Minut=' .. m) end

  t = os.date("*t")
  if debug then print('Timme=' .. t['hour']) end
  t['hour']=h
  if debug then print('Timme=' .. t['hour']) end
  if debug then print('Minut=' .. t['min']) end
  t['min']=m
  if debug then print('Minut=' .. t['min']) end
  tid= os.time(t)
  tid=tid+timeAfterAlarm*60
  if debug then print('Tid=' .. tid) end

  nu = os.time()
  if debug then print('Nu =' .. nu) end

  if ( nu < tid and otherdevices[conf['carHeater']] == 'Off' ) then
    temp = otherdevices_svalues[conf['outsideTemp']]:match("([^;]+);([^;]+)")
    if debug then print('Temperatur=' .. temp) end
    innan =math.floor(((temp-12)/-0.28)*60)
    if debug then print('Innan=' .. innan) end
    if debug then print('Kvar=' .. tid-nu) end
    tid = tid - innan
    if ( nu > tid and otherdevices[conf['carHeater']] == 'Off' ) then
      if debug then print('Motorvärmare sätts på') end
      commandArray[conf['carHeater']] = 'On'
    end
  else
    if debug then print('Kvar=' .. tid-nu) end
  end
  if ( nu > tid and otherdevices[conf['carHeater']] == 'On' ) then
    if debug then print('Motorvärmare stängs av') end
    commandArray[conf['carHeater']] = 'Off'
    commandArray['Variable:' .. conf['alarmClock']] = 'false'
  end
else
  if debug then print('Motorvärmare ska inte sättas på!') end
end

if debug then print('Slut motorvärmare') end

return commandArray
