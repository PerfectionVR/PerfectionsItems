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

- `Client.lua` - Client-side logic
- `Server.lua` - Server-side logic
- `Options.lua` - ModOptions integration
- `Utils.lua` - Shared utilities

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
