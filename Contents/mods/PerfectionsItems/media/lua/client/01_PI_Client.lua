-- Perfection's Items - Client Initialization (Build 41)
-- Handles client-side event registration and debug logging
-- Reference: https://pzwiki.net/wiki/Sandbox_options
-- Reference: https://pzwiki.net/w/index.php?oldid=767129 (Lua Events)
-- 
-- IMPORTANT: Sandbox Options are ADMIN/SERVER-CONTROLLED settings
-- - Set during world creation in "New Game → Sandbox Options"
-- - Cannot be changed by regular players during gameplay
-- - Require admin privileges or world recreation to modify
-- - This is NOT a client-side "Mod Options" menu
--
-- SANDBOX OPTIONS BEHAVIOR:
-- The sandbox options control:
-- 1. Loot spawns (server/01_PI_Distributions.lua handles this)
-- 2. Recipe availability in crafting menu (PIrecipes.txt handles this via skill requirements)
--
-- We do NOT enforce recipe removal because:
-- - Admins can manually grant recipes via commands/debug menu
-- - Players may have legitimately found manuals before settings changed
-- - Removing recipes would override admin decisions
-- - Respects player progression and admin control
--
-- If an admin wants to control recipes, they should:
-- - Set sandbox options before world creation
-- - Use admin commands to grant/remove recipes as needed
-- - Adjust manual spawn rates (multiplier 0.0 = no spawns)


-- Log sandbox settings when player loads into the game world
-- This is informational only - no recipe enforcement happens client-side
local function logSandboxSettings()
    local player = getPlayer()
    if not player then
        PI.Utils.debugPrint("ERROR: Player not found")
        return
    end
    
    -- Read server/admin-controlled sandbox settings
    local woodenEnabled = PI.Utils.isItemEnabled("WoodenSword")
    local bokutoEnabled = PI.Utils.isItemEnabled("Bokuto")
    local manualEnabled = PI.Utils.isItemEnabled("Manual")
    
    PI.Utils.debugPrint("Sandbox Options (admin-controlled):")
    PI.Utils.debugPrint("  WoodenSword loot/recipes: " .. (woodenEnabled and "ENABLED" or "DISABLED"))
    PI.Utils.debugPrint("  Bokuto loot/recipes: " .. (bokutoEnabled and "ENABLED" or "DISABLED"))
    PI.Utils.debugPrint("  Manual loot spawns: " .. (manualEnabled and "ENABLED" or "DISABLED"))
    
    -- Log spawn multipliers for debugging
    local woodenMultiplier = PI.Utils.getSpawnMultiplier("WoodenSword")
    local bokutoMultiplier = PI.Utils.getSpawnMultiplier("Bokuto")
    local manualMultiplier = PI.Utils.getSpawnMultiplier("Manual")
    
    PI.Utils.debugPrint("Loot spawn multipliers:")
    PI.Utils.debugPrint("  WoodenSword: " .. tostring(woodenMultiplier) .. "x")
    PI.Utils.debugPrint("  Bokuto: " .. tostring(bokutoMultiplier) .. "x")
    PI.Utils.debugPrint("  Manual: " .. tostring(manualMultiplier) .. "x")
    PI.Utils.debugPrint("  (multiplier 0.0 = no loot spawns)")
end

-- ============================================================================
-- EVENT REGISTRATION
-- ============================================================================

-- Register OnGameStart event: Log sandbox settings when player loads into world
Events.OnGameStart.Add(logSandboxSettings)

PI.Utils.debugPrint("Client initialization module loaded")
