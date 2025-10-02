-- Perfection's Items - Server Side
-- Simplified server-side script using ModOptions

-- Import shared utilities
local Utils = require("shared/Utils")

Utils.debugPrint("Server module loading...")

-- Get options from global namespace (set by client/options file)
local function getOptions()
    if PerfectionsItems and PerfectionsItems.OPTIONS then
        return PerfectionsItems.OPTIONS
    end
    -- Default fallback if ModOptions not available
    return {
        EnableWoodenSword = true,
        EnableBokuto = true,
        EnableCraftingManual = true,
    }
end

-- Import Easy Distributions API utilities
local EasyDistAPI = require("EasyDistributionsAPI")

-- Handle optional item spawning using Easy Distributions API
local function setupSpawnControl()
    local options = getOptions()
    
    -- Use Easy Distributions API to conditionally disable item spawns
    local itemsToControl = {
        {itemType = "PerfectionsItems.WoodenSword", enabled = options.EnableWoodenSword, name = "Wooden Sword"},
        {itemType = "PerfectionsItems.Bokuto", enabled = options.EnableBokuto, name = "Bokuto"},
        {itemType = "PerfectionsItems.BokutoMagazine", enabled = options.EnableCraftingManual, name = "Crafting Manual"}
    }
    
    for _, itemConfig in ipairs(itemsToControl) do
        if not itemConfig.enabled then
            -- Use Easy Distributions API to disable item spawning
            EasyDistAPI.removeFromAllDistributions(itemConfig.itemType)
            Utils.debugPrint(itemConfig.name .. " spawns disabled via Easy Distributions API")
        end
    end
end

-- Setup spawn control when server starts
Events.OnServerStarted.Add(setupSpawnControl)

-- Initialize on server start
Events.OnServerStarted.Add(function()
    Utils.debugPrint("Server started")
    local options = getOptions()
    Utils.debugPrint("Wooden Sword Spawns: " .. tostring(options.EnableWoodenSword))
    Utils.debugPrint("Bokuto Spawns: " .. tostring(options.EnableBokuto))
    Utils.debugPrint("Crafting Manual Spawns: " .. tostring(options.EnableCraftingManual))
    Utils.debugPrint("Using Easy Distributions API for spawn control")
end)

Utils.debugPrint("Server module loaded successfully")