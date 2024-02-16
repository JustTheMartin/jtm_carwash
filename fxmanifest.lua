fx_version 'cerulean'
game 'gta5'
author 'JustTheMartin'
lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    'cfg.lua'
}

client_script 'cl_loader.lua'
server_script 'sv_loader.lua'

server_scripts {
	"@oxmysql/lib/MySQL.lua",
    'server/*.lua'
}