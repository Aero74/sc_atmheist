fx_version 'cerulean'
game 'gta5'

author 'Aero'
description 'sc_atmheist'

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

dependencies {
    'ox_lib',
    'sc-notify'
}

lua54 'yes'


