-- Perfection's Items - Client Side
-- Simplified client-side script

-- Access shared utilities from global namespace (set by shared/Utils.lua)
local Utils = PerfectionsItems.Utils

Utils.debugPrint("Client module loading...")

-- Initialize on game start
Events.OnGameStart.Add(function()
    Utils.debugPrint("Client initialized")
end)

Utils.debugPrint("Client module loaded successfully")