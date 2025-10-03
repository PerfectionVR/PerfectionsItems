-- Perfection's Items - Shared Utilities
-- Common functions used across client and server

-- Global namespace: PI (short for Perfection's Items)
local PI = PI or {}
PI.Utils = PI.Utils or {}

-- Shared debug logging function
function PI.Utils.debugPrint(msg)
    print("[PI] " .. tostring(msg))
end

-- Rarity index to multiplier conversion table (for items)
-- UI shows percentages to admins, we handle the math internally
-- Index maps: 1=Disabled(0%), 2=Very Rare(10%), 3=Rare(50%), 4=Common(100%)
local RARITY_MULTIPLIERS = {
    [1] = 0.0,   -- Disabled (0% of base chance)
    [2] = 0.1,   -- Very Rare (10% of base chance) [DEFAULT]
    [3] = 0.5,   -- Rare (50% of base chance)
    [4] = 1.0,   -- Common (100% of base chance)
}

-- Manual spawn rates (half the item rate since manuals are teaching items)
local MANUAL_MULTIPLIERS = {
    [1] = 0.0,    -- Disabled (0%)
    [2] = 0.05,   -- Very Rare (5% of base chance) [DEFAULT]
    [3] = 0.25,   -- Rare (25% of base chance)
    [4] = 0.5,    -- Common (50% of base chance)
}

-- Get options from SandboxVars (server-configured, per-world settings)
-- Falls back to defaults if not in sandbox mode (e.g., main menu)
-- Available in both client and server contexts
function PI.Utils.getOptions()
    if SandboxVars and SandboxVars.PI then
        return {
            WoodenSwordRarity = SandboxVars.PI.WoodenSwordRarity or 2,
            BokutoRarity = SandboxVars.PI.BokutoRarity or 2,
            ManualRarity = SandboxVars.PI.ManualRarity or 2,
        }
    else
        -- Fallback defaults (when not in a game/world)
        return {
            WoodenSwordRarity = 2,  -- Extremely Rare
            BokutoRarity = 2,       -- Extremely Rare
            ManualRarity = 2,       -- Extremely Rare
        }
    end
end

-- Get spawn multiplier for a specific item type
-- Returns: actual multiplier value (items: 0.0-1.0, manual: 0.0-0.5)
function PI.Utils.getSpawnMultiplier(itemType)
    local options = PI.Utils.getOptions()
    local index = 0
    
    if itemType == "WoodenSword" then
        index = options.WoodenSwordRarity
        return RARITY_MULTIPLIERS[index] or 0.1
    elseif itemType == "Bokuto" then
        index = options.BokutoRarity
        return RARITY_MULTIPLIERS[index] or 0.1
    elseif itemType == "Manual" then
        index = options.ManualRarity
        return MANUAL_MULTIPLIERS[index] or 0.05  -- Even rarer default
    end
    return 0.1  -- Default to Extremely Rare
end

-- Check if item is enabled based on rarity
-- Returns: true if enabled (multiplier > 0), false if disabled (multiplier = 0)
function PI.Utils.isItemEnabled(itemType)
    local options = PI.Utils.getOptions()
    local index = 0
    
    if itemType == "WoodenSword" then
        index = options.WoodenSwordRarity
    elseif itemType == "Bokuto" then
        index = options.BokutoRarity
    elseif itemType == "Manual" then
        index = options.ManualRarity
    end
    
    -- Check appropriate multiplier table
    local multiplier = 0
    if itemType == "Manual" then
        multiplier = MANUAL_MULTIPLIERS[index] or 0
    else
        multiplier = RARITY_MULTIPLIERS[index] or 0
    end
    
    return multiplier > 0
end

-- Calculate spawn probability estimate for logging
-- Parameters:
--   baseChance: base spawn weight from distribution (e.g., 1.0, 0.7)
--   multiplier: spawn multiplier from sandbox settings (e.g., 0.1, 0.5)
-- Returns: estimated containers needed (e.g., 1000, 1429)
-- Formula: 1 ÷ (base_chance × multiplier) × 100 = containers needed
function PI.Utils.calculateSpawnEstimate(baseChance, multiplier)
    if multiplier <= 0 then
        return 0  -- Never spawns
    end
    return math.floor(1 / (baseChance * multiplier) * 100)
end

-- Make the namespace globally accessible
_G.PI = PI

return PI.Utils