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
    ['no_perms'] = '~r~Dieser Befehl ist nur für Admins',
    ['ticket_created'] = 'Dein Ticket wurde ~g~erfolgreich ~s~erstellt!',
    ['requires_reason'] = 'Du ~r~musst~s~ einen ~b~Grund~s~ angeben um dein Ticket abzuschicken!',
    ['no_message_provided'] = 'Keine Nachricht',
    ['set_waypoint'] = 'Der Wegpunkt zum Spieler wurde ~g~erfolgreich~s~ gesetzt!',
    ['teleported'] = 'Du hast dich ~g~erfolgreich~s~ zum Spieler teleportiert',
    ['ticket_open'] = 'Open',
    ['nonotify_enable'] = 'You will not recieve a notification for tickets anymore!',
    ['nonotify_disable'] = 'You will recieve a notification for tickets again!',
}