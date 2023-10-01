local players = {}

RegisterCommand("tpa", function(source, args)
    local playerSource = source
    local argsId = args[1]

    if players[playerSource] ~= nil then
        if argsId then
            if playerSource ~= tonumber(argsId) then
                if players[tonumber(argsId)] ~= nil then
                    TriggerClientEvent("teleport_script:tpa", players[tonumber(argsId)].id, players[playerSource])
                else
                    TriggerClientEvent("teleport_script:chat_notification", playerSource, "Le joueur n'est pas connecté.")
                end
            else
                TriggerClientEvent("teleport_script:chat_notification", playerSource, "Vous ne pouvez pas vous téléporter sur vous-même.")
            end
        else
            TriggerClientEvent("teleport_script:chat_notification", playerSource, "Vous devez indiquer un identifiant.")
        end
    end
end)

RegisterCommand("tpaccept", function(source, args)
    local playerSource = source
    if players[playerSource] ~= nil then
        TriggerClientEvent("teleport_script:tp_accept", playerSource)
    end
end)

RegisterCommand("tpdeny", function(source, args)
    local playerSource = source
    if players[playerSource] ~= nil then
        TriggerClientEvent("teleport_script:tp_deny", playerSource)
    end
end)

RegisterCommand("playerlist", function(source, args)
    local playerSource = source
    
    for _, player in pairs(players) do
        local text = ("%s (Id joueur : %s)"):format(player.name, player.id)
        TriggerClientEvent("teleport_script:chat_notification", playerSource, text)
    end
end)

RegisterServerEvent("teleport_script:tp_can_teleport")
RegisterServerEvent("teleport_script:tp_cannot_teleport")
RegisterServerEvent("teleport_script:tp_accepted")
RegisterServerEvent("teleport_script:tp_denied")
RegisterServerEvent("teleport_script:tp_downed")

AddEventHandler("teleport_script:tp_can_teleport", function(requesterId)
    local playerName = players[source].name
    local requesterName = players[requesterId].name
    TriggerClientEvent("teleport_script:chat_notification", source, ("%s veut se téléporter sur vous. /tpaccept ou /tpdeny"):format(requesterName))
    TriggerClientEvent("teleport_script:chat_notification", requesterId, ("Votre demande a été envoyée, attendez une réponse de %s."):format(playerName))
end)

AddEventHandler("teleport_script:tp_cannot_teleport", function(requesterId)
    local playerName = players[source].name
    TriggerClientEvent("teleport_script:chat_notification", requesterId, ("%s a déjà une demande en attente. Réessayez plus tard."):format(playerName))
end)

AddEventHandler("teleport_script:tp_accepted", function(id, coords)
    if players[id] ~= nil then
        SetEntityCoords(GetPlayerPed(id), coords.x, coords.y, coords.z - 1.0)
        TriggerClientEvent("teleport_script:chat_notification", source, ("%s s'est téléporté sur vous."):format(players[id].name))
        TriggerClientEvent("teleport_script:chat_notification", id, ("%s a accepté votre demande de téléportation."):format(players[source].name))
    else
        TriggerClientEvent("teleport_script:chat_notification", source, "Le joueur qui voulait se téléporter s'est déconnecté.")
    end
end)

AddEventHandler("teleport_script:tp_denied", function(id)
    if players[id] ~= nil then
        TriggerClientEvent("teleport_script:chat_notification", source, ("Vous avez refusé la demande de téléportation de %s."):format(players[id].name))
        TriggerClientEvent("teleport_script:chat_notification", id, ("%s a refusé votre demande de téléportation."):format(players[source].name))
    else
        TriggerClientEvent("teleport_script:chat_notification", source, "Le joueur qui voulait se téléporter s'est déconnecté.")
    end
end)

AddEventHandler("teleport_script:tp_downed", function(playerId)
    if players[playerId] ~= nil then
        
        TriggerClientEvent("teleport_script:chat_notification", source, ("La demande de %s s'est annulée après 3 minutes."):format(players[playerId].name))
        TriggerClientEvent("teleport_script:chat_notification", playerId, ("Votre demande à %s s'est annulée après 3 minutes."):format(players[source].name))
    else
        TriggerClientEvent("teleport_script:chat_notification", source, "Le joueur qui voulait se téléporter s'est déconnecté.")
    end
end)

AddEventHandler("playerJoining", function()
    local playerSource = source
    players[playerSource] = {
        name = GetPlayerName(playerSource),
        id = playerSource
    }

    if Config.Notifications then
        local user = players[playerSource]
        local text = ("%s - (%s) a rejoint le serveur."):format(user.name, user.id)
        TriggerClientEvent("teleport_script:notification", -1, text)
    end
end)

AddEventHandler("playerDropped", function()
    local playerSource = source
    local user = players[playerSource]

    if user then
        if Config.Notifications then
            local text = ("%s - (%s) a quitté le serveur."):format(user.name, user.id)
            TriggerClientEvent("teleport_script:notification", -1, text)
        end

        players[playerSource] = nil
    end
end)