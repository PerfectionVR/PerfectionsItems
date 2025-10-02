# Project Zomboid Mod - Perfection's Items

A craftable wooden weapons mod demonstrating Build 41 modding patterns with community API integration.

## Architecture Overview

**Critical distinction**: `Contents/mods/PerfectionsItems/` is uploaded to Workshop; `assets/` contains dev-only files.

```
Contents/mods/PerfectionsItems/
├── mod.info                    # Dependencies: require=modoptions;EasyDistributionsAPI
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

### Distribution API Integration
`distributions.txt` defines spawn locations/rates, but `Easy Distributions API` allows **runtime removal** via `EasyDistAPI.removeFromAllDistributions(itemType)` in `server/Server.lua`. This enables user config without file modification.

**Reference**: [Easy Distributions API](https://steamcommunity.com/sharedfiles/filedetails/?id=3487312010) | [Procedural Distributions](https://pzwiki.net/wiki/Procedural_distributions)

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
- **Spawn rates**: 0.01-0.1% ("extremely rare") maintains balance while allowing discovery
- **Event load order**: Utils → Options (client) → Server spawn control

## Key Files

- `mod.info`: Dependencies declared as `require=modoptions;EasyDistributionsAPI` (semicolon-separated)
- `items.txt`: Module-scoped item definitions (`module PerfectionsItems { item WoodenSword { ... } }`)
- `recipes.txt`: Uses `keep` keyword for non-consumed tools, numeric time in game minutes
- `distributions.txt`: ProceduralDistributions format with location keys like `ToolStoreMetalwork`, `BookstoreBooks`

**Reference**: [mod.info](https://pzwiki.net/wiki/Mod.info) | [Recipe Scripts](https://pzwiki.net/wiki/Recipe_(scripts))

## Common Pitfalls

1. **Dependency assumptions**: Always test mod with ModOptions/EasyDistAPI disabled - fallback paths must work
2. **Event timing**: `OnGameStart` fires client-side, `OnServerStarted` fires server-side - don't mix contexts
3. **Workshop uploads**: Upload only `Contents/` folder contents, not the folder itself
4. **Script syntax**: Lua uses `require()`, but `.txt` scripts use PZ's custom parser - don't confuse them

## External Resources

- [PZ Modding Wiki](https://pzwiki.net/wiki/Modding) - Official documentation
- [Lua Events](https://pzwiki.net/wiki/Lua_event) - Complete event list
- [Item Properties](https://pzwiki.net/wiki/Item_(scripts)) - Full item property reference
- [Community Discord](https://discord.gg/theindiestone) - Workshop support channel