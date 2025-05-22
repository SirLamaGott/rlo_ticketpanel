local WEBHOOK_URL = 'DISCORD_WEBHOOK_HERE'

function tableHasValue(table, value)
    if table == nil or value == nil then 
        return 
    end
    for _, v in ipairs(table) do 
        if v == value then 
            return true 
        end 
    end
    return false
end

function generateRandomNumber(length)
    math.randomseed(os.time())
    local randomNumber = ""
    for i = 1, length do
        local rand = math.random(0, 9)
        randomNumber = randomNumber .. rand
    end
    return tonumber(randomNumber)
end

function SendWebhook(source, msg)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerCoords = xPlayer.getCoords(true)
    local playerId = xPlayer.identifier
    local playerName = xPlayer.getName()

    local timestamp = os.time()
    local color = (#ESX.GetExtendedPlayers('group', 'admin') <= 0) and 15548997 or 5763719

    local embed = {
        {
            ["color"] = color,
            ["author"] = {
                name = 'RLO LOGGER',
                icon_url = 'https://reallifeonline.net/images/rlo3logobackground.png'
            },
            ["title"] = '🎟️ NEW TICKET',
            ["description"] = table.concat({
                '**' .. playerName .. '** requested an admin for: ' .. msg,
                '',
                '**Server ID:** ' .. source,
                '**Username:** ' .. GetPlayerName(source),
                '**Identifier:** ' .. playerId,
                '**Coords:** ' .. tostring(playerCoords),
                '',
                '<t:' .. timestamp .. ':R>'
            }, '\n'),
            ["footer"] = {
                text = "Real Life Online - Logger"
            }
        }
    }

    -- HTTP-Anfrage senden
    PerformHttpRequest(WEBHOOK_URL, function(err, text, headers) 
        if err ~= 200 then print("Webhook Error: " .. (text or "Unknown error")) end
    end, 'POST', json.encode({username = "RLO Logger", embeds = embed}), { ['Content-Type'] = 'application/json' })
end