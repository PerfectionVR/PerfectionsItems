-- Perfection's Items - Sandbox Options (Build 41)
-- Server-side configuration using Sandbox Options
-- Reference: https://pzwiki.net/wiki/Sandbox_options

-- All option logic is now in shared/01_PI_Utils.lua
-- This file just logs the options on game start

-- Log options on game start
Events.OnGameStart.Add(function()
    local options = PI.Utils.getOptions()
    local woodenMultiplier = PI.Utils.getSpawnMultiplier("WoodenSword")
    local bokutoMultiplier = PI.Utils.getSpawnMultiplier("Bokuto")
    local manualMultiplier = PI.Utils.getSpawnMultiplier("Manual")
    
    PI.Utils.debugPrint("Game started with Sandbox options:")
    PI.Utils.debugPrint("  WoodenSwordRarity: " .. tostring(options.WoodenSwordRarity) .. " = " .. tostring(woodenMultiplier) .. "x")
    PI.Utils.debugPrint("  BokutoRarity: " .. tostring(options.BokutoRarity) .. " = " .. tostring(bokutoMultiplier) .. "x")
    PI.Utils.debugPrint("  ManualRarity: " .. tostring(options.ManualRarity) .. " = " .. tostring(manualMultiplier) .. "x")
end)

PI.Utils.debugPrint("Sandbox Options module loaded")
