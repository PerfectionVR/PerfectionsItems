-- Perfection's Items - Loot Distribution Data (Build 41)
-- Distribution tables for procedural loot spawning
-- Reference: https://pzwiki.net/w/index.php?oldid=405935

-- Namespace: PI.Distributions
local PI = PI or {}
PI.Distributions = PI.Distributions or {}

-- ============================================================================
-- SANDBOX OPTION MULTIPLIER REFERENCE
-- ============================================================================
-- How sandbox settings affect spawn rates (examples based on chance = 1.0):
--
-- Items (WoodenSword, Bokuto):
--   Disabled (0%):   chance × 0.0  = 0.0    → Never spawns
--   Very Rare (10%): chance × 0.1  = 0.1    → ~1 in 1000 containers
--   Rare (50%):      chance × 0.5  = 0.5    → ~1 in 200 containers
--   Common (100%):   chance × 1.0  = 1.0    → ~1 in 100 containers
--
-- Manuals (spawn at HALF rate):
--   Disabled (0%):   chance × 0.0  = 0.0    → Never spawns
--   Very Rare (10%): chance × 0.05 = 0.05   → ~1 in 2000 containers
--   Rare (50%):      chance × 0.25 = 0.25   → ~1 in 400 containers
--   Common (100%):   chance × 0.5  = 0.5    → ~1 in 200 containers
--
-- Formula: 1 ÷ (base_chance × multiplier) × 100 = containers needed
-- Example: 1.0 base at Very Rare (10%) = 1 ÷ (1.0 × 0.1) × 100 = 1000 containers
-- ============================================================================

-- ============================================================================
-- CONTAINER SELECTION STRATEGY
-- ============================================================================
-- All containers verified to exist in Build 41 (see ProceduralDistributions.lua)
-- Reference: https://pzwiki.net/w/index.php?oldid=405935
--
-- WOODEN SWORD (Basic Crafted Weapon - Woodwork 0-2)
--   Theme: Beginner woodworking project using common materials
--   PRIMARY (0.6-1.0):   CrateCarpentry, CrateTools, ToolStoreCarpentry, ToolStoreTools
--   SECONDARY (0.3-0.5): GarageCarpentry, GarageTools, MetalShopTools, LoggingFactoryTools
--   TERTIARY (0.1-0.2):  Residential storage (BedroomDresser, ClosetShelfGeneric, ShelfGeneric)
--   SPECIALIZED:         CrateRandomJunk (mixed finds)
--
-- BOKUTO (Advanced Crafted Weapon - Woodwork 8)
--   Theme: High-quality woodworking, martial arts practice weapon
--   PRIMARY (0.5-0.7):   CrateCarpentry, ToolStoreCarpentry, GarageCarpentry
--   SECONDARY (0.3-0.4): CrateTools, ToolStoreTools, GarageTools, MetalShopTools
--   TERTIARY (0.1-0.2):  LoggingFactoryTools, GymLockers (martial arts!), Residential
--   SPECIALIZED:         GymLockers (martial arts theme adds authenticity)
--
-- BOKUTO MANUAL (Crafting Recipe Book)
--   Theme: Instructional literature, woodworking reference material
--   PRIMARY (0.6-1.0):   CrateMagazines, BookstoreBooks, LibraryBooks, CrateBooks
--   SECONDARY (0.4-0.6): PostOfficeBoxes, CrateCarpentry, ToolStoreCarpentry, ToolStoreBooks
--   TERTIARY (0.2-0.4):  ShelfGeneric, DeskGeneric, LibraryCounter, OfficeShelfSupplies
--   SPECIALIZED (0.1-0.2): ClassroomDesk (shop class!), GymLockers (martial arts instruction!)
--
-- Spawn Weight Guidelines:
--   Perfect thematic fit:  0.8-1.0  (e.g., CrateCarpentry for wooden weapons)
--   Good thematic fit:     0.5-0.7  (e.g., ToolStoreTools for weapons)
--   Reasonable fit:        0.3-0.4  (e.g., GarageTools for weapons)
--   Rare/unexpected find:  0.1-0.2  (e.g., BedroomDresser for weapons)
--
-- All probability comments show spawn rate at Very Rare (10%) - the DEFAULT setting
-- ============================================================================
PI.Distributions.data = {
    -- Wooden Sword distributions (basic crafted weapon)
    -- See CONTAINER SELECTION STRATEGY section above for rationale
    WoodenSword = {
        -- PRIMARY: Carpentry/Tool containers (perfect thematic fit)
        {container = "CrateCarpentry", item = "PerfectionsItems.WoodenSword", chance = 1.0},        -- ~1 in 1000 (Very Rare)
        {container = "CrateTools", item = "PerfectionsItems.WoodenSword", chance = 0.8},            -- ~1 in 1250 (Very Rare)
        {container = "ToolStoreCarpentry", item = "PerfectionsItems.WoodenSword", chance = 0.8},    -- ~1 in 1250 (Very Rare)
        {container = "ToolStoreTools", item = "PerfectionsItems.WoodenSword", chance = 0.6},        -- ~1 in 1667 (Very Rare)
        
        -- SECONDARY: Garage/Workshop containers (good thematic fit)
        {container = "GarageCarpentry", item = "PerfectionsItems.WoodenSword", chance = 0.6},       -- ~1 in 1667 (Very Rare)
        {container = "GarageTools", item = "PerfectionsItems.WoodenSword", chance = 0.5},           -- ~1 in 2000 (Very Rare)
        {container = "MetalShopTools", item = "PerfectionsItems.WoodenSword", chance = 0.4},        -- ~1 in 2500 (Very Rare)
        {container = "LoggingFactoryTools", item = "PerfectionsItems.WoodenSword", chance = 0.4},   -- ~1 in 2500 (Very Rare)
        {container = "CrateRandomJunk", item = "PerfectionsItems.WoodenSword", chance = 0.3},       -- ~1 in 3333 (Very Rare)
        
        -- TERTIARY: Residential/Storage (rare finds)
        {container = "ClosetShelfGeneric", item = "PerfectionsItems.WoodenSword", chance = 0.2},    -- ~1 in 5000 (Very Rare)
        {container = "BedroomDresser", item = "PerfectionsItems.WoodenSword", chance = 0.2},        -- ~1 in 5000 (Very Rare)
        {container = "ShelfGeneric", item = "PerfectionsItems.WoodenSword", chance = 0.1},          -- ~1 in 10000 (Very Rare)
    },
    
    -- Bokuto distributions (higher quality, rarer)
    -- See CONTAINER SELECTION STRATEGY section above for rationale
    Bokuto = {
        -- PRIMARY: Carpentry specialty containers (quality projects)
        {container = "CrateCarpentry", item = "PerfectionsItems.Bokuto", chance = 0.7},             -- ~1 in 1429 (Very Rare)
        {container = "ToolStoreCarpentry", item = "PerfectionsItems.Bokuto", chance = 0.6},         -- ~1 in 1667 (Very Rare)
        {container = "GarageCarpentry", item = "PerfectionsItems.Bokuto", chance = 0.5},            -- ~1 in 2000 (Very Rare)
        
        -- SECONDARY: General tool/workshop containers (less common)
        {container = "CrateTools", item = "PerfectionsItems.Bokuto", chance = 0.4},                 -- ~1 in 2500 (Very Rare)
        {container = "ToolStoreTools", item = "PerfectionsItems.Bokuto", chance = 0.3},             -- ~1 in 3333 (Very Rare)
        {container = "GarageTools", item = "PerfectionsItems.Bokuto", chance = 0.3},                -- ~1 in 3333 (Very Rare)
        {container = "MetalShopTools", item = "PerfectionsItems.Bokuto", chance = 0.3},             -- ~1 in 3333 (Very Rare)
        
        -- TERTIARY: Specialized/Rare locations
        {container = "LoggingFactoryTools", item = "PerfectionsItems.Bokuto", chance = 0.2},        -- ~1 in 5000 (Very Rare)
        {container = "GymLockers", item = "PerfectionsItems.Bokuto", chance = 0.2},                 -- ~1 in 5000 (Very Rare, martial arts theme)
        {container = "BedroomDresser", item = "PerfectionsItems.Bokuto", chance = 0.2},             -- ~1 in 5000 (Very Rare)
        {container = "ClosetShelfGeneric", item = "PerfectionsItems.Bokuto", chance = 0.1},         -- ~1 in 10000 (Very Rare)
        {container = "ShelfGeneric", item = "PerfectionsItems.Bokuto", chance = 0.1},               -- ~1 in 10000 (Very Rare)
    },
    
    -- Manual distributions (crafting recipe book)
    -- See CONTAINER SELECTION STRATEGY section above for rationale
    -- Note: Manuals spawn at HALF rate (0.05 multiplier vs 0.1 for items)
    Manual = {
        -- PRIMARY: Literature/Bookstore containers (best thematic fit)
        {container = "CrateMagazines", item = "PerfectionsItems.BokutoMagazine", chance = 1.0},     -- ~1 in 2000 (Very Rare)
        {container = "BookstoreBooks", item = "PerfectionsItems.BokutoMagazine", chance = 0.8},     -- ~1 in 2500 (Very Rare)
        {container = "LibraryBooks", item = "PerfectionsItems.BokutoMagazine", chance = 0.7},       -- ~1 in 2857 (Very Rare)
        {container = "PostOfficeBoxes", item = "PerfectionsItems.BokutoMagazine", chance = 0.6},    -- ~1 in 3333 (Very Rare)
        {container = "CrateBooks", item = "PerfectionsItems.BokutoMagazine", chance = 0.8},         -- ~1 in 2500 (Very Rare)
        
        -- SECONDARY: Carpentry/Tool literature sections (reference material)
        {container = "CrateCarpentry", item = "PerfectionsItems.BokutoMagazine", chance = 0.6},     -- ~1 in 3333 (Very Rare)
        {container = "ToolStoreCarpentry", item = "PerfectionsItems.BokutoMagazine", chance = 0.5}, -- ~1 in 4000 (Very Rare)
        {container = "ToolStoreBooks", item = "PerfectionsItems.BokutoMagazine", chance = 0.6},     -- ~1 in 3333 (Very Rare)
        {container = "PostOfficeMagazines", item = "PerfectionsItems.BokutoMagazine", chance = 0.5}, -- ~1 in 4000 (Very Rare)
        
        -- TERTIARY: Home/Office literature (personal libraries)
        {container = "ShelfGeneric", item = "PerfectionsItems.BokutoMagazine", chance = 0.4},       -- ~1 in 5000 (Very Rare)
        {container = "DeskGeneric", item = "PerfectionsItems.BokutoMagazine", chance = 0.3},        -- ~1 in 6667 (Very Rare)
        {container = "BedroomSideTable", item = "PerfectionsItems.BokutoMagazine", chance = 0.2},   -- ~1 in 10000 (Very Rare)
        {container = "LibraryCounter", item = "PerfectionsItems.BokutoMagazine", chance = 0.3},     -- ~1 in 6667 (Very Rare)
        {container = "OfficeShelfSupplies", item = "PerfectionsItems.BokutoMagazine", chance = 0.2}, -- ~1 in 10000 (Very Rare)
        
        -- SPECIALIZED: Thematic locations (very rare)
        {container = "ClassroomDesk", item = "PerfectionsItems.BokutoMagazine", chance = 0.2},      -- ~1 in 10000 (Very Rare, shop class)
        {container = "GymLockers", item = "PerfectionsItems.BokutoMagazine", chance = 0.1},         -- ~1 in 20000 (Very Rare, martial arts)
    },
}

PI.Utils.debugPrint("Distribution data loaded")

return PI.Distributions
