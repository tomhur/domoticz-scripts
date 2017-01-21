debug = false
if debug then print('Start Fönsterlampor') end

commandArray = {}

time = os.date("*t")
minutes = time.min + time.hour * 60
morgon = 6*60
natt = 1*60

--tänd på morgonen
if (minutes < (timeofday['SunriseInMinutes']) and minutes > morgon and otherdevices['Fönsterlampor'] == 'Off' ) then
  if debug then print('Fönsterlampor tänds på morgonen') end
  commandArray['Group:Fönsterlampor']='On'
end

--släck på dagen
if ( otherdevices['Fönsterlampor'] == 'On' and minutes > (timeofday['SunriseInMinutes']) and minutes < (timeofday['SunsetInMinutes']) ) then
  if debug then print('Fönsterlampor är släckta på dagen') end
  commandArray['Group:Fönsterlampor']='Off'
  commandArray['Group:Fönsterlampor kväll']='Off'
end

--tänd på kvällen
if (minutes > (timeofday['SunsetInMinutes']) and otherdevices['Fönsterlampor'] == 'Off' and otherdevices['Sover'] == 'Off' ) then
  if debug then print('Fönsterlampor tänds på kvällen') end
  commandArray['Group:Fönsterlampor']='On'
  commandArray['Group:Fönsterlampor kväll']='On'
end

--släck på natten
if ( otherdevices['Fönsterlampor'] == 'On' and minutes >  natt and minutes < morgon and otherdevices['Hemma'] == 'Off' ) then
  if debug then print('Fönsterlampor är släckta på natten') end
  commandArray['Group:Fönsterlampor']='Off'
  commandArray['Group:Fönsterlampor kväll']='Off'
end

if debug then print('Slut Fönsterlampor') end

return commandArray
