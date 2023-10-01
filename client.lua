RegisterNetEvent("teleport_script:tpa")
RegisterNetEvent("teleport_script:tp_accept")
RegisterNetEvent("teleport_script:tp_deny")
RegisterNetEvent("teleport_script:notification")
RegisterNetEvent("teleport_script:chat_notification")

local request = nil

AddEventHandler("teleport_script:notification", function(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end)

AddEventHandler("teleport_script:chat_notification", function(text)	
    TriggerEvent("chat:addMessage", {
	color = { 18, 197, 101 },
	multiline = true,
	args = { "Téléportation", text }
    })
end)

local setCoolDown = function()
    SetTimeout(3000 * 60, function()
        if request ~= nil then
            TriggerServerEvent("teleport_script:tp_downed", request.id)
            request = nil
        end
    end)
end

AddEventHandler("teleport_script:tpa", function(player)
    if request ~= nil then
        TriggerServerEvent("teleport_script:tp_cannot_teleport", player.id)
    elseif request == nil then
	request = player
        setCoolDown()
        TriggerServerEvent("teleport_script:tp_can_teleport", player.id)
    end
end)

AddEventHandler("teleport_script:tp_accept", function()
    if request ~= nil then
        local playerCoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent("teleport_script:tp_accepted", request.id, playerCoords)
        request = nil
    elseif request == nil then
        TriggerEvent("teleport_script:chat_notification", "Vous n'avez pas de demande en cours.")
    end
end)

AddEventHandler("teleport_script:tp_deny", function()
    if request ~= nil then
        TriggerServerEvent("teleport_script:tp_denied", request.id)
        request = nil
    elseif request == nil then
        TriggerEvent("teleport_script:chat_notification", "Vous n'avez pas de demande en cours.")
    end
end)
