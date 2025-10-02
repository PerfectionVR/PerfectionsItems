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
local RARITY_MULTIPLIERS = {
    [1] = 0.0,   -- Off
    [2] = 0.1,   -- Extremely Rare (DEFAULT)
    [3] = 0.5,   -- Rare
    [4] = 1.0,   -- Common
}

-- Manual spawn rates (even rarer than items since it's the key to recipes)
local MANUAL_MULTIPLIERS = {
    [1] = 0.0,    -- Off
    [2] = 0.05,   -- Extremely Rare (half the item rate, DEFAULT)
    [3] = 0.25,   -- Rare (half the item rate)
    [4] = 0.5,    -- Common (half the item rate)
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

-- Make the namespace globally accessible
_G.PI = PI

return PI.Utils