# Project Zomboid Mod - Perfection's Items

A craftable wooden weapons mod demonstrating Build 41 modding patterns with community API integration.

## Architecture Overview

**Critical distinction**: `Contents/mods/PerfectionsItems/` is uploaded to Workshop; `assets/` contains dev-only files.

**Lua Version**: Project Zomboid uses **Lua 5.1** (via Kahlua/LuaJ). Modern Lua 5.2+ features like `goto`/labels, `continue`, bitwise operators, and `\z` escape sequences are **not available**. Use traditional control flow patterns (if-else, break, return).

```
Contents/mods/PerfectionsItems/
├── mod.info                    # Dependencies: require=modoptions
├── media/lua/{client,server,shared}/  # Client-side UI, server-side spawning, shared utils
└── media/scripts/              # Item stats, recipes, spawn distributions
```

**Reference**: [PZ Modding Wiki](https://pzwiki.net/wiki/Modding) | [Mod Structure](https://pzwiki.net/wiki/Mod_structure)

## Non-Obvious Patterns

### Cross-Environment Lua Communication
**Pattern**: Client-side ModOptions sets global, server reads with fallback (non-standard but functional).
```lua
-- client/Options.lua sets global (unusual pattern)
PerfectionsItems.OPTIONS = OPTIONS  

-- server/Server.lua reads it
local function getOptions()
    if PerfectionsItems and PerfectionsItems.OPTIONS then
        return PerfectionsItems.OPTIONS
    end
    return {EnableWoodenSword = true, ...}  -- Fallback defaults
end
```
**Why this works**: In single-player/host contexts, client and server share Lua state. ModOptions is client-only (UI framework), so client must set the global. **Limitation**: Requires fallback for dedicated servers where client state may not be accessible. Standard PZ pattern would use server-side configuration, but ModOptions necessitates this approach.

### Lua 5.1 Compatibility Patterns
**Critical**: PZ uses Lua 5.1 (Kahlua). Avoid modern syntax:
```lua
-- ❌ WRONG (Lua 5.2+)
for i = 1, 10 do
    if shouldSkip then
        goto continue  -- Not supported!
    end
    ::continue::
end

-- ✅ CORRECT (Lua 5.1)
for i = 1, 10 do
    if not shouldSkip then
        -- Process item
    else
        -- Skip item
    end
end
```
**Lua 5.1 limitations**: No `goto`, no `continue`, no bitwise operators (`&`, `|`), no `\z` escape. Use `if-else`, `break`, `return`, and traditional control flow.

### Item Stat Derivation Strategy
Copy vanilla item stats entirely, then modify specific values. Example: `WoodenSword` copies `Base.Bat` stats verbatim, `Bokuto` multiplies damage/durability by 1.1x. This ensures balanced gameplay and reduces testing burden.

**Asset Status (TODO)**: Currently reuses vanilla assets (`Icon = Bat`, `WeaponSprite = Bat`, `HitSound = BatHit`). Custom assets are planned:
- `media/textures/Item_*.png` - Custom inventory icons (256x256 recommended)
- `media/models/` - Custom 3D weapon models (.x or .fbx format)
- `media/sound/*.ogg` - Custom hit/swing sounds (Vorbis OGG format)

When adding custom assets, update item definitions:
```plaintext
Icon = WoodenSword,              # References media/textures/Item_WoodenSword.png
WeaponSprite = WoodenSword,      # References media/models/WoodenSword.x
HitSound = WoodenSwordHit,       # References media/sound/WoodenSwordHit.ogg
```

**Reference**: [Item Scripts](https://pzwiki.net/wiki/Item_(scripts)) | [Creating Custom Models](https://pzwiki.net/wiki/Creating_a_clothing_mod) | [Sound Scripts](https://pzwiki.net/wiki/Sound_(scripts))

### Distribution Management (Build 41)
Distributions are defined **entirely in Lua** using a rarity-based system for scalability. Items are separated into data (Distributions.lua) and logic (Server.lua), with early-out checks for disabled items:

```lua
-- Rarity system in server/Distributions.lua
ItemDistributions.Rarity = {
    COMMON = 1.0,       -- 1%
    UNCOMMON = 0.5,     -- 0.5%
    RARE = 0.1,         -- 0.1%
    VERY_RARE = 0.05,   -- 0.05%
    EXOTIC = 0.01,      -- 0.01%
    LEGENDARY = 0.001,  -- 0.001%
}

-- Data definitions
ItemDistributions.weapons = {
    {item = "PerfectionsItems.WoodenSword", chance = ItemDistributions.Rarity.VERY_RARE},
}
ItemDistributions.weaponLocations = {"ToolStoreMetalwork", "GarageCarpentry"}

-- Logic in Server.lua
local added, skipped = ItemDistributions.addItemsToLocationGroup(
    ItemDistributions.weapons,
    ItemDistributions.weaponLocations,
    "Weapons",
    isItemDisabled,
    proceduralDist
)
```

**Architecture benefits**:
- Rarity tiers provide self-documenting, consistent spawn rates
- Separation of data (Distributions.lua) from logic (Server.lua) aids maintainability
- Early-out pattern prevents work for disabled items
- Scales to 100+ items without container bloat (PZ Wiki recommended pattern)

**Reference**: [Procedural Distributions](https://pzwiki.net/wiki/Procedural_distributions) | [Lua Events](https://pzwiki.net/wiki/Lua_event)

### ModOptions Integration
**Key insight**: ModOptions is optional infrastructure. Check existence before use:
```lua
if ModOptions and ModOptions.getInstance then
    local settings = ModOptions:getInstance(OPTIONS, "PerfectionsItems", "Perfection's Items")
    -- Configure settings
else
    -- Mod still works with defaults
end
```

**Reference**: [ModOptions Framework](https://steamcommunity.com/sharedfiles/filedetails/?id=2169435993)

## Development Workflow

**Testing cycle**: Edit `Contents/mods/` → Test in-game with both dependencies → Update `CHANGELOG.md` and `mod.info` version.

**Critical**: Never edit `assets/` files assuming they affect gameplay - they're dev documentation only.

## Project Conventions

- **Naming**: `[PI]` display prefix, `PerfectionsItems.ItemName` internal IDs
- **Logging**: `Utils.debugPrint()` outputs `[PI] Message` for grep-friendly debugging
- **Rarity system**: Use `ItemDistributions.Rarity.*` constants (COMMON to LEGENDARY) for consistent spawn rates
- **Code organization**: Data in `server/Distributions.lua`, logic in `server/Server.lua`, utilities in `shared/Utils.lua`
- **Event load order**: Utils → Options (client) → Distributions (data) → Server (logic)

## Key Files

- `mod.info`: Dependencies declared as `require=modoptions` (semicolon-separated for multiple)
- `items.txt`: Module-scoped item definitions (`module PerfectionsItems { item WoodenSword { ... } }`)
- `recipes.txt`: Uses `keep` keyword for non-consumed tools, numeric time in game minutes
- `server/Distributions.lua`: All item spawn data, rarity constants, and `addItemsToLocationGroup()` helper
- `server/Server.lua`: ModOptions integration, distribution orchestration, event registration

**Reference**: [mod.info](https://pzwiki.net/wiki/Mod.info) | [Recipe Scripts](https://pzwiki.net/wiki/Recipe_(scripts))

## Common Pitfalls

1. **Lua 5.1 only**: No `goto`, `continue`, bitwise operators, or Lua 5.2+ features. Use traditional control flow (if-else, break, return)
2. **Dependency assumptions**: Always test mod with ModOptions disabled - fallback paths must work
3. **Event timing**: `OnGameStart` fires client-side, `OnServerStarted` fires server-side, `OnDistributionMerge` fires when distributions load - don't mix contexts
4. **Workshop uploads**: Upload only `Contents/` folder contents, not the folder itself
5. **Script syntax**: Lua uses `require()`, but `.txt` scripts use PZ's custom parser - don't confuse them
6. **Distribution manipulation**: Must happen in `OnDistributionMerge` event, not `OnServerStarted`
7. **Global namespace**: Use `PerfectionsItems.Utils` instead of `require()` for shared utilities - more reliable in PZ's Lua environment

## External Resources

- [PZ Modding Wiki](https://pzwiki.net/wiki/Modding) - Official documentation
- [Lua Events](https://pzwiki.net/wiki/Lua_event) - Complete event list
- [Item Properties](https://pzwiki.net/wiki/Item_(scripts)) - Full item property reference
- [Community Discord](https://discord.gg/theindiestone) - Workshop support channel