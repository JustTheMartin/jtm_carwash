local Blips = {}

CreateThread(function()
    for k,v in pairs(Config.Locations) do
        Blips[k] = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(Blips[k], 100)
        SetBlipDisplay(Blips[k], 4)
        SetBlipScale(Blips[k], 0.8)
        SetBlipColour(Blips[k], 0)
        SetBlipAsShortRange(Blips[k], true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString((Config.Font ~= false and '<font face="' .. Config.Font .. '">' or "") .. "Car Wash")
        EndTextCommandSetBlipName(Blips[k])
    end
end)

local washing = false

local function effect(veh)
    local pos = GetEntityCoords(veh)
    local off = GetOffsetFromEntityGivenWorldCoords(veh, pos.x, pos.y, pos.z)
    UseParticleFxAssetNextCall('core')
    StartParticleFxNonLoopedOnEntity('water_splash_vehicle', veh, off.x, off.y, off.z + 1.0, 0.0, 0.0, 0.0, 10.0, false, false, false)
end

local function washCar()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    FreezeEntityPosition(veh, true)
    SetVehicleEngineOn(veh, false, true, true)
    washing = true
    CreateThread(function()
        for i=1, 3, 1 do
            effect(veh)
            Wait(Config.Duration/3)
        end
    end)
    if ProgressBar(Config.Duration, "Machine is washing your car") then
        if Config.ProgressBar ~= "ox" then Wait(Config.Duration) end
        SetVehicleEngineOn(veh, true, true, false)
        FreezeEntityPosition(veh, false)
        SetVehicleDirtLevel(veh, 0.1)
        Notify('Your vehicle has been washed', "success")
    end
    washing = false
end

if Config.Interaction == "E" then
    CreateThread(function()
        local shown = false
        while true do
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) and not washing then
                local letSleep = true
                local pCoords = GetEntityCoords(ped)
                for k,v in pairs(Config.Locations) do
                    if #(pCoords - v) < 4.88 then
                        letSleep = false
                        if Config.HelpText == "esx" then    
                            HelpText("Press ~INPUT_CONTEXT~ to wash car for ~g~$" .. tostring(Config.Price))
                        else
                            if not shown then
                                HelpText("[E] Wash car for $" .. tostring(Config.Price))
                                shown = true
                            end
                        end
                        if IsControlJustPressed(0, 38) then
                            if exports.ox_inventory:Search('count', 'money') >= Config.Price then
                                if Config.HelpText ~= "esx" and shown then
                                    HideText()
                                    shown = false
                                end
                                TriggerServerEvent('jtm_carwash:pay')
                                washCar()
                            else
                                Notify("You can't afford an car wash")
                            end
                        end
                    end
                end
                if letSleep then
                    if Config.HelpText ~= "esx" and shown then
                        HideText()
                        shown = false
                    end
                    Wait(1000)
                else
                    Wait(0)
                end
            else
                Wait(2000)
            end
        end
    end)
elseif Config.Interaction == "target" then
    for k,v in pairs(Config.Locations) do
        exports.ox_target:addSphereZone({
            coords = v,
            radius = 4,
            debug = false,
            drawSprite = true,
            options = {
                {
                    icon = 'fa-solid fa-car',
                    label = "Wash car for $50",
                    onSelect = function()
                        washCar()
                    end,
                    canInteract = function()
                        return not washing
                    end
                }
            }
        })
    end
end