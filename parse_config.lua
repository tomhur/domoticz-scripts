-- code from https://rosettacode.org/wiki/Read_a_configuration_file#Lua
-- slightly modified
conf = {}

fp = io.open( "/etc/domoticz/scripts.conf", "r" )

for line in fp:lines() do
    line = line:match( "%s*(.+)" )
    if line and line:sub( 1, 1 ) ~= "#" and line:sub( 1, 1 ) ~= ";"  and line:sub( 1,1 ) ~= "}" then
        option = line:match( "(.*)=" )
        value  = line:match( '="(.*)"' )
        if value ~= "{" then
            conf[option] = value
        end
    end
end
fp:close()
-- End code from https://rosettacode.org/wiki/Read_a_configuration_file#Lua
