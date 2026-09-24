Bridge = {}

function Bridge.RegisterServerCallback(name, cb)
    if Config.Framework == 'qb' then
        Core.Object.Functions.CreateCallback(name, cb)
    else
        Core.Object.RegisterServerCallback(name, cb)
    end
end

function Bridge.GetCoords(source)
    if Config.Framework == 'qb' then
        local ped = GetPlayerPed(source)
        return ped ~= 0 and GetEntityCoords(ped) or nil
    else
        local xPlayer = Core.Object.GetPlayerFromId(source)
        return xPlayer and xPlayer.getCoords(true)
    end
end

function Bridge.GetName(source)
    if Config.Framework == 'qb' then
        local Player = Core.Object.Functions.GetPlayer(source)
        return Player and (Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname) or GetPlayerName(source)
    else
        local xPlayer = Core.Object.GetPlayerFromId(source)
        return xPlayer and xPlayer.getName() or GetPlayerName(source)
    end
end

function Bridge.GetIdentifier(source)
    if Config.Framework == 'qb' then
        local Player = Core.Object.Functions.GetPlayer(source)
        return Player and Player.PlayerData.citizenid
    else
        local xPlayer = Core.Object.GetPlayerFromId(source)
        return xPlayer and xPlayer.identifier
    end
end

function Bridge.IsAdmin(source)
    source = tonumber(source)
    if not source then return false end

    if Config.Framework == 'qb' then
        for _, group in ipairs(Config.Groups) do
            if Core.Object.Functions.HasPermission(source, group) then
                return true
            end
        end
        return false
    else
        local xPlayer = Core.Object.GetPlayerFromId(source)
        return xPlayer ~= nil and tableHasValue(Config.Groups, xPlayer.getGroup())
    end
end

function Bridge.CountOnlineAdmins()
    local count = 0
    for _, id in ipairs(GetPlayers()) do
        if Bridge.IsAdmin(id) then
            count = count + 1
        end
    end
    return count
end

function Bridge.OnPlayerLoaded(cb)
    if Config.Framework == 'qb' then
        RegisterNetEvent('QBCore:Server:PlayerLoaded', function(Player)
            cb(Player.PlayerData.source)
        end)
    else
        RegisterNetEvent('esx:playerLoaded', function(playerId)
            cb(playerId)
        end)
    end
end
