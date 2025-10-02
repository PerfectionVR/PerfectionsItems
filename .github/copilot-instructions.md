# Project Zomboid Mod - Perfection's Items

A craftable wooden weapons mod demonstrating Build 41 modding patterns with community API integration.

## Architecture Overview

**Lua Version**: Project Zomboid uses **Lua 5.1** (via Kahlua/LuaJ). Modern Lua 5.2+ features like `goto`/labels, `continue`, bitwise operators, and `\z` escape sequences are **not available**. Use traditional control flow patterns (if-else, break, return).

```
Contents/mods/PerfectionsItems/
├── mod.info                    # No external dependencies (Sandbox built-in)
├── media/
│   ├── sandbox-options.txt              # Sandbox Options definitions
│   ├── lua/
│   │   ├── shared/
│   │   │   ├── 01_PI_Utils.lua          # Loaded first (shared context)
│   │   │   └── Translate/EN/IG_UI_EN.txt # Sandbox option translations
│   │   ├── client/
│   │   │   ├── 01_PI_Client.lua         # Client initialization
│   │   │   └── 02_PI_Options.lua        # Reads SandboxVars
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

### Sandbox Options Integration (Build 41)

**Framework**: Sandbox Options is Project Zomboid's built-in configuration system for server mechanics. Options appear in **New Game → Sandbox Options** before world creation.

**Build 41 Documentation**: [Sandbox Options (PZwiki)](https://pzwiki.net/wiki/Sandbox_options)

**Implementation Pattern**:

**1. Define Options** (`media/sandbox-options.txt`):
```plaintext
VERSION = 1,

option PI.WoodenSwordRarity
{
    type = enum,
    numValues = 4,
    valueNames = {
        Off,
        ExtremelyRare,
        Rare,
        Common,
    },
    default = 2,
    page = PI,
    translation = PI_WoodenSwordRarity,
}
```

**2. Read Options** (`shared/01_PI_Utils.lua`):
```lua
-- Map dropdown indices to spawn multipliers
local RARITY_MULTIPLIERS = {
    [1] = 0.0,  -- Off
    [2] = 0.1,  -- Extremely Rare (DEFAULT)
    [3] = 0.5,  -- Rare
    [4] = 1.0,  -- Common
}

-- Read from SandboxVars (available in both client and server contexts)
function PI.Utils.getOptions()
    if SandboxVars and SandboxVars.PI then
        return {
            WoodenSwordRarity = SandboxVars.PI.WoodenSwordRarity or 2,
        }
    else
        return { WoodenSwordRarity = 2 }  -- Fallback
    end
end

-- Helper to get actual multiplier from index
function PI.Utils.getSpawnMultiplier(itemType)
    local options = PI.Utils.getOptions()
    local index = options[itemType .. "Rarity"]
    return RARITY_MULTIPLIERS[index] or 0.1
end
```

**3. Translation File** (`shared/Translate/EN/IG_UI_EN.txt`):
```lua
IGUI_EN = {
    -- Page name
    Sandbox_PI = "Perfection's Items",
    
    -- Option names
    Sandbox_PI_WoodenSwordRarity = "Wooden Sword Set",
    
    -- Tooltips
    Sandbox_PI_WoodenSwordRarity_tooltip = "Controls item and recipe availability.",
    
    -- Dropdown values
    Sandbox_PI_option_Off = "Off",
    Sandbox_PI_option_ExtremelyRare = "Extremely Rare",
    Sandbox_PI_option_Rare = "Rare",
    Sandbox_PI_option_Common = "Common",
}
```

**Key Points**:
1. **Built-in framework**: No external dependencies, always available
2. **Server-side**: Perfect for loot distributions and gameplay mechanics
3. **Per-world settings**: Each save has its own configuration
4. **Appears before world creation**: Configurable in New Game → Sandbox Options
5. **Multiplayer friendly**: Works on dedicated servers, visible to all players

**Why this is better for loot mods**: Loot distributions are server-side mechanics that affect all players. Sandbox Options are the standard PZ way to configure server mechanics.

### Cross-Environment Lua Communication
**Pattern**: SandboxVars accessible in shared utilities, works in both client and server contexts.
```lua
-- shared/01_PI_Utils.lua (available everywhere)
function PI.Utils.getOptions()
    if SandboxVars and SandboxVars.PerfectionsItems then
        return {
            WoodenSwordRarity = SandboxVars.PerfectionsItems.WoodenSwordRarity or 2,
        }
    end
    return { WoodenSwordRarity = 2 }  -- Fallback defaults
end

-- client/SomeFile.lua
local options = PI.Utils.getOptions()  -- Works!

-- server/SomeFile.lua  
local options = PI.Utils.getOptions()  -- Works!
```
**Why this works**: SandboxVars is a global table available in both client and server contexts. Values are synchronized automatically by the game. Placing the logic in `shared/` makes it accessible everywhere.

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
3. **Sandbox Options**: Always provide fallback defaults for when SandboxVars is not available (e.g., main menu). **Reference**: [Sandbox Options (Build 41)](https://pzwiki.net/wiki/Sandbox_options)
4. **Event timing**: `OnGameStart` fires client-side, `OnServerStarted` fires server-side, `OnDistributionMerge` fires when distributions load - don't mix contexts. **Reference**: [Lua Events (Build 41 archived)](https://pzwiki.net/wiki/Special:PermanentLink/767129)
5. **Workshop uploads**: Upload only `Contents/` folder contents, not the folder itself. **Reference**: [Workshop.txt (Build 41)](https://pzwiki.net/wiki/Workshop.txt)
6. **Script syntax**: Lua uses `require()`, but `.txt` scripts use PZ's custom parser - don't confuse them. **Reference**: [Item Scripts (Build 41)](https://pzwiki.net/wiki/Item_(scripts)) vs [Lua API (Build 41)](https://pzwiki.net/wiki/Lua_(API))
7. **Distribution manipulation**: Must happen in `OnDistributionMerge` event, not `OnServerStarted`. **Reference**: [Procedural Distributions (Build 41 archived)](https://pzwiki.net/wiki/Special:PermanentLink/405935)
8. **Global namespace**: Use `PI.Utils` instead of `require()` for shared utilities - more reliable in PZ's Lua environment
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