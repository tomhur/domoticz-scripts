commandArray = {}

--print('Hemma script')

time = os.date("*t")
minutes = time.min + time.hour * 60

if (minutes > (timeofday['SunsetInMinutes']) and otherdevices['Hemma'] == 'On' and otherdevices['Kvällslampor'] == 'Off'  and otherdevices['Sover'] == 'Off' ) then
  commandArray['Group:Kvällslampor']='On'
end
if (minutes < (timeofday['SunriseInMinutes']) and otherdevices['Hemma'] == 'On' and otherdevices['Sover'] == 'Off' and otherdevices['Kvällslampor'] == 'Off' ) then
  commandArray['Group:Kvällslampor']='On'
end
if (minutes > (timeofday['SunriseInMinutes']) and minutes < (timeofday['SunsetInMinutes']) and otherdevices['Kvällslampor'] == 'On' ) then
  commandArray['Group:Kvällslampor']='Off'
end

if (otherdevices['Hemma'] == 'Off' ) then
  commandArray['Group:Resten']='Off'
end

return commandArray
