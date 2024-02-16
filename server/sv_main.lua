RegisterNetEvent('jtm_carwash:pay', function()
    local _source = source
    exports.ox_inventory:RemoveItem(_source, 'money', 50)
end)