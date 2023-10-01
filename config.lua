Config = {
    Notifications = true, -- Player login and logout notification

    --[[ Language = "fr",

    Languages = {

        ['fr'] = {
            ["no_current_request"] = "Vous n'avez pas de demande en cours.",
            ["player_not_connected"] = "Le joueur n'est pas connecté.",
            -- ...
        },

        ['en'] = {
            ["no_current_request"] = "You have no current request.",
            ["player_not_connected"] = "The player is not connected.",
            -- ...
        }
    },

    Translate = function(string)
        local text = Config.Languages[Config.Language][string]

        if text then
            return text
        else
            return ("Unable to translate an undefined value '%s'."):format(string)
        end
    end ]]--
}