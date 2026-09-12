Bridge = {}

function Bridge.TriggerServerCallback(name, cb, ...)
    if Config.Framework == 'qb' then
        Core.Object.Functions.TriggerCallback(name, cb, ...)
    else
        Core.Object.TriggerServerCallback(name, cb, ...)
    end
end

function Bridge.Notify(message)
    if Config.Framework == 'qb' then
        Core.Object.Functions.Notify(message)
    else
        Core.Object.ShowNotification(message)
    end
end

function Bridge.Teleport(coords, cb)
    if Config.Framework == 'qb' then
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
        if cb then cb() end
    else
        Core.Object.Game.Teleport(PlayerPedId(), coords, cb)
    end
end
