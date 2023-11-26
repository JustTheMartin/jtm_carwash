CreateThread(function()
    for i = 1, #Config.Locations, 1 do
        local blips = AddBlipForCoord(Config.Locations[i].x, Config.Locations[i].y, Config.Locations[i].z)
        SetBlipSprite(blips, 100)
        SetBlipDisplay(blips, 4)
        SetBlipScale(blips, 0.85)
        SetBlipColour(blips, 0)
        SetBlipAsShortRange(blips, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Car Wash')
        EndTextCommandSetBlipName(blips)
    end
end)

CreateThread(function()
    while true do
        if IsPedInAnyVehicle(PlayerPedId(), false) and GetPedVehicleSeat(PlayerPedId()) == -1 then
            local ped = PlayerPedId()
            local pCoords = GetEntityCoords(ped)
            local letSleep = true
            for k,v in pairs(Config.Locations) do
                if #(pCoords - v) < 4.88 then
                    letSleep = false
                    local vehcoords = GetEntityCoords(GetVehiclePedIsIn(ped))
                    DrawM3Text(vehcoords.x, vehcoords.y, vehcoords.z, '[E] Wash car for $' .. Config.Price, '0.040')
                    if IsControlJustPressed(0, 38) then
                        ESX.TriggerServerCallback('jtm_carwash:washCar', function(paid)
                            if paid then
                                washCar()
                            else
                                lib.notify({
                                    description = "You don't have enough money",
                                    type = "error"
                                })
                            end
                        end)
                    end
                end
            end
            if letSleep then
                Wait(1000)
            else
                Wait(0)
            end
        else
            Wait(2000)
        end
    end
end)

function washCar()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    effect()
    FreezeEntityPosition(vehicle, true)
    SetVehicleEngineOn(vehicle, false, true, true)
    if lib.progressBar({
        duration = Config.WaitTime,
        label = 'Machine is cleaning the car',
        useWhileDead = false,
        allowRagdoll = false,
        allowCuffed = false,
        allowFalling = false,
        canCancel = false,
        disable = {
            car = false,
            move = true,
            combat = true
        }
    }) then
        SetVehicleEngineOn(vehicle, true, true, false)
        FreezeEntityPosition(vehicle, false)
        SetVehicleDirtLevel(vehicle, 0.1)
        lib.notify({
            description = "Washing's done",
            type = "success"
        })
    end
end