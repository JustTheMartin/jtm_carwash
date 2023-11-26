ESX.RegisterServerCallback('jtm_carwash:washCar', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getAccount('bank').money >= Config.Price then
        xPlayer.removeAccountMoney('bank', Config.Price)
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'You paid $' .. Config.Price .. ' from bank',
            type = 'success'
        })
		cb(true)
    elseif xPlayer.getMoney() >= Config.Price then
        xPlayer.removeMoney(Config.Price)
        TriggerClientEvent('ox_lib:notify', source, {
            description = 'You paid $' .. Config.Price .. ' in cash',
            type = 'success'
        })
		cb(true)
    else
		cb(false)
	end
end)