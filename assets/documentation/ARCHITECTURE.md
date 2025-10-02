# Architecture Quick Reference

## Code Review Status ✅

**Last Review**: October 2, 2025  
**Status**: All code verified correct, documentation updated

## Current Implementation

### Rarity System
```lua
COMMON = 1.0%      VERY_RARE = 0.05%
UNCOMMON = 0.5%    EXOTIC = 0.01%
RARE = 0.1%        LEGENDARY = 0.001%
```

### Current Item Rarities
- **Wooden Sword**: VERY_RARE (0.05%) in tool stores
- **Bokuto**: RARE (0.1%) in tool stores, EXOTIC (0.01%) in sports stores  
- **Crafting Manual**: EXOTIC (0.01%) in bookstores/libraries

### File Structure

```
Contents/mods/PerfectionsItems/media/lua/
├── client/
│   ├── Client.lua         # Client initialization
│   └── Options.lua        # ModOptions UI (sets global PerfectionsItems.OPTIONS)
├── server/
│   ├── Distributions.lua  # DATA: Rarity constants, item groups, helper function
│   └── Server.lua         # LOGIC: ModOptions reading, spawn orchestration, events
└── shared/
    └── Utils.lua          # Debug logging with [PI] prefix
```

## Key Design Patterns

### 1. Separation of Concerns
- **Distributions.lua**: "What spawns where and how often?" (data)
- **Server.lua**: "Should this item spawn?" (logic)

### 2. Rarity-Based Spawn System
```lua
-- Distributions.lua
ItemDistributions.weapons = {
    {item = "PerfectionsItems.WoodenSword", chance = ItemDistributions.Rarity.VERY_RARE},
}
```

### 3. Early-Out Pattern
```lua
-- Server.lua
if isItemDisabled(itemData.item) then
    skippedCount = skippedCount + 1
    goto continue
end
```

### 4. Grouped Location Spawning
```lua
-- Distributions.lua
ItemDistributions.weaponLocations = {
    "ToolStoreMetalwork",
    "GarageCarpentry",
    -- Add more locations without touching logic
}
```

## Data Flow

```
1. Client Start
   └─> Options.lua sets PerfectionsItems.OPTIONS global
   
2. Server Start
   └─> Server.lua getOptions() reads global (with fallback)
   
3. Distribution Merge Event
   └─> Server.lua calls addItemsToDistributions()
       ├─> For each item group (weapons, martialArts, literature)
       │   └─> Distributions.addItemsToLocationGroup()
       │       ├─> Check if item disabled (early out)
       │       └─> Insert into ProceduralDistributions
       └─> Log total added/skipped
```

## Scalability Features

✅ **Rarity tiers**: Self-documenting, globally adjustable  
✅ **Grouped items**: Add 10 swords by adding 10 lines to one array  
✅ **Grouped locations**: Add sword to 5 new locations with 5 array entries  
✅ **Early-out pattern**: Disabled items do zero work  
✅ **Separated files**: Distribution data doesn't clutter logic  
✅ **No container bloat**: PZ Wiki recommended pure Lua approach

## Testing Checklist

- [ ] Test with ModOptions enabled
- [ ] Test with ModOptions disabled (fallback paths)
- [ ] Test with individual items disabled
- [ ] Verify console logs show `[PI]` messages
- [ ] Check `OnDistributionMerge` fires correctly
- [ ] Verify items spawn at expected rarity

## Future Expansion Roadmap

### Phase 1: Current (v0.1.0)
- ✅ 3 items with vanilla assets
- ✅ Rarity system implemented
- ✅ Scalable architecture

### Phase 2: Asset Creation (v0.2.0)
- [ ] Custom textures (256x256 PNG)
- [ ] Custom 3D models (.x format)
- [ ] Custom sounds (Vorbis OGG)

### Phase 3: Content Expansion (v0.3.0 - v0.9.x)
- [ ] Add 10-20 items per update
- [ ] New weapon types (staffs, spears, shields)
- [ ] New item categories (armor, tools, decorations)

### Phase 4: Full Release (v1.0.0)
- [ ] 100+ items with complete custom assets
- [ ] Comprehensive testing
- [ ] Community feedback integration

## Performance Notes

- **Distribution complexity**: O(items × locations) per group
- **Current load**: 3 items × ~15 locations = ~45 insertions
- **Target load**: 100 items × ~20 locations = ~2000 insertions (acceptable)
- **Optimization**: Early-out pattern prevents disabled items from processing

## Common Modifications

### Change Item Rarity
```lua
-- In Distributions.lua
{item = "PerfectionsItems.WoodenSword", chance = ItemDistributions.Rarity.COMMON}
```

### Add New Location Group
```lua
-- In Distributions.lua
ItemDistributions.newGroup = {{item = "...", chance = ...}}
ItemDistributions.newLocations = {"Location1", "Location2"}

-- In Server.lua addItemsToDistributions()
added, skipped = ItemDistributions.addItemsToLocationGroup(
    ItemDistributions.newGroup,
    ItemDistributions.newLocations,
    "NewGroup",
    isItemDisabled,
    proceduralDist
)
```

### Adjust Global Rarity
```lua
-- In Distributions.lua
ItemDistributions.Rarity = {
    RARE = 0.2,  -- Changed from 0.1 (made 2x more common)
}
-- All items using Rarity.RARE automatically updated
```

## Dependencies

- **ModOptions**: Required for UI, fallback works without it
- **Build 41.78.16+**: Required for ProceduralDistributions API

## References

- [PZ Modding Wiki](https://pzwiki.net/wiki/Modding)
- [Procedural Distributions](https://pzwiki.net/wiki/Procedural_distributions)
- [Lua Events](https://pzwiki.net/wiki/Lua_event)
- [ModOptions Framework](https://steamcommunity.com/sharedfiles/filedetails/?id=2169435993)
