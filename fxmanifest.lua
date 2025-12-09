fx_version 'cerulean'
game 'gta5'

description 'Halloween Trick or Treat Script (OX-based)'
author 'REDLINE CITY RP | RCRP'
version '1.2.0 | Update 31.10.25'

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
