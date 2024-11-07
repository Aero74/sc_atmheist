ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('sleepycode-atmheist:RemoveThermit')
AddEventHandler('sleepycode-atmheist:RemoveThermit', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem(Config.Reward.removeItem, Config.Reward.removeItemCount)
end)

RegisterNetEvent('sleepycode-atmheist:CollectMoney')
AddEventHandler('sleepycode-atmheist:CollectMoney', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local mathRandom = math.random(1000, 10000) -- Ranges of money a player can get

    xPlayer.addInventoryItem(Config.Reward.addItem, mathRandom) 
end)