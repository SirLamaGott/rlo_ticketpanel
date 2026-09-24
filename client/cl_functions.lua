RegisterNetEvent('rlo_ticketpanel:client:showNotification', function(args) ShowNotification(args) end)

function ShowNotification(args)
    Bridge.Notify(args)
end