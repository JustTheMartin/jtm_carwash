CreateThread(function()
    for k,v in pairs(Config.Locations) do
        createNewBlip({
            coords = v,
            sprite = 100,
            display = 4,
            scale = 0.85,
            colour = 0,
            isShortRange = true,
            text = 'Automyčka'
        })
    end
end)

CreateThread(function()
    while true do
        local letSleep = true
        if exports['baseevents']:GetVehAct('inVehicle') and exports['baseevents']:GetVehAct('VehicleSeat') == -1 then
            local ped = PlayerPedId()
            local pCoords = GetEntityCoords(ped)
            for k,v in pairs(Config.Locations) do
                if #(pCoords - v) < 4.88 then
                    letSleep = false
                    local vehcoords = GetEntityCoords(GetVehiclePedIsIn(ped))
                    exports['basicscripts']:DrawM3Text(vehcoords.x, vehcoords.y, vehcoords.z, '[E] Umýt auto za $' .. Config.Price, '0.040')
                    if IsControlJustPressed(0, 38) then
                        washCar()
                        ESX.TriggerServerCallback('esx_eden_clotheshop:payFee', function(paid)
                            if paid then
                                washCar()
                            else
                                exports['notify']:showAlert('Nemáš dostatek peněz', 'red', '5000')
                            end
                        end, Config.Price)
                    end
                end
            end
        else
            Wait(750)
        end
        if letSleep then
            Wait(1000)
        else
            Wait(0)
        end
    end
end)

function washCar()
    if exports['baseevents']:GetVehAct('VehicleSeat') == -1 and exports['baseevents']:GetVehAct('inVehicle') then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        exports['pogressBar']:drawBar(15000, 'Stroj ti čistí vozidlo')
        FreezeEntityPosition(vehicle, true)
        SetVehicleEngineOn(vehicle, false, true, true)
        effect()
        Wait(5000)
        effect()
        Wait(5000)
        effect()
        Wait(5000)
        SetVehicleEngineOn(vehicle, true, true, false)
        FreezeEntityPosition(vehicle, false)
        SetVehicleDirtLevel(vehicle, 0.1)
        exports['notify']:showAlert('Čištění bylo dokončeno, bylo ti vzato $' .. Config.Price, 'green', '5000')
    elseif exports['baseevents']:GetVehAct('VehicleSeat') ~= -1 then
        exports['notify']:showAlert('Nesedíš na mistě řidiče', 'red', '5000')
    elseif not exports['baseevents']:GetVehAct('inVehicle') then
        exports['notify']:showAlert('Nesedíš v autě', 'red', '5000')
    end
end

function effect()
    local pos = GetWorldPositionOfEntityBone(GetVehiclePedIsIn(PlayerPedId(), false), boneIndex)
    local off = GetOffsetFromEntityGivenWorldCoords(GetVehiclePedIsIn(PlayerPedId(), false), pos.x, pos.y, pos.z)
    UseParticleFxAssetNextCall('core')
    StartParticleFxNonLoopedOnEntity('water_splash_vehicle', GetVehiclePedIsIn(PlayerPedId(), false), off.x, off.y, off.z + 1.0, 0.0, 0.0, 0.0, 10.0, false, false, false)
end