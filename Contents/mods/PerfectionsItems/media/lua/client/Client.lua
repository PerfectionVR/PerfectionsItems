-- Perfection's Items - Client Side
-- Simplified client-side script

-- Import shared utilities
local Utils = require("shared/Utils")

Utils.debugPrint("Client module loading...")

-- Initialize on game start
Events.OnGameStart.Add(function()
    Utils.debugPrint("Client initialized")
end)

Utils.debugPrint("Client module loaded successfully")