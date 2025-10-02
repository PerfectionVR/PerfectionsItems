# Project Zomboid Mod - Perfection's Items

A craftable wooden weapons mod demonstrating Build 41 modding patterns with community API integration.

## Architecture Overview

**Lua Version**: Project Zomboid uses **Lua 5.1** (via Kahlua/LuaJ). Modern Lua 5.2+ features like `goto`/labels, `continue`, bitwise operators, and `\z` escape sequences are **not available**. Use traditional control flow patterns (if-else, break, return).

```
Contents/mods/PerfectionsItems/
├── mod.info                    # Dependencies: require=modoptions
├── media/
│   ├── lua/
│   │   ├── shared/
│   │   │   └── 01_PI_Utils.lua          # Loaded first (shared context)
│   │   ├── client/
│   │   │   ├── 01_PI_Client.lua         # Client initialization
│   │   │   └── 02_PI_Options.lua        # ModOptions UI
│   │   └── server/
│   │       ├── 01_PI_Distributions.lua  # Spawn data
│   │       └── 02_PI_Server.lua         # Spawn logic
│   └── scripts/
│       ├── PI_items.txt                 # Item definitions (PI_ prefix avoids conflicts)
│       └── PI_recipes.txt               # Recipe definitions (PI_ prefix avoids conflicts)
```

**Reference**: [PZ Modding Wiki](https://pzwiki.net/wiki/Modding) | [Mod Structure](https://pzwiki.net/wiki/Mod_structure)

### File Naming Conventions (CRITICAL)

**Script file conflicts**: Generic filenames like `items.txt` or `recipes.txt` **WILL OVERRIDE vanilla game files**, causing vanilla items to disappear. This happens because PZ loads script files by name, and your mod's `items.txt` replaces the vanilla `items.txt`.

**Real-world bug**: Using `items.txt` caused vanilla items like nails to disappear from the game because the file completely replaced vanilla item definitions.

❌ **WRONG**: `items.txt`, `recipes.txt` (OVERRIDES vanilla Base module files - breaks vanilla items!)  
✅ **CORRECT**: `PIitems.txt`, `PIrecipes.txt` (unique filename prevents conflicts)

**Lesson learned**: Always prefix script filenames with your mod identifier to prevent overriding vanilla/other mods' script files.

**Lua execution order**: Files load in this sequence:
1. `shared/` folder (all files alphabetically)
2. `client/` folder (all files alphabetically) - client-side only
3. `server/` folder (all files alphabetically) - server-side only

**Best practice**: Prefix Lua files with numbers to control load order:
- `01_PI_Utils.lua` - Shared utilities (loads first in shared/)
- `01_PI_Client.lua` - Client initialization (loads first in client/)
- `02_PI_Options.lua` - Depends on client context (loads second)
- `01_PI_Distributions.lua` - Spawn data (loads first in server/)
- `02_PI_Server.lua` - Spawn logic, depends on distributions (loads second)

**Why this matters**: Prevents undefined reference errors and ensures dependencies load before dependents.

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

### Script Module Imports

**Best practice**: Don't use `imports { Base }` - instead use explicit `Base.` prefixes for clarity and to avoid potential namespace issues.

❌ **AVOID** (less explicit):
```plaintext
module PerfectionsItems
{
    imports
    {
        Base
    }
    
    recipe Make Wooden Sword
    {
        Plank=2,              # Ambiguous - which module?
        Hammer=1,             # Ambiguous - which module?
        ...
    }
}
```

✅ **RECOMMENDED** (explicit and clear):
```plaintext
module PerfectionsItems
{
    recipe Make Wooden Sword
    {
        Base.Plank=2,         # Clear - from Base module
        keep Base.Hammer,     # Clear - from Base module
        Result:PerfectionsItems.WoodenSword,  # Clear - your module
        ...
    }
}
```

**Why explicit prefixes are better**: Makes it immediately clear which module each item comes from, prevents ambiguity, and follows PZwiki's recommended best practices.

### Item Property Data Types (CRITICAL)

**CRITICAL**: Item script properties have **strict type requirements**. Using wrong types causes `InvalidParameterException` errors.

**Integer-only properties** (must be whole numbers, NO decimals):
- `ConditionMax` - Item durability (e.g., `15`, NOT `16.5`)
- `MaxHitCount` - Max zombies hit per swing (e.g., `2`, NOT `2.5`)

**Real-world bug**: `ConditionMax = 16.5` caused error:
```
java.security.InvalidParameterException: Error: ConditionMax = 16.5 is not a valid parameter in item: Bokuto
```

**Solution**: Round to nearest integer: `ConditionMax = 17`

**Reference**: [Item Properties (Build 41)](https://pzwiki.net/wiki/Item_(scripts)) - Check "All parameters" section for each property's data type requirements.

## Common Pitfalls

1. **Lua 5.1 only**: No `goto`, `continue`, bitwise operators, or Lua 5.2+ features. Use traditional control flow (if-else, break, return). **Reference**: [Lua (language) on PZwiki](https://pzwiki.net/wiki/Lua_(language)) - This page is Build 42, but Lua 5.1 syntax hasn't changed
2. **Integer property types (CRITICAL)**: Properties like `ConditionMax`, `MaxHitCount` require whole numbers - decimals cause `InvalidParameterException`. **Reference**: [Item Properties (Build 41)](https://pzwiki.net/wiki/Item_(scripts)) - Check each property's data type
3. **Dependency assumptions**: Always test mod with ModOptions disabled - fallback paths must work
4. **Event timing**: `OnGameStart` fires client-side, `OnServerStarted` fires server-side, `OnDistributionMerge` fires when distributions load - don't mix contexts. **Reference**: [Lua Events (Build 41 archived)](https://pzwiki.net/wiki/Special:PermanentLink/767129)
5. **Workshop uploads**: Upload only `Contents/` folder contents, not the folder itself. **Reference**: [Workshop.txt (Build 41)](https://pzwiki.net/wiki/Workshop.txt)
6. **Script syntax**: Lua uses `require()`, but `.txt` scripts use PZ's custom parser - don't confuse them. **Reference**: [Item Scripts (Build 41)](https://pzwiki.net/wiki/Item_(scripts)) vs [Lua API (Build 41)](https://pzwiki.net/wiki/Lua_(API))
7. **Distribution manipulation**: Must happen in `OnDistributionMerge` event, not `OnServerStarted`. **Reference**: [Procedural Distributions (Build 41 archived)](https://pzwiki.net/wiki/Special:PermanentLink/405935)
8. **Global namespace**: Use `PerfectionsItems.Utils` instead of `require()` for shared utilities - more reliable in PZ's Lua environment
9. **Script file naming (CRITICAL)**: Generic filenames like `items.txt` or `recipes.txt` will OVERRIDE vanilla game files and cause vanilla items to disappear. ALWAYS prefix with mod identifier (e.g., `PIitems.txt`, not `items.txt`). **Reference**: [Mod Structure (Build 41)](https://pzwiki.net/wiki/Mod_structure) - This page is Build 42, but Build 41 structure section exists
10. **Module imports**: Don't use `imports { Base }` - use explicit `Base.ItemName` prefixes for clarity. **Reference**: [Item Scripts - Module syntax (Build 41)](https://pzwiki.net/wiki/Item_(scripts)#Module)
11. **Lua file execution order**: Files load alphabetically per folder (shared → client → server). Prefix with numbers (e.g., `01_PI_Utils.lua`) to control load order. **Reference**: [Mod Structure (Build 41)](https://pzwiki.net/wiki/Mod_structure)
12. **Debug log analysis (CRITICAL)**: Always check `Zomboid/Logs/` for `InvalidParameterException` errors - they pinpoint exact script issues with line-level precision. Logs include item name, property name, and invalid value

## External Resources

**CRITICAL**: This mod targets **Build 41.78.16**. When browsing PZwiki, **ALWAYS use Build 41 archived links**:

### How to Identify Build 41 vs Build 42 Pages:
1. **Build 41 (CORRECT)**: Banner says "This page has been revised for the current stable version (41.78.16)"
2. **Build 42 (WRONG)**: Banner says "This page has been updated to an unstable beta version (42.x)"

### How to Get Build 41 Documentation from Build 42 Pages:
- **Look at the TOP of the page** for yellow/orange banner
- Banner will say: "For the Build 41 page, **please see this archived version**" (click the link)
- Archived Build 41 URLs use format: `https://pzwiki.net/w/index.php?oldid=XXXXXX`
- Example: Lua Events Build 41 archived link is `https://pzwiki.net/w/index.php?oldid=767129`

**NEVER use Build 42 features/APIs** - they are incompatible with Build 41.

Build 41 Documentation Links (use these directly):
- [PZ Modding Wiki](https://pzwiki.net/wiki/Modding) - Official documentation
- [Lua Events](https://pzwiki.net/wiki/Lua_event) - Complete event list
- [Item Properties](https://pzwiki.net/wiki/Item_(scripts)) - Full item property reference
- [Recipe Scripts](https://pzwiki.net/wiki/Recipe_(scripts)) - Recipe syntax reference
- [Procedural Distributions](https://pzwiki.net/wiki/Procedural_distributions) - Loot spawn system
- [Community Discord](https://discord.gg/theindiestone) - Workshop support channel