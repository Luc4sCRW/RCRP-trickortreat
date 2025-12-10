fx_version 'cerulean'
game 'gta5'

author 'REDLINE CITY RP | RCRP'
description 'Trick or Treat Script (OX-target based)' 
version '1.0 (Official Release)'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

lua54 'yes'
