local isInPanel, noNotify = false, false

RegisterNUICallback('close', function(data, cb) closeUi() end)
function closeUi()
    isInPanel = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({type = 'close'})
end

RegisterCommand(Config.PanelCommand or 'adminPanel', function(source, args, rawCommand)
    ESX.TriggerServerCallback('rlo_ticketpanel:callback:isAdmin', function(isAdmin)
        if isAdmin then 
            if not isInPanel then 
                isInPanel = true
                SendNUIMessage({type = 'open'})
                SetNuiFocus(true, true)
                if Config.KeepInput then 
                    SetNuiFocusKeepInput(true)
                    CreateThread(function()
                        while isInPanel do
                            Wait(0)
                            DisableControlAction(0, 24, true)  --INPUT_ATTACK
                            DisableControlAction(0, 45, true)  --INPUT_RELOAD
                            DisableControlAction(0, 1, true)   --LookLeftRight
                            DisableControlAction(0, 2, true)   --LookUpDown
                            DisableControlAction(2, 200, true) --ESC

                            if IsDisabledControlJustReleased(2, 200) then 
                                closeUi()
                            end
                        end
                    end)
                end
            end
        else
            ShowNotification(Translation['no_perms'])
        end
    end, source) 
end)

RegisterCommand(Config.NoNotifyCommand or 'noNotify', function(source, args, rawCommand)
    ESX.TriggerServerCallback('rlo_ticketpanel:callback:isAdmin', function(isAdmin)
        if not isAdmin then
            ShowNotification(Translation['no_perms'])
            return
        end

        noNotify = not noNotify
        local message = noNotify and Translation['nonotify_enable'] or Translation['nonotify_disable']
        ShowNotification(message)
    end, source)
end)

RegisterNetEvent('rlo_ticketpanel:client:syncRequest', function(activeTickets, newUniqueId)
    local ticketContent = activeTickets[newUniqueId]
    if not ticketContent then return end

    print('Trying to sync, TicketContent', ESX.DumpTable(ticketContent))

    SendNUIMessage({type = 'createTicket', ticketContent = ticketContent})

    if not noNotify then 
        print('Notifying!')
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message support"><i class="fas fa-bell"></i> <b><span style="color: #28b3de"> Support-Anfrage {0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;"></span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
            args = { '[' .. ticketContent.playerName .. ' - ' .. ticketContent.playerId .. ']', ticketContent.reason }
        })

        if Config.Sound.Enabled then 
            if GetResourceState('rlo_sound') == 'missing' then 
                print('We ran into a issue: xSound is missing!')
                return
            else 
                exports['rlo_sound']:PlayUrl('ticket_notify_idfy', Config.Sound.URL, Config.Sound.Volume, false)
            end
        end
    end
end)

RegisterNUICallback('waypoint', function(data) 
    SetNewWaypoint(data.x, data.y)
    ShowNotification(Translation['set_waypoint'])
end)

RegisterNUICallback('teleport', function(targetId) 
    ESX.TriggerServerCallback('rlo_ticketpanel:callback:getTargetCoords', function(targetCoords)
        ESX.Game.Teleport(PlayerPedId(), targetCoords, function()
            ShowNotification(Translation['teleported'])
        end)
    end, targetId)
end)

RegisterNUICallback('syncDelete', function(uniqueId)  TriggerServerEvent('rlo_ticketpanel:server:syncDelete', uniqueId) end)
RegisterNetEvent('rlo_ticketpanel:client:syncDelete', function(uniqueId) SendNUIMessage({type = 'removeTicket', uniqueId = uniqueId}) end)

RegisterNUICallback('syncState', function(ticketContent)  
    print('(Client) syncing this is the ticket content:', ESX.DumpTable(ticketContent))
    TriggerServerEvent('rlo_ticketpanel:server:syncState', ticketContent) 
end)
RegisterNetEvent('rlo_ticketpanel:client:syncState', function(ticketContent) SendNUIMessage({type = 'syncState', ticketContent = ticketContent}) end)


RegisterNetEvent('rlo_ticketpanel:client:syncOnJoin', function(activeTickets)
    print('Active Tickets: '..ESX.DumpTable(activeTickets))
    for uniqueId, ticketContent in pairs(activeTickets) do
        print('uniqueId: '..uniqueId.. ' | ticketContent: '..ESX.DumpTable(ticketContent))
        SendNUIMessage({type = 'createRequest', ticketContent = ticketContent})
    end
end)