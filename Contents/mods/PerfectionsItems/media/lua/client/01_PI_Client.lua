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
    
    -- Log spawn multipliers and rough probability estimates for debugging
    local woodenMultiplier = PI.Utils.getSpawnMultiplier("WoodenSword")
    local bokutoMultiplier = PI.Utils.getSpawnMultiplier("Bokuto")
    local manualMultiplier = PI.Utils.getSpawnMultiplier("Manual")
    
    PI.Utils.debugPrint("Loot spawn estimates (best-case containers):")
    
    -- WoodenSword estimates (best container: CrateCarpentry at 1.0 base)
    local woodenBest = woodenMultiplier > 0 and math.floor(1 / (1.0 * woodenMultiplier) * 100) or 0
    PI.Utils.debugPrint("  WoodenSword: " .. tostring(woodenMultiplier) .. "x" .. 
        (woodenMultiplier > 0 and " (~1 in " .. woodenBest .. " carpentry crates)" or " (never spawns)"))
    
    -- Bokuto estimates (best container: CrateCarpentry at 0.7 base)
    local bokutoBest = bokutoMultiplier > 0 and math.floor(1 / (0.7 * bokutoMultiplier) * 100) or 0
    PI.Utils.debugPrint("  Bokuto: " .. tostring(bokutoMultiplier) .. "x" ..
        (bokutoMultiplier > 0 and " (~1 in " .. bokutoBest .. " carpentry crates)" or " (never spawns)"))
    
    -- Manual estimates (best container: CrateMagazines at 1.0 base, but half multiplier)
    local manualBest = manualMultiplier > 0 and math.floor(1 / (1.0 * manualMultiplier) * 100) or 0
    PI.Utils.debugPrint("  Manual: " .. tostring(manualMultiplier) .. "x" ..
        (manualMultiplier > 0 and " (~1 in " .. manualBest .. " magazine crates)" or " (never spawns)"))
end

-- ============================================================================
-- EVENT REGISTRATION
-- ============================================================================

-- Register OnGameStart event: Log sandbox settings when player loads into world
Events.OnGameStart.Add(logSandboxSettings)

PI.Utils.debugPrint("Client initialization module loaded")
