-- Perfection's Items - Shared Utilities
-- Common functions used across client and server

local PerfectionsItems = PerfectionsItems or {}
PerfectionsItems.Utils = PerfectionsItems.Utils or {}

-- Shared debug logging function
function PerfectionsItems.Utils.debugPrint(msg)
    print("[PI] " .. tostring(msg))
end

-- Make the namespace globally accessible
_G.PerfectionsItems = PerfectionsItems

return PerfectionsItems.Utils