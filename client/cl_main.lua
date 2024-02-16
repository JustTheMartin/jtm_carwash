local CurrentVehicle, CurrentSeat, PedIsInVehicle = nil, nil, false

AddEventHandler("baseevents:enteredVehicle", function(veh, seat)
    CurrentVehicle, CurrentSeat = veh, seat
    PedIsInVehicle = true
    inVehicle()
end)

AddEventHandler("baseevents:leftVehicle", function()
    CurrentVehicle, CurrentSeat = nil, nil
    PedIsInVehicle = false
end)

local Locations = {
	vec3(26.5906, -1392.0261, 29.7634),
	vec3(167.1034, -1719.4704, 27.2916),
	vec3(-74.5693, 6427.8715, 29.4400),
	vec3(-699.6325, -932.7043, 17.0139)
}

CreateThread(function()
    for k,v in pairs(Locations) do
        exports.basicscripts:createNewBlip({
            coords = v,
            sprite = 100,
            display = 4,
            scale = 0.8,
            colour = 0,
            isShortRange = true,
            text = 'Automyčka'
        })
    end
end)

local washing = false

function inVehicle()
    CreateThread(function()
        local shown = false
        while PedIsInVehicle do
            if CurrentSeat == -1 then
                local ped = PlayerPedId()
                local letSleep = true
                local pCoords = GetEntityCoords(ped)
                for k,v in pairs(Locations) do
                    if #(pCoords - v) < 4.88 then
                        letSleep = false
                        if not shown then
                            exports.jtm_textui:showText("Umýt auto za $50", "E")
                            shown = true
                        end
                        if IsControlJustPressed(0, 38) then
                            if exports.ox_inventory:Search('count', 'money') >= 50 or exports.ox_inventory:Search('count', 'money') >= 50 then
                                TriggerServerEvent('jtm_carwash:pay')
                                washCar()
                            else
                                exports['notify']:showAlert("Nemáš dostatek peněz", 'red', '5000')
                            end
                        end
                    end
                end
                if letSleep or washing then
                    if shown then
                        exports.jtm_textui:hideText()
                        shown = false
                    end
                    Wait(1000)
                else
                    Wait(0)
                end
            else
                if shown then
                    exports.jtm_textui:hideText()
                    shown = false
                end
                Wait(2000)
            end
        end
        if shown then
            exports.jtm_textui:hideText()
            shown = false
        end
    end)
end

function washCar()
    FreezeEntityPosition(CurrentVehicle, true)
    SetVehicleEngineOn(CurrentVehicle, false, true, true)
    washing = true
    effect()
    exports.pogressBar:drawBar(15000, 'Stroj ti čistí auto')
    Wait(5000)
    effect()
    Wait(5000)
    effect()
    Wait(5000)
    effect()
    SetVehicleEngineOn(CurrentVehicle, true, true, false)
    FreezeEntityPosition(CurrentVehicle, false)
    SetVehicleDirtLevel(CurrentVehicle, 0.1)
    washing = false
    exports['notify']:showAlert("Čištění bylo dokončeno, bylo ti vzato $50", 'green', '5000')
end

function effect()
    local pos = GetWorldPositionOfEntityBone(CurrentVehicle, boneIndex)
    local off = GetOffsetFromEntityGivenWorldCoords(CurrentVehicle, pos.x, pos.y, pos.z)
    UseParticleFxAssetNextCall('core')
    StartParticleFxNonLoopedOnEntity('water_splash_vehicle', CurrentVehicle, off.x, off.y, off.z + 1.0, 0.0, 0.0, 0.0, 10.0, false, false, false)
end