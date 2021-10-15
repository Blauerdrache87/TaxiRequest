fx_version 'adamant'
game 'gta5'

description 'Taxi Request By theMani_kh'
version '1.1'

client_scripts {
	'client/*.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "server/*.lua",
}