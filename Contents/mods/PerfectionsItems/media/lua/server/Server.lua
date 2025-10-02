-- Perfection's Items - Server Side
-- Pure Lua distribution system (Build 41 compatible, scalable to 100+ items)

-- Access shared utilities from global namespace (set by shared/Utils.lua)
local Utils = PerfectionsItems and PerfectionsItems.Utils

-- Import item distributions (defined in separate file for maintainability)
local ItemDistributions = require("server/Distributions")

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

-- Check if item should be disabled based on options
local function isItemDisabled(itemType)
    local options = getOptions()
    
    -- Map item types to their enable flags
    local itemFlags = {
        ["PerfectionsItems.WoodenSword"] = options.EnableWoodenSword,
        ["PerfectionsItems.Bokuto"] = options.EnableBokuto,
        ["PerfectionsItems.BokutoMagazine"] = options.EnableCraftingManual,
    }
    
    local enabled = itemFlags[itemType]
    if enabled == nil then
        return false -- Unknown items default to enabled
    end
    
    return not enabled -- Return true if disabled
end

-- Add items to procedural distributions
local function addItemsToDistributions()
    -- Access the vanilla Distributions table directly from global namespace
    local proceduralDist = ProceduralDistributions
    
    if not proceduralDist or not proceduralDist.list then
        Utils.debugPrint("Error: ProceduralDistributions not found")
        return
    end
    
    local totalAdded = 0
    local totalSkipped = 0
    
    -- Add weapons to tool/carpentry locations
    local added, skipped = ItemDistributions.addItemsToLocationGroup(
        ItemDistributions.weapons,
        ItemDistributions.weaponLocations,
        "Weapons",
        isItemDisabled,
        proceduralDist
    )
    totalAdded = totalAdded + added
    totalSkipped = totalSkipped + skipped
    
    -- Add martial arts weapons to sports locations
    added, skipped = ItemDistributions.addItemsToLocationGroup(
        ItemDistributions.martialArts,
        ItemDistributions.martialArtsLocations,
        "Martial Arts",
        isItemDisabled,
        proceduralDist
    )
    totalAdded = totalAdded + added
    totalSkipped = totalSkipped + skipped
    
    -- Add literature to book/library locations
    added, skipped = ItemDistributions.addItemsToLocationGroup(
        ItemDistributions.literature,
        ItemDistributions.literatureLocations,
        "Literature",
        isItemDisabled,
        proceduralDist
    )
    totalAdded = totalAdded + added
    totalSkipped = totalSkipped + skipped
    
    Utils.debugPrint("Added " .. totalAdded .. " item spawn(s), skipped " .. totalSkipped .. " disabled item(s)")
end

-- Setup distributions when they're loaded
Events.OnDistributionMerge.Add(addItemsToDistributions)

-- Initialize on server start
Events.OnServerStarted.Add(function()
    Utils.debugPrint("Server started")
    local options = getOptions()
    Utils.debugPrint("Wooden Sword Spawns: " .. tostring(options.EnableWoodenSword))
    Utils.debugPrint("Bokuto Spawns: " .. tostring(options.EnableBokuto))
    Utils.debugPrint("Crafting Manual Spawns: " .. tostring(options.EnableCraftingManual))
end)

Utils.debugPrint("Server module loaded successfully")