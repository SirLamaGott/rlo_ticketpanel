Config = {
    Debug = false, 
    Groups = {'admin'},

    TicketCommand = 'support',
    RequiresReason = true, 

    PanelCommand = 'ap',
    KeepInput = true,

    NoNotifyCommand = 'noadmin',

    Sound = { -- requires xsound
        Enabled = true,
        URL = './sounds/adminNotification.ogg',
        Volume = 1.0,
    }
}

Translation = {
    ['no_perms'] = '~r~You do not have permissions',
    ['ticket_created'] = 'You ~g~succesfully~s~ created a support ticket!',
    ['requires_reason'] = 'You ~r~need~s~ to provide a ~b~reason~s~ to open a ticket!',
    ['no_message_provided'] = 'No message',
    ['set_waypoint'] = 'Set waypoint to player succesfully.',
    ['teleported'] = 'Teleported to player successfully.',
    ['ticket_open'] = 'Open',
    ['nonotify_enable'] = 'You will not recieve a notification for tickets anymore!',
    ['nonotify_disable'] = 'You will recieve a notification for tickets again!',
}
