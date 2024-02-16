RegisterNetEvent('jtm_carwash:pay', function()
    local _source = source
    local safe = false
    for k,v in pairs(Config.Locations) do
        if #(GetEntityCoords(GetPlayerPed(_source)) - v) < 15.0 then
            safe = true
        end
    end
    if not safe then
        -- Ban Event
        return
    end
    exports.ox_inventory:RemoveItem(_source, 'money', Config.Price)
end)