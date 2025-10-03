-- Perfection's Items - Loot Distribution Data (Build 41)
-- Distribution tables for procedural loot spawning
-- Reference: https://pzwiki.net/w/index.php?oldid=405935

-- Namespace: PI.Distributions
local PI = PI or {}
PI.Distributions = PI.Distributions or {}

-- ============================================================================
-- SANDBOX OPTION MULTIPLIER REFERENCE TABLE
-- ============================================================================
-- How sandbox settings affect spawn rates (examples based on chance = 1.0):
--
-- Disabled (0%):   chance × 0.0  = 0.0    → Never spawns
-- Very Rare (10%): chance × 0.1  = 0.1    → ~1 in 1000 containers
-- Rare (50%):      chance × 0.5  = 0.5    → ~1 in 200 containers
-- Common (100%):   chance × 1.0  = 1.0    → ~1 in 100 containers
--
-- For Manuals (spawn at half rate):
-- Disabled (0%):   chance × 0.0  = 0.0    → Never spawns
-- Very Rare (10%): chance × 0.05 = 0.05   → ~1 in 2000 containers
-- Rare (50%):      chance × 0.25 = 0.25   → ~1 in 400 containers
-- Common (100%):   chance × 0.5  = 0.5    → ~1 in 200 containers
--
-- Quick conversion formula: 1 ÷ (base_chance × multiplier) × 100 = containers needed
-- Example: 1.0 base at Very Rare (10%) = 1 ÷ (1.0 × 0.1) × 100 = 1000 containers
-- ============================================================================

-- Distribution data structure
-- Each entry defines: container type, item to add, and base spawn chance
-- Actual spawn chance = base_chance × multiplier_from_sandbox_options
--
-- Probability comments show spawn rate at 100% (Common) sandbox setting
-- For other settings, multiply the "1 in X" value accordingly:
--   Very Rare (10%) = 10× rarer, Rare (50%) = 2× rarer
PI.Distributions.data = {
    -- Wooden Sword distributions (basic crafted weapon)
    WoodenSword = {
        -- Weapon-related containers
        {container = "CrateCarpentry", item = "PerfectionsItems.WoodenSword", chance = 1.0},        -- ~1 in 1000 (Very Rare)
        {container = "CrateTools", item = "PerfectionsItems.WoodenSword", chance = 0.8},            -- ~1 in 1250 (Very Rare)
        {container = "ToolStoreTools", item = "PerfectionsItems.WoodenSword", chance = 0.5},        -- ~1 in 2000 (Very Rare)
        {container = "ToolStoreCarpentry", item = "PerfectionsItems.WoodenSword", chance = 0.8},    -- ~1 in 1250 (Very Rare)
        
        -- Storage areas
        {container = "GarageTools", item = "PerfectionsItems.WoodenSword", chance = 0.5},           -- ~1 in 2000 (Very Rare)
        {container = "ShedTools", item = "PerfectionsItems.WoodenSword", chance = 0.6},             -- ~1 in 1667 (Very Rare)
        {container = "StorageUnitTools", item = "PerfectionsItems.WoodenSword", chance = 0.4},      -- ~1 in 2500 (Very Rare)
        
        -- Residential
        {container = "BedroomDresser", item = "PerfectionsItems.WoodenSword", chance = 0.3},        -- ~1 in 3333 (Very Rare)
        {container = "ClosetShelfGeneric", item = "PerfectionsItems.WoodenSword", chance = 0.2},    -- ~1 in 5000 (Very Rare)
    },
    
    -- Bokuto distributions (higher quality, rarer)
    Bokuto = {
        -- Weapon-related containers (less common than wooden sword)
        {container = "CrateCarpentry", item = "PerfectionsItems.Bokuto", chance = 0.6},             -- ~1 in 1667 (Very Rare)
        {container = "CrateTools", item = "PerfectionsItems.Bokuto", chance = 0.5},                 -- ~1 in 2000 (Very Rare)
        {container = "ToolStoreTools", item = "PerfectionsItems.Bokuto", chance = 0.3},             -- ~1 in 3333 (Very Rare)
        {container = "ToolStoreCarpentry", item = "PerfectionsItems.Bokuto", chance = 0.5},         -- ~1 in 2000 (Very Rare)
        
        -- Storage areas
        {container = "GarageTools", item = "PerfectionsItems.Bokuto", chance = 0.3},                -- ~1 in 3333 (Very Rare)
        {container = "ShedTools", item = "PerfectionsItems.Bokuto", chance = 0.4},                  -- ~1 in 2500 (Very Rare)
        {container = "StorageUnitTools", item = "PerfectionsItems.Bokuto", chance = 0.2},           -- ~1 in 5000 (Very Rare)
        
        -- Residential (rare finds)
        {container = "BedroomDresser", item = "PerfectionsItems.Bokuto", chance = 0.2},             -- ~1 in 5000 (Very Rare)
        {container = "ClosetShelfGeneric", item = "PerfectionsItems.Bokuto", chance = 0.1},         -- ~1 in 10000 (Very Rare)
    },
    
    -- Manual distributions (crafting recipe book)
    Manual = {
        -- Literature/bookstore containers
        {container = "BookstoreBooks", item = "PerfectionsItems.BokutoMagazine", chance = 0.8},     -- ~1 in 2500 (Very Rare)
        {container = "LibraryBooks", item = "PerfectionsItems.BokutoMagazine", chance = 0.6},       -- ~1 in 3333 (Very Rare)
        {container = "CrateMagazines", item = "PerfectionsItems.BokutoMagazine", chance = 1.0},     -- ~1 in 2000 (Very Rare)
        
        -- Crafting-related containers
        {container = "CrateCarpentry", item = "PerfectionsItems.BokutoMagazine", chance = 0.8},     -- ~1 in 2500 (Very Rare)
        {container = "ToolStoreCarpentry", item = "PerfectionsItems.BokutoMagazine", chance = 0.6}, -- ~1 in 3333 (Very Rare)
        
        -- Residential literature spots
        {container = "ShelfGeneric", item = "PerfectionsItems.BokutoMagazine", chance = 0.4},       -- ~1 in 5000 (Very Rare)
        {container = "DeskGeneric", item = "PerfectionsItems.BokutoMagazine", chance = 0.3},        -- ~1 in 6667 (Very Rare)
        {container = "BedroomSideTable", item = "PerfectionsItems.BokutoMagazine", chance = 0.2},   -- ~1 in 10000 (Very Rare)
        
        -- Post office/mailboxes (less common)
        {container = "PostOfficeBoxes", item = "PerfectionsItems.BokutoMagazine", chance = 0.3},    -- ~1 in 6667 (Very Rare)
        {container = "MailboxGeneric", item = "PerfectionsItems.BokutoMagazine", chance = 0.2},     -- ~1 in 10000 (Very Rare)
    },
}

PI.Utils.debugPrint("Distribution data loaded")

return PI.Distributions
