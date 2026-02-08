::Lewd <- {
	ID = "mod_lewd",
	Version = "1.0.0",
	Name = "Lewdness",
	IsStartingNewCampaign = false
};

::Lewd.Const <- {};

// ::mods_registerMod(::Lewd.ID, ::Lewd.Version, ::Lewd.Name);
local mod = ::Hooks.register(::Lewd.ID, ::Lewd.Version, ::Lewd.Name);

mod.require("mod_legends", "mod_msu");

// ::mods_queue(modID, "mod_legends,mod_msu", function()
mod.queue(">mod_legends", ">mod_msu", function()
{
	::Lewd.Mod <- ::MSU.Class.Mod(::Lewd.ID, ::Lewd.Version, ::Lewd.Name);
	// TODO registery for updates

	// includes in order
	foreach (dir in [
		"mod_lewd/consts"
	]) {
		foreach (file in ::IO.enumerateFiles(dir))
			::include(file);
	}

	// TODO when these get large, refactor out into separate files and include them
	mod.hook("scripts/entity/tactical/actor", function (q)
	{

		q.sexiness <- function() {
			local sexiness = 0;
			// TODO calculate sexiness based on equipped items, traits, perks, etc
			// for now just return a placeholder value
			sexiness += this.getFlags().getAsInt("sexinessHeels");
			// melee defense contributes half as it represents agility
			sexiness += this.getCurrentProperties().getMeleeDefense() * 0.5;
			 // resolve contributes a quarter as it represents presence
			return sexiness;
		}

		// any extra heelHeight > heelSkill results in a fatigue penalty when moving
		q.onMovementStep = @() function ( _tile, _levelDifference )
		{
			// NOTE when we have to replace rather than wrap the original since the extra fatigue cost from the heels could make it so we can't actually move a tile
			// there is a lot of code duplication as a result
			if (this.m.CurrentProperties.IsRooted || this.m.CurrentProperties.IsStunned)
			{
				return false;
			}

			local apCost = this.Math.max(1, (this.m.ActionPointCosts[_tile.Type] + this.m.CurrentProperties.MovementAPCostAdditional) * this.m.CurrentProperties.MovementAPCostMult);
			local fatigueCost = this.Math.round((this.m.FatigueCosts[_tile.Type] + this.m.CurrentProperties.MovementFatigueCostAdditional) * this.m.CurrentProperties.MovementFatigueCostMult);

			local heelHeight = this.getFlags().getAsInt("heelHeight");
			local heelSkill = this.getFlags().getAsInt("heelSkill");
			if (heelHeight > heelSkill)
			{
				local extraHeelFatigue = (heelHeight - heelSkill) * ::Lewd.Const.HeelFatigueMultiplier; // TODO balance this
				fatigueCost = fatigueCost + extraHeelFatigue;
				::logInfo("Applying extra fatigue cost from heels: " + extraHeelFatigue + " (heel height: " + heelHeight + ", heel skill: " + heelSkill + ")");
			}

			if (_levelDifference != 0)
			{
				apCost = apCost + this.m.LevelActionPointCost;
				fatigueCost = fatigueCost + this.m.LevelFatigueCost;

				if (_levelDifference > 0)
				{
					fatigueCost = fatigueCost + this.Const.Movement.LevelClimbingFatigueCost;
				}
			}

			fatigueCost = fatigueCost * this.m.CurrentProperties.FatigueEffectMult;

			if (this.m.ActionPoints >= apCost && this.m.Fatigue + fatigueCost <= this.getFatigueMax())
			{
				this.m.ActionPoints = this.Math.round(this.m.ActionPoints - apCost);
				this.m.Fatigue = this.Math.min(this.getFatigueMax(), this.Math.round(this.m.Fatigue + fatigueCost));
				this.updateVisibility(_tile, this.m.CurrentProperties.getVision(), this.getFaction());

				if (this.getFaction() == this.Const.Faction.PlayerAnimals)
				{
					this.updateVisibility(_tile, this.m.CurrentProperties.getVision(), this.Const.Faction.Player);
				}

				return true;
			}
			else
			{
				return false;
			}
		}
	});

	// hook item container to care about items' cursed status
	mod.hook("scripts/items/item_container", function(q)
	{
		q.unequip = @(__original) function(_item) {
			 // check item flags for cursed, if cursed, don't unequip and maybe show some kind of message about the item being cursed
			 if (_item != null && _item.getFlags().has("cursed"))
			 {
				if ("onRemoveWhileCursed" in _item) {
					_item.onRemoveWhileCursed();
				}
				 // TODO add some kind of message about the item being cursed and not unequipping
				 return false;
			 }
			 return __original(_item);
		};
	});

	local gt = this.getroottable();

	// new perk names
	// TODO add new perks
	// gt.Const.Strings.PerkName.VampireAncientWisdom <- "Ancient Wisdom";
	// gt.Const.Strings.PerkName.VampireMaintenance <- "Maintenance";
	// gt.Const.Strings.PerkName.VampireDarkflight <- "Darkflight";
	// gt.Const.Strings.PerkName.VampireVileWeaponry <- "Vile Weaponry";
	// gt.Const.Strings.PerkName.VampireApexPredator <- "Apex Predator";
	// gt.Const.Strings.PerkName.VampireDemoralise <- "Demoralise";

	// new perk descriptions
	// gt.Const.Strings.PerkDescription.VampireAncientWisdom <- "Receive a [color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] damage reduction from all attacks per level, [color=" + this.Const.UI.Color.NegativeValue + "]up to a maximum of level 12[/color], in addition to your current damage reductions. Additionally, gain [color=" + this.Const.UI.Color.PositiveValue + "]+30%[/color] extra maximum health.";
	// gt.Const.Strings.PerkDescription.VampireMaintenance <- "Gain [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] damage dealt for \'ancient weapons\', such as the Khopesh, Brass cleaver and Rhomphaia.\n In addition to this, \'named\' and \'decorated\' variants cost [color=" + this.Const.UI.Color.PositiveValue + "]-5[/color] fatigue to attack with.\n All equipped ancient weapons mend their durability by [color=" + this.Const.UI.Color.PositiveValue + "]+3-5[/color] per killing blow.";
	// gt.Const.Strings.PerkDescription.VampireDarkflight <- "Traverse [color=" + this.Const.UI.Color.PositiveValue + "]4[/color] tiles distance with no terrain penalty.\n [color=" + this.Const.UI.Color.NegativeValue + "]You cannot land if the target tile is obstructed or undiscovered.[/color]\n Reduces the resolve of any enemy adjacent by [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color]. Stackable with similar types of effects";
	// gt.Const.Strings.PerkDescription.VampireVileWeaponry <- "Upon hitting a bleeding enemy, apply a poison that reduces their melee and ranged skill by [color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] and initiative by [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] for each hit. This effect stacks multiple times but expires quickly.";
	// gt.Const.Strings.PerkDescription.VampireApexPredator <- "When in battle at night, gain [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] fatigue recovery per turn [color=" + this.Const.UI.Color.PositiveValue + "]+2[/color] vision, [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] melee skill, [color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] melee defence and [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] ranged skill.\n\n [color=" + this.Const.UI.Color.NegativeValue + "]Does not apply during daytime.[/color]";
	// gt.Const.Strings.PerkDescription.VampireDemoralise <- "Target an enemy and attack their resolve. If this attack succeeds, they will lose resolve and be stunned for 1 turn.\n [color=" + this.Const.UI.Color.NegativeValue + "]Uses ranged skill to hit and does not work on entities that cannot flee.[/color]";

	// local perkDefObjects = [
	// 	{
	// 		ID = "perk.vampire_ancient_wisdom",
	// 		Script = "scripts/skills/perks/perk_vampire_ancient_wisdom",
	// 		Name = this.Const.Strings.PerkName.VampireAncientWisdom,
	// 		Tooltip = this.Const.Strings.PerkDescription.VampireAncientWisdom,
	// 		Icon = "ui/perks/vampire_ancient_wisdom.png",
	// 		IconDisabled = "ui/perks/vampire_ancient_wisdom_bw.png",
	// 		Const = "VampireAncientWisdom"
	// 	},
	// 	{
	// 		ID = "perk.vampire_apex_predator",
	// 		Script = "scripts/skills/perks/perk_vampire_apex_predator",
	// 		Name = this.Const.Strings.PerkName.VampireApexPredator,
	// 		Tooltip = this.Const.Strings.PerkDescription.VampireApexPredator,
	// 		Icon = "ui/perks/vampire_apex_predator.png",
	// 		IconDisabled = "ui/perks/vampire_apex_predator_bw.png",
	// 		Const = "VampireApexPredator"
	// 	},
	// 	{
	// 		ID = "perk.vampire_maintenance",
	// 		Script = "scripts/skills/perks/perk_vampire_maintenance",
	// 		Name = this.Const.Strings.PerkName.VampireMaintenance,
	// 		Tooltip = this.Const.Strings.PerkDescription.VampireMaintenance,
	// 		Icon = "ui/perks/vampire_maintenance.png",
	// 		IconDisabled = "ui/perks/vampire_maintenance_bw.png",
	// 		Const = "VampireMaintenance"
	// 	},
	// 	{
	// 		ID = "perk.vampire_vile_weaponry",
	// 		Script = "scripts/skills/perks/perk_vampire_vile_weaponry",
	// 		Name = this.Const.Strings.PerkName.VampireVileWeaponry,
	// 		Tooltip = this.Const.Strings.PerkDescription.VampireVileWeaponry,
	// 		Icon = "ui/perks/vampire_vile_weaponry.png",
	// 		IconDisabled = "ui/perks/vampire_vile_weaponry_bw.png",
	// 		Const = "VampireVileWeaponry"
	// 	},
	// 	{
	// 		ID = "perk.vampire_darkflight",
	// 		Script = "scripts/skills/perks/perk_vampire_darkflight",
	// 		Name = this.Const.Strings.PerkName.VampireDarkflight,
	// 		Tooltip = this.Const.Strings.PerkDescription.VampireDarkflight,
	// 		Icon = "ui/perks/vampire_darkflight.png",
	// 		IconDisabled = "ui/perks/vampire_darkflight_bw.png",
	// 		Const = "VampireDarkflight"
	// 	},
	// 	{
	// 		ID = "perk.vampire_demoralise",
	// 		Script = "scripts/skills/perks/perk_vampire_demoralise",
	// 		Name = this.Const.Strings.PerkName.VampireDemoralise,
	// 		Tooltip = this.Const.Strings.PerkDescription.VampireDemoralise,
	// 		Icon = "ui/perks/vampire_demoralise.png",
	// 		IconDisabled = "ui/perks/vampire_demoralise_bw.png",
	// 		Const = "VampireDemoralise"
	// 	}
	// ];
	// gt.Const.Perks.addPerkDefObjects(perkDefObjects);

	// gt.Const.Perks.HemovoreTree <- {
	// 	ID = "HemovoreTree",
	// 	Name = "Hemovore"
	// 	Descriptions = [
	// 		"Hemovore"
	// 	],
	// 	Tree = [
	// 		[gt.Const.Perks.PerkDefs.VampireAncientWisdom], //1
	// 		[gt.Const.Perks.PerkDefs.VampireMaintenance], //2
	// 		[], //3
	// 		[gt.Const.Perks.PerkDefs.VampireDarkflight], //4
	// 		[gt.Const.Perks.PerkDefs.VampireVileWeaponry], //5
	// 		[gt.Const.Perks.PerkDefs.VampireApexPredator], //6
	// 		[] //7 gt.Const.Perks.PerkDefs.VampireDemoralise
	// 	]
	// };

	foreach (dir in [
		"mod_lewd/lib",
	]) {
		foreach (file in ::IO.enumerateFiles(dir))
			::include(file);
	}
});