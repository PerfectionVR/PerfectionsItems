-- Perfection's Items - Server Distribution Logic (Build 41)
-- Merges custom items into procedural distributions
-- Reference: https://pzwiki.net/w/index.php?oldid=405935

-- Event: OnDistributionMerge
-- Description: Fires when the distribution tables merge (server-side)
-- Parameters: None
-- Reference: https://pzwiki.net/w/index.php?oldid=767129 (Build 41 Lua Events)
-- Note: OnPreDistributionMerge and OnPostDistributionMerge also exist, but OnDistributionMerge
--       is the standard/recommended event for adding items to distributions

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

-- Register distribution merge event
Events.OnDistributionMerge.Add(applyDistributions)

PI.Utils.debugPrint("Server distribution module loaded")
