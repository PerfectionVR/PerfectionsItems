# Changelog

All notable changes to Perfection's Items will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Custom textures for item icons
- Custom 3D weapon models
- Custom sound effects (hit/swing sounds)

## [0.1.0] - 2025-10-02

### Added
- Initial development release
- Wooden Sword craftable weapon (Carpentry 4, 5 XP)
- Bokuto craftable weapon (Carpentry 8, 15 XP)
- Crafting Manual for learning recipes (spawns in bookstores)
- ModOptions integration for individual item spawn control
- Pure Lua distribution system (scalable, prevents container bloat)
- Rarity tier system (COMMON to LEGENDARY) for consistent spawn rates
- Separated distribution data (Distributions.lua) from logic (Server.lua)
- Grouped spawn system by location and item type
- Debug logging with [PI] prefix for troubleshooting
- Currently using vanilla assets (Bat icon/model/sounds)

### Item Rarities
- Wooden Sword: VERY_RARE (0.05%) in tool stores
- Bokuto: RARE (0.1%) in tool stores, EXOTIC (0.01%) in sports stores
- Crafting Manual: EXOTIC (0.01%) in bookstores/libraries

### Dependencies
- ModOptions Framework (required)
- Project Zomboid Build 41.78.16+