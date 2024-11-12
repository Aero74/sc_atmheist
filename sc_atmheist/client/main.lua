ESX = exports['es_extended']:getSharedObject()

local ModelATM = Config.ModelATM
local ox_target = exports.ox_target
local plantCooldown = {}
local hasBag = false

ox_target:addModel(ModelATM, {
    {
        name = 'PlantThermite',
        onSelect = function()
            PlantThermite()
        end,
        items = Config.Reward.removeItem,
        icon = 'fas fa-bomb',
        label = 'Plant the thermite',
    }
})

function PlantThermite()
    local playerPed = PlayerPedId()
    local playerId = GetPlayerServerId(PlayerId())
    local currentTime = GetGameTimer()

    if plantCooldown[playerId] and currentTime < plantCooldown[playerId] then
        local remainingTime = math.floor((plantCooldown[playerId] - currentTime) / 1000 / 60)

        exports['sc-notify']:scnotification("info", 'You will have to wait ' .. remainingTime .. ' minutes before putting the thermite on again')
        
        return
    end

    local coords = GetEntityCoords(playerPed)
    local thermiteModel = 'hei_prop_heist_thermite'
    local explosionTime = 10000

    local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'easy'}, {'w', 'a', 's', 'd'})
    if success then
        plantCooldown[playerId] = currentTime + (1800 * 1000)

        if lib.progressBar({
            duration = 5000,
            label = 'Planting thermite...',
            useWhileDead = false,
            canCancel = true,
            disable = { car = true, move = true },
            anim = {
                dict = 'anim@heists@ornate_bank@thermal_charge',
                clip = 'thermal_charge'
            },
            prop = {
                model = 'hei_prop_heist_thermite', 
                pos = vec3(0.0, 0.0, 0.0),
                rot = vec3(0.0, 0.0, 0.0)
            }
        }) then
            TriggerServerEvent('sleepycode-atmheist:RemoveThermit')
            ox_target:removeModel(ModelATM, 'PlantThermite')

            RequestModel(thermiteModel)
            while not HasModelLoaded(thermiteModel) do 
                Wait(0)
            end

            lib.showTextUI('Thermite will explode in 10 seconds', {position = 'top-center'})
            local timer = 10
            CreateThread(function()
                while timer > 0 do 
                    Wait(1000)
                    timer = timer - 1
                    lib.showTextUI('Thermite will explode in ' .. timer .. ' seconds!', {position = 'top-center'})
                end
                lib.hideTextUI()
        
                AddExplosion(coords.x, coords.y, coords.z, 2, 1.0, true, false, 1.0)
                TakeMoney()
            end)
        else
            exports['sc-notify']:scnotification("error", "You canceled the thermite planting")
        end
    else
        exports['sc-notify']:scnotification("error", "You planted the thermite incorrectly")
    end
end

function TakeMoney()
            ox_target:addModel(ModelATM, {
                {
                    name = 'TakeMoney',
                    items = 'bag',
                    onSelect = function()
                        if lib.progressBar({
                            duration = 15000,
                            label = 'Grabing money...',
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                move = true,
                                car = true,
                            },
                            anim = {
                                dict = 'anim@amb@casino@out_of_money@ped_male@02a@idles',
                                clip = 'idle_a'
                            },
                            prop = {
                                model = 'bkr_prop_money_sorted_01',
                                pos = vec3(0.03, 0.03, 0.02),
                                rot = vec3(0.0, 0.0, -1.5)
                            },
                        }) 
                        then
                            ox_target:removeModel(ModelATM, 'TakeMoney')
                            ox_target:addModel(ModelATM, {name = 'PlantThermite', onSelect = function() PlantThermite() end, items = 'thermit', icon = 'fas fa-bomb', label = 'Plant the thermite',})
                            TriggerServerEvent('sleepycode-atmheist:CollectMoney')
                            exports['sc-notify']:scnotification("success", "You collected all the cash")
                        else 
                            exports['sc-notify']:scnotification("error", "You have interrupted the collection of money")
                        end
                    end,
                    icon = 'fas fa-money-bill',
                    label = 'Grab cash',
                }
            })
end
