ESX = nil
local cooldowns = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_lockpick:tryToGetLockpick')
AddEventHandler('esx_lockpick:tryToGetLockpick', function(x, y, z)
    local playerID = source
    print("TriggerServerEvent erreicht für Spieler " .. playerID)

    if not cooldowns[playerID] or (os.time() - cooldowns[playerID]) > Config.CooldownTime then
        local chance = math.random(1, 100)

        if chance <= Config.ChanceToGetLockpick then
            local xPlayer = ESX.GetPlayerFromId(playerID)
            xPlayer.addInventoryItem(Config.LockpickItem, 1)
            TriggerClientEvent('esx_lockpick:notifyResult', playerID, Config.Locale['lockpick_found'])
        else
            TriggerClientEvent('esx_lockpick:notifyResult', playerID, Config.Locale['nothing_found'])
        end

        cooldowns[playerID] = os.time()
    else
        TriggerClientEvent('esx_lockpick:notifyResult', playerID, Config.Locale['cooldown_active'])
    end
end)
