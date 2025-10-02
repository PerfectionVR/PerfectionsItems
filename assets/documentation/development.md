# Development Documentation

## Project Structure

```
PerfectionsItems/
├── Contents/                    # Workshop upload content
│   └── mods/
│       └── PerfectionsItems/    # Actual mod files
│           ├── media/
│           ├── mod.info
│           └── poster.png
├── assets/                      # Development files (not uploaded)
│   ├── documentation/           # This file and guides
│   ├── source_images/          # Original artwork, PSDs, etc.
│   └── templates/              # Code templates
├── workshop.txt                 # Workshop metadata
├── preview.png                 # 256x256 workshop thumbnail
├── README.md                   # Public documentation
├── CHANGELOG.md                # Version history
└── .gitignore                  # Version control ignore rules
```

## Development Workflow

### 1. Making Changes

- Edit files in `Contents/mods/PerfectionsItems/`
- Test changes in-game
- Update version in `mod.info` if needed
- Document changes in `CHANGELOG.md`

### 2. Testing

- Test locally before workshop upload
- Verify all dependencies work
- Check console for errors with `[PI]` prefix

### 3. Version Management

- Follow semantic versioning (0.1.0 = initial development)
- Update `CHANGELOG.md` with all changes
- Tag releases if using git

### 4. Workshop Upload

- Upload only the `Contents` folder
- Include `workshop.txt` and `preview.png`
- Never upload the `assets` folder

## Code Standards

### File Organization

- `client/Client.lua` - Client-side initialization
- `client/Options.lua` - ModOptions UI integration
- `server/Server.lua` - Server-side spawn orchestration, ModOptions reading
- `server/Distributions.lua` - Item spawn data, rarity constants, distribution helper function
- `shared/Utils.lua` - Shared debug logging utilities

### Rarity System

All spawn chances use the rarity tier system defined in `server/Distributions.lua`:

```lua
ItemDistributions.Rarity = {
    COMMON = 1.0,       -- 1% - Easy to find
    UNCOMMON = 0.5,     -- 0.5% - Fairly common
    RARE = 0.1,         -- 0.1% - Requires searching
    VERY_RARE = 0.05,   -- 0.05% - Hard to find
    EXOTIC = 0.01,      -- 0.01% - Extremely rare
    LEGENDARY = 0.001,  -- 0.001% - Near mythical
}
```

When adding new items, always use these constants instead of hardcoded numbers:
```lua
{item = "PerfectionsItems.NewItem", chance = ItemDistributions.Rarity.RARE}
```

### Distribution Architecture

**Separation of Concerns**: Distribution data and logic are cleanly separated for scalability.

**`server/Distributions.lua`** (Data Layer):
- Rarity tier constants
- Item spawn definitions grouped by type (weapons, martialArts, literature)
- Location arrays for each item group
- `addItemsToLocationGroup()` helper function

**`server/Server.lua`** (Logic Layer):
- ModOptions integration (`getOptions()`, `isItemDisabled()`)
- Distribution orchestration in `addItemsToDistributions()`
- Event registration (`OnDistributionMerge`, `OnServerStarted`)

**Why this works**:
- Scales to 100+ items without code bloat
- Clear separation: Server.lua answers "should this spawn?", Distributions.lua answers "how does it spawn?"
- Easy to modify spawn chances by adjusting rarity tier values
- Early-out pattern prevents unnecessary work for disabled items

### Adding New Items

1. Define item in `media/scripts/items.txt`
2. Add recipe to `media/scripts/recipes.txt` (if craftable)
3. Add to `server/Distributions.lua`:
   ```lua
   -- Add to existing group or create new one
   ItemDistributions.newItemGroup = {
       {item = "PerfectionsItems.NewItem", chance = ItemDistributions.Rarity.RARE},
   }
   ItemDistributions.newItemLocations = {"LocationName"}
   ```
4. Add ModOptions flag to `client/Options.lua`
5. Add disable check to `server/Server.lua` `isItemDisabled()`
6. Call distribution function in `server/Server.lua` `addItemsToDistributions()`

### Logging

- Use `Utils.debugPrint()` for all debug output
- Include `[PI]` prefix for identification
- Keep debug messages informative but concise

### Dependencies

- Always provide fallbacks for missing dependencies
- Use established community APIs when possible
- Document all requirements in mod.info

## Performance Notes

- Load utilities once at file top
- Use community APIs for heavy operations
- Avoid frequent table creation in hot paths
- Cache expensive lookups when possible

## Compatibility Guidelines

- Never overwrite vanilla files
- Use unique item/recipe IDs
- Test with popular mod combinations
- Provide graceful degradation

## Workshop Best Practices

- Professional preview image (256x256)
- Detailed description with features list
- Clear requirements section
- Regular updates with changelogs
- Respond to community feedback

## TODO: Custom Assets

### Textures (Icons)

- Create `media/textures/Item_WoodenSword.png` (256x256 recommended)
- Create `media/textures/Item_Bokuto.png` (256x256 recommended)
- Create `media/textures/Item_BokutoMagazine.png` (256x256 recommended)
- Update `Icon` properties in `items.txt` to reference new filenames

### 3D Models (Weapon Sprites)

- Create `media/models/WoodenSword.x` or `.fbx` (PZ uses DirectX .x format)
- Create `media/models/Bokuto.x` or `.fbx`
- Update `WeaponSprite` properties in `items.txt`
- Reference: [Creating Custom Models](https://pzwiki.net/wiki/Creating_a_clothing_mod)

### Sound Effects

- Create `media/sound/WoodenSwordHit.ogg` (Vorbis OGG format)
- Create `media/sound/WoodenSwordSwing.ogg`
- Create `media/sound/BokutoHit.ogg`
- Create `media/sound/BokutoSwing.ogg`
- Update `HitSound`, `SwingSound`, `DoorHitSound` properties in `items.txt`
- Reference: [Sound Scripts](<https://pzwiki.net/wiki/Sound_(scripts)>)

### Asset Guidelines

- **Icons**: 256x256 PNG with transparency, follow vanilla PZ style
- **Models**: Low-poly for performance, proper UV mapping, .x format preferred
- **Sounds**: Vorbis OGG codec, normalized volume to match vanilla weapons
- **Testing**: Verify assets load correctly and don't cause performance issues
