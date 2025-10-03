-- Perfection's Items - Server Distribution Logic (Build 41)
-- Merges custom items into procedural distributions
-- Reference: https://pzwiki.net/w/index.php?oldid=405935

-- Event: OnDistributionMerge
-- Description: Fires when the distribution tables merge (server-side)
-- Parameters: None
-- Reference: https://pzwiki.net/w/index.php?oldid=767129 (Build 41 Lua Events)
-- Note: OnPreDistributionMerge and OnPostDistributionMerge also exist, but OnDistributionMerge
--       is the standard/recommended event for adding items to distributions

-- ============================================================================
-- DISTRIBUTION MERGE LOGIC
-- ============================================================================

local function applyDistributions()
    PI.Utils.debugPrint("Starting distribution merge...")
    
    -- Check if ProceduralDistributions exists (it should in Build 41)
    if not ProceduralDistributions or not ProceduralDistributions.list then
        PI.Utils.debugPrint("ERROR: ProceduralDistributions.list not found!")
        return
    end
    
    local distributionList = ProceduralDistributions.list
    local addedCount = 0
    local skippedCount = 0
    
    -- Process each item type (WoodenSword, Bokuto, Manual)
    for itemType, distributions in pairs(PI.Distributions.data) do
        -- Check if this item type is enabled via sandbox options
        if not PI.Utils.isItemEnabled(itemType) then
            PI.Utils.debugPrint("  " .. itemType .. " is DISABLED (skipping all distributions)")
            skippedCount = skippedCount + #distributions
        else
            -- Get spawn multiplier for this item type
            local multiplier = PI.Utils.getSpawnMultiplier(itemType)
            PI.Utils.debugPrint("  Processing " .. itemType .. " (multiplier: " .. tostring(multiplier) .. "x)")
            
            -- Add each distribution entry using Build 41 API
            for _, dist in ipairs(distributions) do
                local containerName = dist.container
                local itemName = dist.item
                local baseChance = dist.chance
                local actualChance = baseChance * multiplier
                
                -- Find the container in ProceduralDistributions
                local container = distributionList[containerName]
                if container and container.items then
                    -- Build 41 API: Use table.insert() twice
                    -- First insert: item name (string)
                    -- Second insert: spawn weight (number, scaled by multiplier)
                    table.insert(container.items, itemName)
                    table.insert(container.items, actualChance)
                    addedCount = addedCount + 1
                    
                    -- Debug output (comment out for production)
                    -- PI.Utils.debugPrint("    Added " .. itemName .. " to " .. containerName .. " (" .. tostring(actualChance) .. ")")
                else
                    PI.Utils.debugPrint("    WARNING: Container '" .. containerName .. "' not found")
                    skippedCount = skippedCount + 1
                end
            end
        end
    end
    
    PI.Utils.debugPrint("Distribution merge complete: " .. tostring(addedCount) .. " added, " .. tostring(skippedCount) .. " skipped")
end

-- ============================================================================
-- SPAWN PROBABILITY LOGGING
-- ============================================================================

-- Helper function to find the best (highest chance) container for an item type
local function getBestContainer(itemType)
    local distributions = PI.Distributions.data[itemType]
    if not distributions or #distributions == 0 then
        return nil, 0, "unknown"
    end
    
    -- Find the distribution entry with the highest base chance
    local bestDist = distributions[1]
    for _, dist in ipairs(distributions) do
        if dist.chance > bestDist.chance then
            bestDist = dist
        end
    end
    
    return bestDist.chance, bestDist.container
end

-- Helper function to log individual item spawn estimate
local function logItemEstimate(itemType)
    local baseChance, containerName = getBestContainer(itemType)
    if not baseChance then
        PI.Utils.debugPrint("  " .. itemType .. ": No distributions defined")
        return
    end
    
    local multiplier = PI.Utils.getSpawnMultiplier(itemType)
    local estimate = PI.Utils.calculateSpawnEstimate(baseChance, multiplier)
    local estimateText = estimate > 0 and " (~1 in " .. estimate .. " " .. containerName .. ")" or " (never spawns)"
    PI.Utils.debugPrint("  " .. itemType .. ": " .. tostring(multiplier) .. "x" .. estimateText)
end

local function logSpawnEstimates()
    PI.Utils.debugPrint("Loot spawn estimates (best-case containers):")
    
    -- Log each item type (automatically uses their best container from distributions)
    logItemEstimate("WoodenSword")
    logItemEstimate("Bokuto")
    logItemEstimate("Manual")
end

-- ============================================================================
-- EVENT HANDLER
-- ============================================================================

-- Main handler for OnDistributionMerge event
-- Calls both distribution application and logging
local function onDistributionMerge()
    applyDistributions()
    logSpawnEstimates()
end

-- Register distribution merge event
Events.OnDistributionMerge.Add(onDistributionMerge)

PI.Utils.debugPrint("Server distribution module loaded")
