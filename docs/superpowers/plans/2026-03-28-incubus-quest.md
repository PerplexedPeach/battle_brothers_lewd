# Incubus Quest Chain Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a Daji-initiated quest that spawns an incubus boss fight in southern ruins, where incubus-caused climaxes advance the lewd seal, with post-battle events for victory/seal outcomes and gold headpiece recipe unlock.

**Architecture:** Score-based Daji event spawns a temple location on the world map. The location contains an incubus boss (reskinned human male) and harem thralls (human females). The lewd seal effect (already built) wraps `onClimax` to detect incubus-caused climaxes and advance stages. Post-battle event checks seal state and either removes it or confirms permanence. Sprites use placeholders initially.

**Tech Stack:** Squirrel (.nut), Battle Brothers modding API, Legends mod helmet layer system

---

### Task 1: Constants and Event Strings

**Files:**
- Modify: `mod_lewd/consts/00_values.nut`
- Modify: `mod_lewd/consts/strings.nut`

- [ ] **Step 1: Add incubus quest constants to 00_values.nut**

Add after the `DajiHeadwearAllureScale` line:

```squirrel
// Daji Incubus Quest: requires Ethereal + both corset + harness recipes + wearing harness
::Lewd.Const.DajiIncubusBaseScore <- 25;
::Lewd.Const.DajiIncubusAllureScale <- 2.0;
::Lewd.Const.IncubusHP <- 300;
::Lewd.Const.IncubusArmor <- 100;
::Lewd.Const.IncubusAllure <- 80;
::Lewd.Const.IncubusMeleeSkill <- 100;
::Lewd.Const.IncubusMeleeDef <- 50;
::Lewd.Const.IncubusRangedDef <- 40;
::Lewd.Const.IncubusInitiative <- 120;
::Lewd.Const.IncubusResolve <- 80;
::Lewd.Const.IncubusHaremCount <- 4;
::Lewd.Const.IncubusQuestSpawnMinDist <- 5;
::Lewd.Const.IncubusQuestSpawnMaxDist <- 10;
```

- [ ] **Step 2: Add Daji incubus event strings to strings.nut**

Add before the `::Lewd.Strings.EtherealReady` block:

```squirrel
// ---- Incubus Quest: Daji warns about a dangerous incubus ----
::Lewd.Strings.DajiIncubus <- {
	Screen_A = "The lacquer room is cold tonight. The candles burn low and blue, and Daji's reflection stands at the far edge of the mirror with her tails drawn close, the fur along their ridges standing on end. She does not smile when you arrive. Her voice, when it comes, carries an edge you have not heard before.%SPEECH_ON%There is something nearby. Something old and hungry and very, very good at what it does.%SPEECH_OFF%She turns, and in the lacquer behind her you catch a flicker of movement: a shape that is almost a man, beautiful in the way a blade is beautiful, wreathed in a heat haze that makes the air around him ripple.%SPEECH_ON%An incubus. One of the old ones. He has been building a harem in the ruins south of here, branding women with a seal that turns their own desire into a leash. I can feel his work from here, the way you can feel a fire through a wall.%SPEECH_OFF%",

	Screen_Dom = "Daji's tails flare behind her, gold-bright and sharp as blades.%SPEECH_ON%You have been learning to wield desire as a weapon. The corset, the harness, the way men forget their swords when you walk past. But this creature was born to it. He does not learn seduction. He is seduction, distilled and given flesh.%SPEECH_OFF%She meets your eyes in the mirror and you see something that might be respect.%SPEECH_ON%I am not asking you to be careful. I am asking you to be ruthless. Go to his temple. Break his hold on those women. And when he tries to turn your own hunger against you, show him that you are the one who decides when to burn.%SPEECH_OFF%Her reflection sharpens, fox-gold eyes blazing.%SPEECH_ON%He wears a golden crown. Take it from him. You have earned something beautiful on your head, and his will do nicely.%SPEECH_OFF%",

	Screen_Sub = "Daji's tails curl tight, and you feel her unease in your own chest like a hand pressing against your sternum.%SPEECH_ON%You know what it feels like to want. You have felt it in battle, the way your body responds before your mind can catch up. The ache that makes you arch when they pin you, the heat that pools low when hands close around your wrists. You have learned to ride that current instead of fighting it.%SPEECH_OFF%She pauses, and when she speaks again her voice is quieter.%SPEECH_ON%This creature will try to use that against you. He has a seal, a brand that feeds on climax and turns pleasure into a chain. Every time he makes you finish, the brand burns deeper. If he completes it, you will be his. Not mine. His.%SPEECH_OFF%The reflection's eyes burn with something between fear and possessive fury.%SPEECH_ON%I did not rebuild you from grief and grave-dust to lose you to some rutting demon. Go to his temple. Kill him. Take his crown. And for both our sakes, do not let him make you come four times.%SPEECH_OFF%",

	Screen_Wake = "You wake with the taste of ashes and jasmine on your tongue, and the knowledge of where to go settled in your bones like a compass needle finding north.\n\nThe ruins are real. You can feel them pulling at you the way Daji's voice pulled at you in the early days, a direction that lives in your sternum rather than your eyes. South, through the desert scrub, past the sandstone outcroppings where traders rest at midday. An old temple, half-swallowed by sand, where something beautiful and terrible has made its home.\n\nDaji stirs in the back of your awareness, tense and watchful. For the first time since you have known her, the fox spirit seems afraid.",
};

::Lewd.Strings.IncubusDefeated <- {
	Screen_Win_Clean = "The incubus dissolves like smoke in sunlight, his perfect face twisting into something raw and surprised as the last blow lands. The seal on your forehead flickers once, twice, and then fades like a dream on waking. The skin beneath is unmarked.\n\nThe branded women crumple where they stand, released from whatever held them upright, blinking like sleepers torn from a long dream. Some of them weep. Some of them simply sit down in the dust of the ruined temple and stare at nothing.\n\nAmong the wreckage you find it: a golden headpiece, sharp-pointed and beautiful, warm to the touch despite the stone-cold ruin. His crown. Yours now.\n\nDaji's presence swells in the back of your mind, fierce and relieved and proud in equal measure.",

	Screen_Win_Sealed = "The incubus dissolves like smoke in sunlight, his perfect face twisting into something raw and surprised as the last blow lands. You wait for the seal to fade.\n\nIt does not fade.\n\nThe brand on your forehead pulses once, warm and steady as a second heartbeat, and you understand with a clarity that tastes like copper and honey that the mark has burned too deep to follow its maker into oblivion. The seal is complete. Whatever he wrote into your flesh with four shuddering moments of surrender has become part of you, as permanent as bone.\n\nDaji's silence is louder than any words she has ever spoken. When she finally stirs, her voice is flat and careful.%SPEECH_ON%You let him finish it.%SPEECH_OFF%The branded women crumple and weep around you, freed. You are not freed. You won the battle and lost something else, something you cannot name but can feel in the way your skin hums and your thoughts keep circling back to the memory of his hands.\n\nAmong the wreckage you find his golden crown. You pick it up. It feels right against your temples, as though it was always meant to sit there.",

	Screen_Wake = "The company finds you standing in the ruins with gold on your head and dust on your knees. %randombrother% asks if you are hurt. You say no, and it is almost true.\n\nThe headpiece is yours now. Whatever the incubus was, whatever he tried to make you, his crown fits your brow like it was forged for it.",
};
```

- [ ] **Step 3: Commit**

```
git add mod_lewd/consts/00_values.nut mod_lewd/consts/strings.nut
git commit -m "Add incubus quest constants and event strings"
```

---

### Task 2: Incubus Racial Skill

**Files:**
- Create: `scripts/skills/racial/incubus_lewd_racial.nut`

- [ ] **Step 1: Create the incubus racial passive skill**

This is the identifier skill that the lewd seal checks for (`source.getSkills().hasSkill("racial.lewd_incubus")`). It also applies the seal to the player character on combat start.

```squirrel
// Incubus Lewd Racial -- passive identifier + seal applicator
// The lewd_seal_effect checks for this skill ID to determine if climax was incubus-caused
this.incubus_lewd_racial <- this.inherit("scripts/skills/skill", {
	m = {
		SealApplied = false
	},
	function create()
	{
		this.m.ID = "racial.lewd_incubus";
		this.m.Name = "";
		this.m.Description = "";
		this.m.Type = this.Const.SkillType.Racial;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = false;
	}

	function onCombatStarted()
	{
		if (this.m.SealApplied) return;

		// Find the player character (the Transform target) and apply seal stage 1
		local woman = ::Lewd.Transform.target();
		if (woman == null) return;
		if (woman.getSkills().hasSkill("effects.lewd_seal")) return; // already has seal

		woman.getSkills().add(this.new("scripts/skills/effects/lewd_seal_effect"));
		this.m.SealApplied = true;
		::logInfo("[incubus] Applied lewd seal stage 1 to " + woman.getName());
	}
});
```

- [ ] **Step 2: Commit**

```
git add scripts/skills/racial/incubus_lewd_racial.nut
git commit -m "Add incubus racial skill -- seal applicator and identifier"
```

---

### Task 3: Incubus Boss Entity

**Files:**
- Create: `scripts/entity/tactical/enemies/lewd_incubus.nut`

- [ ] **Step 1: Create the incubus entity**

Reskinned human male with high stats, male sex skills, and the Conqueror perk. Uses placeholder sprites (base game militia captain appearance).

```squirrel
this.lewd_incubus <- this.inherit("scripts/entity/tactical/actor", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.Militia;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/human_male_death_01.wav",
			"sounds/enemies/human_male_death_02.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/human_male_flee_01.wav"
		];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 1.0;
		this.m.SoundPitch = 0.95;
		this.m.IsGeneratingKillName = false;
	}

	function onInit()
	{
		this.actor.onInit();
		local C = ::Lewd.Const;
		local b = this.m.BaseProperties;

		b.setValues(this.Const.Tactical.Actor.Militia);
		b.IsSpecialist = true;

		b.Hitpoints = C.IncubusHP;
		b.MeleeSkill = C.IncubusMeleeSkill;
		b.MeleeDefense = C.IncubusMeleeDef;
		b.RangedDefense = C.IncubusRangedDef;
		b.Initiative = C.IncubusInitiative;
		b.Bravery = C.IncubusResolve;
		b.Stamina = 200;
		b.FatigueRecoveryRate = 25;
		b.Allure = C.IncubusAllure;

		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;

		this.m.ActionPoints = 12;
		this.m.ActionPointsMax = 12;
		this.m.Name = "Incubus";

		// Placeholder appearance: militia captain body, noble face
		this.m.Items.equip(this.new("scripts/items/weapons/named/named_sword"));

		this.getSprite("socket").setBrush("bust_base_militia");
		this.getSprite("body").setBrush("bust_militia_body_07");
		this.getSprite("head").setBrush("bust_head_01");
		this.getSprite("hair").setBrush("bust_hair_01");
		this.getSprite("body_blood").Visible = false;
		this.getSprite("head_blood").Visible = false;

		this.m.Skills.add(this.new("scripts/skills/racial/incubus_lewd_racial"));

		// Male sex skills
		this.m.Skills.add(this.new("scripts/skills/actives/male_grope_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/male_force_oral_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/male_penetrate_vaginal_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/male_penetrate_anal_skill"));

		// Conqueror perk: heals from causing climax
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_conqueror"));

		// Standard human combat skills
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
	}

	function assignRandomEquipment()
	{
		// Placeholder armor
		local body = this.new("scripts/items/armor/noble_mail_armor");
		body.setArmor(C.IncubusArmor);
		this.m.Items.equip(body);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}
});
```

Note: The entity type `Militia` is a placeholder. The appearance sprites are also placeholders. These will be replaced with custom incubus sprites once generated.

- [ ] **Step 2: Commit**

```
git add scripts/entity/tactical/enemies/lewd_incubus.nut
git commit -m "Add incubus boss entity with placeholder sprites"
```

---

### Task 4: Incubus Harem Thrall Entity

**Files:**
- Create: `scripts/entity/tactical/enemies/lewd_incubus_thrall.nut`

- [ ] **Step 1: Create the thrall entity**

Human female using existing lewd body sprites and base game female heads. Moderate stats, has female sex skills.

```squirrel
this.lewd_incubus_thrall <- this.inherit("scripts/entity/tactical/actor", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.Militia;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/human_female_death_01.wav",
			"sounds/enemies/human_female_death_02.wav"
		];
		this.m.SoundPitch = 1.1;
		this.m.IsGeneratingKillName = false;
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;

		b.setValues(this.Const.Tactical.Actor.Militia);
		b.Hitpoints = 80;
		b.MeleeSkill = 50;
		b.MeleeDefense = 10;
		b.RangedDefense = 10;
		b.Initiative = 100;
		b.Bravery = 999;
		b.Stamina = 120;
		b.Allure = 30;

		this.m.ActionPoints = 9;
		this.m.ActionPointsMax = 9;
		this.m.Gender = 1; // female
		this.m.Name = "Branded Thrall";

		// Use lewd body T1 sprites (more feminine) + base game female faces
		local bodyVariant = this.Math.rand(1, 3);
		this.getSprite("socket").setBrush("bust_base_militia");
		this.getSprite("body").setBrush("bust_lewd_body_0" + bodyVariant);
		this.getSprite("head").setBrush("bust_head_female_0" + this.Math.rand(1, 5));
		this.getSprite("hair").setBrush("bust_hair_female_0" + this.Math.rand(1, 5));
		this.getSprite("body_blood").Visible = false;
		this.getSprite("head_blood").Visible = false;

		// Female sex skills
		this.m.Skills.add(this.new("scripts/skills/actives/hands_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/oral_skill"));

		// Basic combat
		this.m.Skills.add(this.new("scripts/skills/actives/slash_skill"));
	}

	function assignRandomEquipment()
	{
		this.m.Items.equip(this.new("scripts/items/weapons/dagger"));
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}
});
```

Note: Sprite brush names are placeholders. The actual lewd body brushes and female head brushes need to be verified against the existing brush metadata. Adjust brush names to match what exists in the mod's unpacked_brushes.

- [ ] **Step 2: Commit**

```
git add scripts/entity/tactical/enemies/lewd_incubus_thrall.nut
git commit -m "Add incubus harem thrall entity with placeholder sprites"
```

---

### Task 5: Temple Location

**Files:**
- Create: `scripts/entity/world/locations/lewd_incubus_temple_location.nut`

- [ ] **Step 1: Create the temple location**

Southern ruins lair that spawns the incubus and harem thralls. Uses `tactical.sunken_library` template. Fires `event.lewd_incubus_defeated` on destruction.

```squirrel
this.lewd_incubus_temple_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Ancient temple ruins half-swallowed by sand. A strange heat shimmers above the stone.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.lewd_incubus_temple";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsScalingDefenders = false;
		this.m.Resources = 0;
		this.m.OnDestroyed = "event.lewd_incubus_defeated";
		this.m.CombatLocation.Template[1] = "tactical.sunken_library";
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.AdditionalRadius = 4;
	}

	function onSpawned()
	{
		this.m.Name = "Ruined Temple";

		// Incubus boss
		this.Const.World.Common.addTroop(this, {
			Type = {
				ID = this.Const.EntityType.Militia,
				Variant = 0,
				Strength = 500,
				Cost = 500,
				Row = 2,
				Script = "scripts/entity/tactical/enemies/lewd_incubus"
			}
		}, false);

		// Harem thralls
		for (local i = 0; i < ::Lewd.Const.IncubusHaremCount; i++)
		{
			this.Const.World.Common.addTroop(this, {
				Type = {
					ID = this.Const.EntityType.Militia,
					Variant = 0,
					Strength = 50,
					Cost = 50,
					Row = this.Math.rand(0, 3),
					Script = "scripts/entity/tactical/enemies/lewd_incubus_thrall"
				}
			}, false);
		}

		this.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		// Placeholder world sprite: reuse existing ruin brush
		local body = this.addSprite("body");
		body.setBrush("world_location_07");
	}

	function onBeforeCombatStarted()
	{
		// Re-add troops if player retreated previously
		if (this.m.Troops.len() == 0)
		{
			this.Const.World.Common.addTroop(this, {
				Type = {
					ID = this.Const.EntityType.Militia,
					Variant = 0,
					Strength = 500,
					Cost = 500,
					Row = 2,
					Script = "scripts/entity/tactical/enemies/lewd_incubus"
				}
			}, false);

			for (local i = 0; i < ::Lewd.Const.IncubusHaremCount; i++)
			{
				this.Const.World.Common.addTroop(this, {
					Type = {
						ID = this.Const.EntityType.Militia,
						Variant = 0,
						Strength = 50,
						Cost = 50,
						Row = this.Math.rand(0, 3),
						Script = "scripts/entity/tactical/enemies/lewd_incubus_thrall"
					}
				}, false);
			}
		}
		this.location.onBeforeCombatStarted();
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.getSprite("selection").Visible = true;
	}
});
```

- [ ] **Step 2: Commit**

```
git add scripts/entity/world/locations/lewd_incubus_temple_location.nut
git commit -m "Add incubus temple world location with southern ruins template"
```

---

### Task 6: Daji Trigger Event

**Files:**
- Create: `scripts/events/events/lewd_daji_incubus.nut`

- [ ] **Step 1: Create the Daji incubus quest trigger event**

Score-based event. Requires Ethereal, both clothing recipes, and wearing the harness. Spawns the temple location on the Wake screen.

```squirrel
this.lewd_daji_incubus <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		IsDom = false
	},
	function create()
	{
		this.m.ID = "event.lewd_daji_incubus";
		this.m.Title = "Daji's Warning";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = ::Lewd.Strings.DajiIncubus.Screen_A,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What would you have me do?",
					function getResult( _event )
					{
						if (_event.m.IsDom)
							return "Dom";
						return "Sub";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Dom",
			Text = ::Lewd.Strings.DajiIncubus.Screen_Dom,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "His crown will look better on me.",
					function getResult( _event )
					{
						return "Wake";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Sub",
			Text = ::Lewd.Strings.DajiIncubus.Screen_Sub,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I will not let him have me.",
					function getResult( _event )
					{
						return "Wake";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Wake",
			Text = ::Lewd.Strings.DajiIncubus.Screen_Wake,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prepare for the hunt.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.World.Flags.set("lewdIncubusQuestStarted", true);
				this.Characters.push(_event.m.Woman.getImagePath());

				// Spawn temple location
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = ::Lewd.Location.findNearbyTile(playerTile,
					::Lewd.Const.IncubusQuestSpawnMinDist,
					::Lewd.Const.IncubusQuestSpawnMaxDist);

				if (tile != null)
				{
					local loc = this.World.spawnLocation(
						"scripts/entity/world/locations/lewd_incubus_temple_location",
						tile.Coords);
					loc.onSpawned();
					loc.setDiscovered(true);
					loc.getSprite("selection").Visible = true;
					this.World.uncoverFogOfWar(loc.getTile().Pos, 500.0);
					this.World.Flags.set("lewdIncubusTempleID", loc.getID());

					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = "A ruined temple has been revealed on the map"
					});
				}

				this.List.push({
					id = 11,
					icon = "ui/icons/warning.png",
					text = "Daji warns: do not let the incubus complete his seal"
				});
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		if (this.m.Woman == null
			|| ::Lewd.Mastery.getLewdTier(this.m.Woman) < 3
			|| this.World.Flags.has("lewdIncubusQuestStarted")
			|| !this.World.Flags.has("lewdRecipeCorset")
			|| !this.World.Flags.has("lewdRecipeLatexHarness"))
		{
			this.m.Score = 0;
			return;
		}

		// Must be wearing the harness
		local body = this.m.Woman.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		if (body == null)
		{
			this.m.Score = 0;
			return;
		}

		// Check if wearing harness: walk the armor upgrades looking for harness ID
		local isWearingHarness = false;
		if ("getUpgrades" in body)
		{
			local upgrades = body.getUpgrades();
			foreach (u in upgrades)
			{
				if (u != null && u.getID() == "legend_armor.body.lewd_latex_harness")
				{
					isWearingHarness = true;
					break;
				}
			}
		}
		// Also check if the base armor itself is the harness (unlikely but handle)
		if (!isWearingHarness && body.getID() == "legend_armor.body.lewd_latex_harness")
			isWearingHarness = true;

		if (!isWearingHarness)
		{
			this.m.Score = 0;
			return;
		}

		local allure = this.m.Woman.getCurrentProperties().getAllure();
		this.m.Score = ::Lewd.Const.DajiIncubusBaseScore + allure * ::Lewd.Const.DajiIncubusAllureScale;
		this.m.IsDom = ::Lewd.Mastery.getDomSub(this.m.Woman) >= 0;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"woman",
			this.m.Woman.getName()
		]);
	}

	function onClear()
	{
		this.m.Woman = null;
	}
});
```

- [ ] **Step 2: Commit**

```
git add scripts/events/events/lewd_daji_incubus.nut
git commit -m "Add Daji incubus quest trigger event with temple spawn"
```

---

### Task 7: Post-Battle Defeated Event

**Files:**
- Create: `scripts/events/events/lewd_incubus_defeated.nut`

- [ ] **Step 1: Create the post-battle event**

Fires via the temple's `OnDestroyed` field. Checks seal state, removes if incomplete, keeps if stage 4. Unlocks gold headpiece recipe.

```squirrel
this.lewd_incubus_defeated <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		IsSealComplete = false
	},
	function create()
	{
		this.m.ID = "event.lewd_incubus_defeated";
		this.m.Title = "The Incubus Falls";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;

		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take the crown.",
					function getResult( _event )
					{
						return "Wake";
					}
				}
			],
			function start( _event )
			{
				// Determine seal state
				_event.m.Woman = ::Lewd.Transform.target();
				if (_event.m.Woman != null)
				{
					local seal = _event.m.Woman.getSkills().getSkillByID("effects.lewd_seal");
					if (seal != null && seal.getStage() >= 4)
					{
						_event.m.IsSealComplete = true;
						this.Text = ::Lewd.Strings.IncubusDefeated.Screen_Win_Sealed;
					}
					else
					{
						_event.m.IsSealComplete = false;
						this.Text = ::Lewd.Strings.IncubusDefeated.Screen_Win_Clean;

						// Remove incomplete seal
						if (seal != null)
							_event.m.Woman.getSkills().removeByID("effects.lewd_seal");
					}

					this.Characters.push(_event.m.Woman.getImagePath());
				}
				else
				{
					this.Text = ::Lewd.Strings.IncubusDefeated.Screen_Win_Clean;
				}
			}
		});

		this.m.Screens.push({
			ID = "Wake",
			Text = ::Lewd.Strings.IncubusDefeated.Screen_Wake,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The crown is mine.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.World.Flags.set("lewdRecipeGoldHeadpiece", true);
				this.World.Flags.set("lewdIncubusDefeated", true);

				if (_event.m.Woman != null)
					this.Characters.push(_event.m.Woman.getImagePath());

				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "You know how to craft a Gold Headpiece (requires a blacksmith)"
				});

				if (_event.m.IsSealComplete)
				{
					this.List.push({
						id = 11,
						icon = "ui/icons/warning.png",
						text = "The Lewd Seal has burned into your very being (permanent)"
					});
				}
				else
				{
					this.List.push({
						id = 11,
						icon = "ui/icons/special.png",
						text = "The incubus's mark fades from your skin"
					});
				}
			}
		});
	}

	function onUpdateScore()
	{
		// Fired directly via location OnDestroyed, not via score system
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.Woman != null)
		{
			_vars.push([
				"woman",
				this.m.Woman.getName()
			]);
		}
	}

	function onClear()
	{
		this.m.Woman = null;
		this.m.IsSealComplete = false;
	}
});
```

- [ ] **Step 2: Commit**

```
git add scripts/events/events/lewd_incubus_defeated.nut
git commit -m "Add post-battle incubus defeated event with seal check and recipe unlock"
```

---

### Task 8: Wire Up Combat Detection and Seal Cleanup

**Files:**
- Modify: `scripts/!mods_preload/mod_lewd.nut`

The incubus racial skill handles seal application on combat start. For the post-battle cleanup (removing seal if incomplete when fighting non-incubus battles), we need a check in `onCombatFinished`. The location's `OnDestroyed` handles the victory event.

- [ ] **Step 1: Add seal cleanup to onCombatFinished hook**

In `scripts/!mods_preload/mod_lewd.nut`, find the `onCombatFinished` hook (around line 1160). After the existing hexen/gheist checks, add:

```squirrel
			// --- Incubus seal cleanup ---
			// If player has an incomplete seal after a non-incubus battle, remove it
			// (The incubus defeated event handles the real seal check on temple victory)
			local woman = ::Lewd.Transform.target();
			if (woman != null)
			{
				local seal = woman.getSkills().getSkillByID("effects.lewd_seal");
				if (seal != null && seal.getStage() < 4 && !this.World.Flags.has("lewdIncubusQuestStarted"))
				{
					woman.getSkills().removeByID("effects.lewd_seal");
					::logInfo("[mod_lewd] Removed incomplete lewd seal after non-incubus combat");
				}
			}
```

- [ ] **Step 2: Commit**

```
git add scripts/!mods_preload/mod_lewd.nut
git commit -m "Add incomplete seal cleanup in onCombatFinished"
```

---

### Task 9: Integration Test via Debug Commands

No automated tests exist for this mod. Verify manually via dev console.

- [ ] **Step 1: Test spawning the temple directly**

```squirrel
// Spawn temple near player
local playerTile = this.World.State.getPlayer().getTile();
local tile = ::Lewd.Location.findNearbyTile(playerTile, 3, 5);
local loc = this.World.spawnLocation("scripts/entity/world/locations/lewd_incubus_temple_location", tile.Coords);
loc.onSpawned();
loc.setDiscovered(true);
loc.getSprite("selection").Visible = true;
this.World.uncoverFogOfWar(loc.getTile().Pos, 500.0);
```

- [ ] **Step 2: Test firing the trigger event directly**

```squirrel
this.World.Events.fire("event.lewd_daji_incubus")
```

- [ ] **Step 3: Test seal advancement in combat**

Enter combat with the temple. Verify:
- Seal stage 1 appears on player character at combat start
- After incubus causes a climax, seal advances to stage 2
- Seal icon and sprite update
- Defeating the incubus with seal < 4 triggers the defeated event with seal removal
- Defeating with seal == 4 triggers defeated event with permanent seal

- [ ] **Step 4: Test recipe unlock**

After victory, verify:
```squirrel
::logInfo("" + this.World.Flags.has("lewdRecipeGoldHeadpiece"));
```

- [ ] **Step 5: Commit any fixes from testing**

```
git add -A
git commit -m "Fix issues found during incubus quest integration testing"
```
