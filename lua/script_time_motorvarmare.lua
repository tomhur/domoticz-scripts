debug = false
if debug then print('Start car heater script') end

dofile("/opt/domoticz/scripts/parse_config.lua")

timeAfterAlarm = tonumber(conf['timeAfterAlarm'])

commandArray = {}

if ( uservariables[conf['alarmClock']] ~= 'false') then
  h = uservariables[conf['alarmClock']]:match("([^%.]+)")
  if debug then print('Hour=' .. h) end
  m = uservariables[conf['alarmClock']]:match("%d+$")
  if debug then print('Minute=' .. m) end

  t = os.date("*t")
  if debug then print('Hour=' .. t['hour']) end
  t['hour']=h
  if debug then print('Hour=' .. t['hour']) end
  if debug then print('Minute=' .. t['min']) end
  t['min']=m
  if debug then print('Minute=' .. t['min']) end
  time= os.time(t)
  time=time+timeAfterAlarm*60
  if debug then print('Time=' .. time) end

  now = os.time()
  if debug then print('Now =' .. now) end

  if ( now < time and otherdevices[conf['carHeater']] == 'Off' ) then
    temp = otherdevices_svalues[conf['outsideTemp']]:match("([^;]+);([^;]+)")
    if debug then print('Temperature=' .. temp) end
    before =math.floor(((temp-12)/-0.28)*60)
    if debug then print('Before=' .. before) end
    if debug then print('Left=' .. time-now) end
    time = time - before
    if ( now > time and otherdevices[conf['carHeater']] == 'Off' ) then
      if debug then print('Car heater is turned on') end
      commandArray[conf['carHeater']] = 'On'
    end
  else
    if debug then print('Left=' .. time-now) end
  end
  if ( now > time and otherdevices[conf['carHeater']] == 'On' ) then
    if debug then print('Car heater is turned off') end
    commandArray[conf['carHeater']] = 'Off'
    commandArray['Variable:' .. conf['alarmClock']] = 'false'
  end
else
  if debug then print('Car heater is not schedueled to be turned on!') end
end

if debug then print('End car heater script') end

return commandArray
