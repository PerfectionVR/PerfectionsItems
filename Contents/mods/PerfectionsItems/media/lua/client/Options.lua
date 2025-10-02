-- Perfection's Items - Mod Options Configuration
-- Uses the Mod Options framework for a better user experience

-- Access shared utilities from global namespace (set by shared/Utils.lua)
local Utils = PerfectionsItems and PerfectionsItems.Utils

-- Default options - individual control for each item type
local OPTIONS = {
    EnableWoodenSword = true,
    EnableBokuto = true,
    EnableCraftingManual = true,
}

-- Make OPTIONS globally accessible for other files
if not PerfectionsItems then
    PerfectionsItems = {}
end
PerfectionsItems.OPTIONS = OPTIONS

-- Connect to Mod Options framework (if installed)
if ModOptions and ModOptions.getInstance then
    local settings = ModOptions:getInstance(OPTIONS, "PerfectionsItems", "Perfection's Items")
    
    -- Set up option names and tooltips
    settings.names = {
        EnableWoodenSword = "Enable [PI] Wooden Sword Spawns",
        EnableBokuto = "Enable [PI] Bokuto Spawns",
        EnableCraftingManual = "Enable [PI] Crafting Manual Spawns",
    }
    
    -- Get individual options for tooltips
    local opt1 = settings:getData("EnableWoodenSword")
    opt1.tooltip = "Allow [PI] Wooden Swords to spawn in tool stores and carpentry areas (extremely rare)"
    
    local opt2 = settings:getData("EnableBokuto")
    opt2.tooltip = "Allow [PI] Bokuto to spawn in tool stores and carpentry areas (extremely rare)"
    
    local opt3 = settings:getData("EnableCraftingManual")
    opt3.tooltip = "Allow [PI] Wooden Sword Crafting Manual to spawn in bookstores and libraries (very rare)"
    
    -- Load options immediately so they're available
    ModOptions:loadFile()
    
    Utils.debugPrint("Mod Options integration enabled")
else
    Utils.debugPrint("Mod Options not found - using default settings (all items enabled)")
end

-- Check options at game start
Events.OnGameStart.Add(function()
    Utils.debugPrint("Wooden Sword Spawns: " .. tostring(OPTIONS.EnableWoodenSword))
    Utils.debugPrint("Bokuto Spawns: " .. tostring(OPTIONS.EnableBokuto))
    Utils.debugPrint("Crafting Manual Spawns: " .. tostring(OPTIONS.EnableCraftingManual))
end)
