local isAdmin = false

CreateThread(function()
    ESX.TriggerServerCallback('rlo_ticketpanel:callback:isAdmin', function(result)
        isAdmin = result
    end)
end)

RegisterNetEvent('rlo_ticketpanel:client:showNotification', function(args) 
    ShowNotification(args) 
end)

function ShowNotification(args)
    ESX.ShowNotification(args)
end

function DrawText3D(x, y, z)
    if not isAdmin then return end
    
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end
    
    local camCoords = GetGameplayCamCoords()
    local dist = #(vector3(x, y, z) - camCoords)
    
    if dist > 25.0 then return end
    
    local scale = (1.0 / dist) * 2.0
    
    if scale > 0.5 then scale = 0.5 end
    
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 165, 0, 220)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString('~o~Ticket')
    DrawText(_x, _y)
end
