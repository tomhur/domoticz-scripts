commandArray = {}
if (devicechanged['Hemma'] == 'Off' and otherdevices['Kvällslampor'] == 'On') then
	commandArray['Group:Kvällslampor']='Off'
end
return commandArray
