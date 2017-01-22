dofile("/opt/domoticz/scripts/parse_config.lua")

commandArray = {}
if (devicechanged[conf['atHome']] == 'Off' and otherdevices[conf['eveningLights']] == 'On') then
	commandArray['Group:Kvällslampor']='Off'
end
return commandArray
