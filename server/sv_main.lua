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
        if Bridge.IsAdmin(id) then
            TriggerClientEvent('rlo_ticketpanel:client:syncRequest', id, ticketContent)
        end
    end
end

Bridge.RegisterServerCallback('rlo_ticketpanel:callback:getTargetCoords', function(source, cb, playerId)
    if not Bridge.IsAdmin(source) then return cb(nil) end
    cb(Bridge.GetCoords(playerId))
end)

Bridge.RegisterServerCallback('rlo_ticketpanel:callback:isAdmin', function(source, cb)
    cb(Bridge.IsAdmin(source))
end)

RegisterCommand(Config.TicketCommand or 'support', function(source, args)
    local message = table.concat(args, ' '):match("^%s*(.-)%s*$") or ""

    if Config.RequiresReason and message == "" then
        TriggerClientEvent('rlo_ticketpanel:client:showNotification', source, Translation['requires_reason'])
        return
    end

    TriggerClientEvent('rlo_ticketpanel:client:showNotification', source, Translation['ticket_created'])
    CreateTicket(source, message ~= '' and message or Translation['no_message_provided'])
    SendWebhook(source, message)
end, false)

RegisterNetEvent('rlo_ticketpanel:server:syncDelete', function(uniqueId)
    local source = source
    if not Bridge.IsAdmin(source) then return end

    for id, ticketContent in pairs(activeTickets) do
        if ticketContent.uniqueId == uniqueId then
            activeTickets[id] = nil
        end
    end

    for _, id in ipairs(GetPlayers()) do
        if Bridge.IsAdmin(id) then
            TriggerClientEvent('rlo_ticketpanel:client:syncDelete', id, uniqueId)
        end
    end
end)

RegisterNetEvent('rlo_ticketpanel:server:syncState', function(ticketContent)
    local source = source
    if not Bridge.IsAdmin(source) then return end

    local packedTicket
    for id, requestContent in pairs(activeTickets) do
        if requestContent.uniqueId == ticketContent.uniqueId then
            activeTickets[id].claimedBy = GetPlayerName(source)
            packedTicket = activeTickets[id]
        end
    end
    if not packedTicket then return end

    for _, id in ipairs(GetPlayers()) do
        if Bridge.IsAdmin(id) then
            TriggerClientEvent('rlo_ticketpanel:client:syncState', id, packedTicket)
        end
    end
end)

Bridge.OnPlayerLoaded(function(playerId)
    if Bridge.IsAdmin(playerId) then
        TriggerClientEvent('rlo_ticketpanel:client:syncOnJoin', playerId, activeTickets)
    end
end)
