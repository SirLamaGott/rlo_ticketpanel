local activeTickets = {}

function CreateTicket(playerId, reason)
    local uniqueId = generateRandomNumber(16)
    local playerPed = GetPlayerPed(playerId)
    local playerCoords = playerPed and GetEntityCoords(playerPed) or vector3(0, 0, 0)
    local playerName = GetPlayerName(playerId) or 'Unknown'
    local time = os.date('%H:%M')

    local ticketContent = {
        uniqueId = uniqueId,
        claimedBy = Translation['ticket_open'],
        reason = reason,
        time = time,
        playerId = playerId,
        playerName = playerName,
        playerCoords = playerCoords,
    }
    
    activeTickets[uniqueId] = ticketContent

    for _, id in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer and tableHasValue(Config.Groups, xPlayer.getGroup()) then 
            xPlayer.triggerEvent('rlo_ticketpanel:client:syncRequest', activeTickets, uniqueId)
        end
    end
end

ESX.RegisterServerCallback('rlo_ticketpanel:callback:getTargetCoords', function(src, cb, playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local playerCoords = xPlayer.getCoords(true)
   cb(playerCoords)
end)

ESX.RegisterServerCallback('rlo_ticketpanel:callback:isAdmin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
        if tableHasValue(Config.Groups, xPlayer.getGroup()) then 
            cb(true)
		else
			cb(false)
        end
	else
		cb(false)
	end
end)

RegisterCommand(Config.TicketCommand or 'support', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local message = table.concat(args, ' '):match("^%s*(.-)%s*$") or ""
    
    if Config.RequiresReason and message == "" then
        xPlayer.triggerEvent('rlo_ticketpanel:client:showNotification', Translation['requires_reason'])
        return
    end
    
    xPlayer.triggerEvent('rlo_ticketpanel:client:showNotification', Translation['ticket_created'])
    CreateTicket(source, message ~= '' and message or Translation['no_message_provided'])
    SendWebhook(source, message)
end, false)

RegisterNetEvent('rlo_ticketpanel:server:syncDelete', function(uniqueId)
    for id, ticketContent in pairs(activeTickets) do
        if ticketContent.uniqueId == uniqueId then 
            activeTickets[id] = nil
        end
    end
    
    for _, id in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer ~= nil then 
            if tableHasValue(Config.Groups, xPlayer.getGroup()) then 
                xPlayer.triggerEvent('rlo_ticketpanel:client:syncDelete', uniqueId)
            end
        end
    end
end)

RegisterNetEvent('rlo_ticketpanel:server:syncState', function(ticketContent)
    local xAdmin = ESX.GetPlayerFromId(source)

    for id, requestContent in pairs(activeTickets) do
        if requestContent.uniqueId == ticketContent.uniqueId then 
            activeTickets[id].claimedBy = xAdmin.getName()
            packedTicket = activeTickets[id]
        end
    end
    
    for _, id in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer ~= nil then 
            if tableHasValue(Config.Groups, xPlayer.getGroup()) then 
                xPlayer.triggerEvent('rlo_ticketpanel:client:syncState', packedTicket)
            end
        end
    end
end)

RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
    if xPlayer ~= nil then 
        if tableHasValue(Config.Group, xPlayer.getGroup()) then 
            xPlayer.triggerEvent('rlo_ticketpanel:client:syncOnJoin', activeRequests)
        end
    end
end)