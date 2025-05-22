# rlo_ticketpanel
This FiveM script for ESX provides an intuitive in-game UI where players can create support tickets. Moderators can then access these tickets, claim them, teleport directly to the player, and manage the entire support process efficiently within the game. It streamlines support, making it easier for both players to get help and staff to provide it.

## Features

- **Manage Tickets:** Easily claim them and start working! Teleport, Waypoint and more directly possible.
- **Simple User Interface:** Management of tickets made simple. 
- **XSound Integration:** For a immersive sound.
- **Easy Configuration:** All settings can be customized in the `Config.lua` file.

## Installation

1. Download this repository and place it in your FiveM server's resources folder.
2. Ensure that ESX is installed on your server.
3. Add the script to your `server.cfg` file:

   ```plaintext
   ensure rlo_ticketpanel
   ```

4. Add your Discord Webhook API key for logs at `server/sv_functions.lua` in the first line.
5. Adjust the configuration in the `config.lua` file to meet your server requirements.

## Configuration

The configuration is handled via the `config.lua` file. Here are some of the key options:

```lua
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
```

### Zones

You can customize the translation of the script directly in the `config.lua` in the bottom.

```lua
Translation = {
    ['no_perms'] = '~r~You do not have permissions to use this command',
    ['ticket_created'] = 'Your Ticket got created ~g~successfully ~s~!',
    ['requires_reason'] = 'You ~r~need to provide a message~s~ to request support!',
    ['no_message_provided'] = 'No message',
    ['set_waypoint'] = 'You set a waypoint to the player ~g~successfully.',
    ['teleported'] = 'You teleported to the player ~g~successfully.',
    ['ticket_open'] = 'Open',
    ['nonotify_enable'] = 'You will not recieve a notification for tickets anymore!',
    ['nonotify_disable'] = 'You will recieve a notification for tickets again!',
}
```

## Dependencies

- **[ESX](https://github.com/esx-framework/esx_core):** ESX framework for FiveM.
- **[xsound (optional)]([https://github.com/overextended/ox_lib](https://github.com/Xogy/xsound)):** Improved audio library for FiveM.
