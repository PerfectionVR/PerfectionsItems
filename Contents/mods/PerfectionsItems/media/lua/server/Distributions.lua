-- Perfection's Items - Loot Distribution Definitions
-- Defines where and how items spawn in the world
-- Organized by item type and location groups for scalability

local ItemDistributions = {}

-- Rarity tiers for consistent spawn chances across all items
ItemDistributions.Rarity = {
    COMMON = 1.0,       -- 1% - Easy to find
    UNCOMMON = 0.5,     -- 0.5% - Fairly common
    RARE = 0.1,         -- 0.1% - Requires searching
    VERY_RARE = 0.05,   -- 0.05% - Hard to find
    EXOTIC = 0.01,      -- 0.01% - Extremely rare
    LEGENDARY = 0.001,  -- 0.001% - Near mythical
}

-- Item distribution definitions grouped by location and type
-- Format: {item = "Module.ItemName", chance = Rarity.TIER}

-- Wooden weapons spawn in tool stores and carpentry areas
ItemDistributions.weapons = {
    {item = "PerfectionsItems.WoodenSword", chance = ItemDistributions.Rarity.VERY_RARE},
    {item = "PerfectionsItems.Bokuto", chance = ItemDistributions.Rarity.RARE},
}

ItemDistributions.weaponLocations = {
    "ToolStoreMetalwork",
    "CrateTools",
    "GarageCarpentry",
    "ShedCarpentry",
    "StorageCarpentry",
}

-- Bokuto also spawns in sports/martial arts locations (rarer)
ItemDistributions.martialArts = {
    {item = "PerfectionsItems.Bokuto", chance = ItemDistributions.Rarity.EXOTIC},
}

ItemDistributions.martialArtsLocations = {
    "SportStorageOutfit",
}

-- Crafting manuals spawn in bookstores and libraries (very rare - exotic item)
ItemDistributions.literature = {
    {item = "PerfectionsItems.BokutoMagazine", chance = ItemDistributions.Rarity.EXOTIC},
}

ItemDistributions.literatureLocations = {
    "BookstoreBooks",
    "LibraryBooks",
    "CrateBooks",
    "CrateMagazines",
    "PostOfficeBooks",
    "OfficeDesk",
    "ClassroomDesk",
}

-- Future expansion examples:
-- ItemDistributions.rare = {
--     {item = "PerfectionsItems.MasterSword", chance = ItemDistributions.Rarity.LEGENDARY},
-- }
-- 
-- ItemDistributions.rareLocations = {
--     "ArmySurplusOutfit",
--     "PoliceStorageOutfit",
-- }

-- Helper function to add items to specific location groups
-- Parameters:
--   items: Array of {item = "Module.ItemName", chance = Rarity.TIER}
--   locations: Array of ProceduralDistribution location names
--   groupName: String for debug logging
--   isItemDisabledFunc: Function that returns true if item should be skipped
--   proceduralDist: The ProceduralDistributions table from game
-- Returns: addedCount, skippedCount
function ItemDistributions.addItemsToLocationGroup(items, locations, groupName, isItemDisabledFunc, proceduralDist)
    local addedCount = 0
    local skippedCount = 0
    
    for _, itemData in ipairs(items) do
        -- Early out if item is disabled via ModOptions
        if isItemDisabledFunc(itemData.item) then
            skippedCount = skippedCount + 1
            goto continue
        end
        
        for _, location in ipairs(locations) do
            local distList = proceduralDist.list[location]
            if distList and distList.items then
                table.insert(distList.items, itemData.item)
                table.insert(distList.items, itemData.chance)
                addedCount = addedCount + 1
            end
        end
        
        ::continue::
    end
    
    return addedCount, skippedCount
end

return ItemDistributions
