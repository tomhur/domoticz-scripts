debug = false
if debug then print('Start wakeuplight') end

dofile("/opt/domoticz/scripts/parse_config.lua")

timeBeforeAlarm = tonumber(conf['timeBeforeAlarm'])*60
Dimmer = conf['wakeuplight']
Alarm = conf['alarmClock']

commandArray = {}

if ( uservariables[Alarm] ~= 'false') then
  h = uservariables[Alarm]:match("([^%.]+)")
  m = uservariables[Alarm]:match("%d+$")
  if debug then print('Timme=' .. h) end
  if debug then print('Minute=' .. m) end

  t = os.date("*t")
  t['hour']=h
  t['min']=m
  time= os.time(t)
  if debug then print('Time=' .. time) end

  now = os.time()
  if debug then print('Now =' .. now) end

  if ( now > time-timeBeforeAlarm and now < time ) then
	Level=math.floor((timeBeforeAlarm-(time-now))/60)
    commandArray[Dimmer] = 'Set Level '..Level

    if debug then print('Level=' .. Level) end
    if debug then print(Dimmer .. ' will be increased') end
  end
else
  if debug then print('Wakeuplight should not be turned on!') end
end

if debug then print('End wakeuplight') end

return commandArray
