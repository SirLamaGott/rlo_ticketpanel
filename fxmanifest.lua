fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'SirLamaGott'
description 'Admin Ticket Panel'
version '1.1.2'
ui_page 'web/index.html'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    'client/cl_main.lua',
    'client/cl_functions.lua',
}

server_scripts {
    'server/sv_main.lua',
    'server/sv_functions.lua',
}

files {
    'web/index.html',
    'web/css/style.css',
    'web/js/main.js',
    'web/image/*.png',
    'web/image/*.svg',
}

dependencies {
    'es_extended',
}