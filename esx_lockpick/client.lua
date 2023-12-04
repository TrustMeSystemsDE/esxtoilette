local isCooldown = false

RegisterNetEvent('esx_lockpick:notifyResult')
AddEventHandler('esx_lockpick:notifyResult', function(message)
    TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, message)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, location in ipairs(Config.Locations) do
            local playerPed = GetPlayerPed(-1)
            local x, y, z = table.unpack(location)
            local distance = GetDistanceBetweenCoords(GetEntityCoords(playerPed), x, y, z, true)

            if distance < Config.SearchRadius then
                local controlPressed = IsControlJustReleased(0, Config.UseKey)

                if controlPressed and not isCooldown then
                    print("Vor TriggerServerEvent")
                    TriggerServerEvent('esx_lockpick:tryToGetLockpick', x, y, z)
                    print("Nach TriggerServerEvent")
                    isCooldown = true
                    Citizen.SetTimeout(Config.CooldownTime * 1000, function()
                        isCooldown = false
                    end)
                end
                

                DrawText3D(x, y, z + 1.0, string.format(Config.Locale['press_to_search'], GetControlInstructionalButton(0, Config.UseKey, true)))
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)

    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextEdge(2, 0, 0, 0, 150)

    SetTextOutline()

    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(_x, _y)
end
