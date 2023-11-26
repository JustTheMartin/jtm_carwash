function DrawM3Text(x, y, z, text, fl)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.55, 0.31)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextOutline(1)
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (utf8.len(text)) / 320
        DrawRect(_x,_y+0.0135, fl+ factor, 0.03, 0, 0, 0, 125)
    end
end

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end

function effect()
    effects()
    Wait(Config.WaitTime / 3)
    effects()
    Wait(Config.WaitTime / 3)
    effects()
end

function effects()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local pos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'wheel_lr'))
    local off = GetOffsetFromEntityGivenWorldCoords(veh, pos.x, pos.y, pos.z)
    UseParticleFxAssetNextCall('core')
    StartParticleFxNonLoopedOnEntity('water_splash_vehicle', veh, off.x, off.y, off.z + 1.0, 0.0, 0.0, 0.0, 10.0, false, false, false)
end