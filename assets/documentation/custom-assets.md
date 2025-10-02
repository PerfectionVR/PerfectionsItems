# Custom Assets Documentation

## Directory Structure

Custom assets for Perfection's Items mod are organized in the following directories:

```
Contents/mods/PerfectionsItems/media/
├── textures/    # Inventory icons and UI textures
├── models/      # 3D weapon models
└── sound/       # Sound effects
```

## Textures (Inventory Icons)

**Location**: `media/textures/`

### Required Files (TODO)

- `Item_WoodenSword.png` - Wooden Sword inventory icon
- `Item_Bokuto.png` - Bokuto inventory icon
- `Item_BokutoMagazine.png` - Crafting Manual icon

### Specifications

- **Format**: PNG with transparency
- **Size**: 256x256 pixels (recommended)
- **Style**: Match vanilla Project Zomboid aesthetic
- **Naming**: `Item_<ItemName>.png` format

### Implementation

After adding textures, update the corresponding `Icon` property in `media/scripts/items.txt`:

```plaintext
item WoodenSword {
    Icon = WoodenSword,  # References Item_WoodenSword.png
    ...
}
```

**Reference**: [Item Scripts Documentation](https://pzwiki.net/wiki/Item_(scripts))

---

## 3D Models (Weapon Sprites)

**Location**: `media/models/`

### Required Files (TODO)

- `WoodenSword.x` - Wooden Sword 3D model
- `Bokuto.x` - Bokuto 3D model

### Specifications

- **Format**: DirectX .x format (preferred) or .fbx
- **Poly Count**: Low-poly for performance (similar to vanilla weapons)
- **UV Mapping**: Proper UV mapping for textures
- **Scale**: Match vanilla weapon dimensions
- **Pivot Point**: Properly positioned for weapon grip

### Implementation

After adding models, update the corresponding `WeaponSprite` property in `media/scripts/items.txt`:

```plaintext
item WoodenSword {
    WeaponSprite = WoodenSword,  # References WoodenSword.x
    ...
}
```

**Reference**: [Creating Custom Models Guide](https://pzwiki.net/wiki/Creating_a_clothing_mod)

---

## Sound Effects

**Location**: `media/sound/`

### Required Files (TODO)

#### Wooden Sword
- `WoodenSwordHit.ogg` - Hit impact sound
- `WoodenSwordSwing.ogg` - Swing/whoosh sound
- `WoodenSwordBreak.ogg` - (Optional) Breaking sound

#### Bokuto
- `BokutoHit.ogg` - Hit impact sound
- `BokutoSwing.ogg` - Swing/whoosh sound
- `BokutoBreak.ogg` - (Optional) Breaking sound

### Specifications

- **Format**: Vorbis OGG codec
- **Sample Rate**: 44.1kHz (standard)
- **Bit Depth**: 16-bit
- **Volume**: Normalized to match vanilla weapon sounds
- **Length**: Keep short (0.5-2 seconds for hits, 0.3-1 second for swings)

### Implementation

After adding sounds, update the corresponding sound properties in `media/scripts/items.txt`:

```plaintext
item WoodenSword {
    HitSound = WoodenSwordHit,
    SwingSound = WoodenSwordSwing,
    DoorHitSound = WoodenSwordHit,
    HitFloorSound = WoodenSwordHit,
    BreakSound = WoodenSwordBreak,  # Optional custom break sound
    ...
}
```

**Reference**: [Sound Scripts Documentation](https://pzwiki.net/wiki/Sound_(scripts))

---

## Asset Creation Tools

### Textures
- **GIMP** or **Photoshop** - For PNG icon creation
- **Paint.NET** - Free alternative
- Study vanilla PZ icons for style consistency

### 3D Models
- **Blender** - Free, exports to .x and .fbx formats
- **3ds Max** or **Maya** - Professional options
- Use PZ modding tools for testing in-game

### Sounds
- **Audacity** - Free audio editor, exports to OGG
- **Freesound.org** - Creative Commons sound library
- **REAPER** - Professional DAW with OGG export

## Testing Workflow

1. Add asset files to appropriate `media/` subdirectory
2. Update item definitions in `media/scripts/items.txt`
3. Test in-game to verify assets load correctly
4. Check console for any missing file errors (`[PI]` prefix in logs)
5. Verify performance impact (especially for models)
