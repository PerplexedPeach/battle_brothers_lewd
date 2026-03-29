# Incubus Quest Chain Design

## Overview

A Daji-initiated quest where the player confronts an incubus in his temple ruins. The incubus attempts to brand the player with the Lewd Seal by forcing climaxes during combat. If the seal reaches stage 4 before the battle ends, it becomes a permanent curse. Defeating the incubus unlocks the Gold Headpiece recipe.

## Trigger

**Event: `event.lewd_daji_incubus`** (score-based world event)

Prerequisites:
- Ethereal trait (tier 3)
- `lewdRecipeCorset` AND `lewdRecipeLatexHarness` both set (completed both Daji clothing quests)
- Player character is currently wearing the latex harness (equipped in body armor slot)
- `lewdIncubusQuestStarted` flag NOT set (one-time)

Score: `DajiIncubusBaseScore + allure * DajiIncubusAllureScale`

Narrative: Daji senses a dangerous presence -- an incubus who has built a harem in ancient southern ruins. She frames it as a test: you've learned to wield desire as a weapon, now face a creature who was born to it. She warns that sex can be turned against you. Dom/sub variant text for the warning.

On the Wake screen:
- Sets `lewdIncubusQuestStarted` flag
- Spawns the temple location on the world map near the player
- Uncovers fog of war around it

## Battle Location

**`lewd_incubus_temple_location.nut`**

- TypeID: `location.lewd_incubus_temple`
- LocationType: `Const.World.LocationType.Lair`
- CombatLocation.Template: `tactical.sunken_library` (southern ruins with bronze statues)
- OnDestroyed: `event.lewd_incubus_defeated`
- Name: "Ruined Temple"
- World map sprite: reuse an existing southern ruin brush (e.g. `legend_ancient_ruins` or similar)

## Enemy Composition

### Incubus (boss)

- Script: `scripts/entity/tactical/enemies/lewd_incubus`
- Base: reskinned human male
- HP: ~300, high armor (100/100), moderate stats
- MeleeSkill: 80, MeleeDef: 25, RangedDef: 15, Initiative: 120, Resolve: 80, Bravery: 999 (Ignore morale)
- Damage reduction or healing: grant the Conqueror perk (heals from causing climax, already exists)
- Has all male sex skills (grope, force oral, penetrate vaginal, penetrate anal)
- Unique ability: on combat start, applies Lewd Seal stage 1 to the player character
- When the incubus directly causes the player to climax, the seal advances one stage
- High allure to trigger horny on the player
- Custom tactical sprite (TODO -- placeholder with existing male sprite initially)

### Harem Members (3-5 female adds)

- Script: `scripts/entity/tactical/enemies/lewd_incubus_thrall`
- Base: human female using lower-tier lewd bodies (more feminine), base game female faces
- HP: ~80, light armor, moderate combat stats
- Have female sex skills (oral, hands, vaginal)
- Purpose: distract the player's brothers, provide bodies for the incubus's pleasure ecosystem
- Standard AI -- they fight normally and use sex skills when horny

## Seal Advancement Mechanic

The seal advances ONLY when the incubus directly causes the player character to climax.

### Implementation

Hook into `climax_effect` (the effect that fires when pleasure overflows):

1. In `onCombatStarted` (via `lewd_info_effect` or a new hook): detect incubus presence, set `lewdFightingIncubus` stat flag, apply seal stage 1 to the player character
2. In `climax_effect`: when the actor who climaxed is the player character AND the source of the climax is the incubus (tracked via `addPleasure(amount, source)` -- the source entity), advance the seal
3. The `addPleasure` function already takes a source parameter. The climax_effect needs to know who caused the overflow. Check if the last source of pleasure was the incubus.

### Tracking Climax Source

The `addPleasure(amount, source)` already passes a source actor. The climax_effect fires when pleasure exceeds PleasureMax. We need to thread the source through to the climax check. Options:

**Approach: Store last pleasure source on the actor**
- In the hooked `addPleasure`, store `m.LastPleasureSource = source` before the climax check
- In `climax_effect.onAdded()` (fires when climax triggers), read `actor.m.LastPleasureSource`
- If it matches the incubus entity, advance the seal

This is clean because `addPleasure` is already the single choke point and already receives the source.

## Post-Battle Events

### On Victory (`event.lewd_incubus_defeated`)

Fires via the location's `OnDestroyed` field when the lair is cleared.

**If seal stage < 4:** The seal fades. Remove the `lewd_seal_effect` from the player. Narrative: the incubus's mark dissolves without his power sustaining it. You proved stronger.

**If seal stage == 4:** The seal is permanent. Do NOT remove it. Narrative: the seal burned too deep. Daji is disappointed -- you let him complete his brand. You are marked as his even in death, though the creature itself is gone. The seal's power remains.

**Both paths:** Unlock `lewdRecipeGoldHeadpiece` flag. The gold headpiece was the incubus's crown, now yours as a trophy. Add it to stash or grant knowledge.

List items on the Wake screen:
- "You claimed the Incubus's golden headpiece" (recipe unlock)
- If seal permanent: "The Lewd Seal has burned into your very being" (permanent curse notification)
- If seal faded: "The incubus's mark fades from your skin"

### Dom/Sub Variant Text

- Dom + seal faded: triumphant, you conquered a creature of pure desire
- Dom + seal permanent: bitter victory, you won but bear his brand forever
- Sub + seal faded: relief mixed with... something else. A part of you almost wanted it.
- Sub + seal permanent: the seal feels right. Daji's disappointment stings but the warmth of the brand is undeniable.

## Constants (00_values.nut)

```
::Lewd.Const.DajiIncubusBaseScore <- 25
::Lewd.Const.DajiIncubusAllureScale <- 2.0
::Lewd.Const.IncubusHP <- 300
::Lewd.Const.IncubusArmor <- 100
::Lewd.Const.IncubusAllure <- 40
::Lewd.Const.IncubusMeleeSkill <- 80
::Lewd.Const.IncubusHaremCount <- 4
```

## File Manifest

### New Files
- `scripts/events/events/lewd_daji_incubus.nut` -- trigger event (Daji warns, spawns location)
- `scripts/events/events/lewd_incubus_defeated.nut` -- post-battle event (seal check, recipe unlock)
- `scripts/entity/world/locations/lewd_incubus_temple_location.nut` -- world map location
- `scripts/entity/tactical/enemies/lewd_incubus.nut` -- incubus boss entity
- `scripts/entity/tactical/enemies/lewd_incubus_thrall.nut` -- harem member entity
- `mod_lewd/consts/strings.nut` -- event text additions (DajiIncubus, IncubusDefeated)

### Modified Files
- `mod_lewd/consts/00_values.nut` -- new constants
- `scripts/!mods_preload/mod_lewd.nut` -- onCombatStarted hook for incubus detection, onCombatFinished for seal cleanup, LastPleasureSource tracking
- `scripts/skills/effects/climax_effect.nut` -- check for incubus source, advance seal

### Deferred (sprite work)
- Incubus tactical bust sprite (placeholder with existing male sprite initially)
- Incubus world map brush sprite
- Harem thrall sprites (use existing lewd female bodies + base game female faces)
- Temple location world map icon
