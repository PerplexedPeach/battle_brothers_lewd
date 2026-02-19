this.entrancing_beauty_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.entrancing_beauty";
		this.m.Name = "Entrancing Beauty";
		this.m.Description = "Your beauty enchants those around you, dazing them into submission.";
		this.m.Icon = "ui/perks/allure_effect.png";
		// this.m.IconMini = "allure";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_charm_kiss_01.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_02.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_03.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_04.wav"
		];
		// this.m.SoundOnHit = [
		// 	"sounds/enemies/dlc2/hexe_charm_chimes_01.wav",
		// 	"sounds/enemies/dlc2/hexe_charm_chimes_02.wav",
		// 	"sounds/enemies/dlc2/hexe_charm_chimes_03.wav",
		// 	"sounds/enemies/dlc2/hexe_charm_chimes_04.wav"
		// ];
	}

	function getTooltip()
	{
		local actor = this.getContainer().getActor();
		local allure = actor.allure();
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Chance to inflict \'Dazed\' (or on crit \'Stunned\') around you with chance scaling with [color=" + this.Const.UI.Color.PositiveValue + "]Allure (" + allure + ")[/color] and distance contested by their resolve."
			},
			{
				id = 17,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "Allure increases with melee defense as it represents your agility. It also is influenced by various traits and items. Events can also influence your base allure (" + actor.getFlags().getAsInt("allureBase") + "). Wearing armor and a shield will reduce allure."
			}
		];

		local headPenalty = ::Lewd.Allure.penaltyFromHead(actor);
		local bodyPenalty = ::Lewd.Allure.penaltyFromBody(actor);
		local offhandPenalty = ::Lewd.Allure.penaltyFromOffhand(actor);

		if (headPenalty > 0)
		{
			result.push({
				id = 18,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Allure penalty from head: [color=" + this.Const.UI.Color.NegativeValue + "]" + headPenalty + "[/color] (every point of fatigue reduces allure by " + ::Lewd.Const.AllurePenaltyHeadFatigue + ")"
			});
		}
		if (bodyPenalty > 0)
		{
			result.push({
				id = 19,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Allure penalty from body: [color=" + this.Const.UI.Color.NegativeValue + "]" + bodyPenalty + "[/color] (every point of fatigue reduces allure by " + ::Lewd.Const.AllurePenaltyBodyFatigue + ")"
			});
		}
		if (offhandPenalty > 0)
		{
			result.push({
				id = 20,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Allure penalty from offhand: [color=" + this.Const.UI.Color.NegativeValue + "]" + offhandPenalty + "[/color] (every point of fatigue reduces allure by " + ::Lewd.Const.AllurePenaltyOffhandFatigue + ")"
			});
		}
		// show additional sources of allure

		local skills = actor.getSkills();
		if (skills.hasSkill("trait.legend_seductive"))
		{
			result.push({
				id = 21,
				type = "text",
				icon = "ui/traits/trait_seductive.png",
				text = "Seductive allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]10[/color]"
			});
		}
		if (skills.hasSkill("trait.athletic"))
		{
			result.push({
				id = 22,
				type = "text",
				icon = "ui/traits/trait_icon_21.png",
				text = "Athletic allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]5[/color]"
			});
		}
		if (skills.hasSkill("trait.dainty"))
		{
			result.push({
				id = 23,
				type = "text",
				icon = "ui/traits/dainty_trait.png",
				text = "Dainty allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]5[/color]"
			});
		}
		if (skills.hasSkill("trait.delicate"))
		{
			result.push({
				id = 24,
				type = "text",
				icon = "ui/traits/delicate_trait.png",
				text = "Delicate allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]10[/color]"
			});
		}
		if (skills.hasSkill("trait.masochism_first"))
		{
			result.push({
				id = 25,
				type = "text",
				icon = "ui/traits/masochism_first_trait.png",
				text = "Likes pain allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]5[/color]"
			});
		}
		if (skills.hasSkill("effects.masochism_second"))
		{
			result.push({
				id = 26,
				type = "text",
				icon = "ui/traits/masochism_second_trait.png",
				text = "Masochism allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]10[/color]"
			});
		}
		if (skills.hasSkill("effects.masochism_third"))
		{
			result.push({
				id = 27,
				type = "text",
				icon = "ui/traits/masochism_third_trait.png",
				text = "Pain slut allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]15[/color]"
			});
		}
		// bonus from strutting
		local heelSkillBonus = actor.getFlags().getAsInt("heelSkill") * ::Lewd.Const.HeelAllureMultiplier;
		if (heelSkillBonus > 0)
		{
			result.push({
				id = 28,
				type = "text",
				icon = "ui/perks/heels_effect.png",
				text = "Heel skill strut bonus: [color=" + this.Const.UI.Color.PositiveValue + "]" + heelSkillBonus + "[/color]"
			});
		}
		if (skills.hasSkill("trait.gluttonous"))
		{
			result.push({
				id = 50,
				type = "text",
				icon = "ui/traits/trait_icon_07.png",
				text = "Gluttonous allure penalty: [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color]"
			});
		}
		if (skills.hasSkill("trait.fat"))
		{
			result.push({
				id = 51,
				type = "text",
				icon = "ui/traits/trait_icon_10.png",
				text = "Fat allure penalty: [color=" + this.Const.UI.Color.NegativeValue + "]-20[/color]"
			});
		}
		if (skills.hasSkill("trait.ailing"))
		{
			result.push({
				id = 52,
				type = "text",
				icon = "ui/traits/trait_icon_59.png",
				text = "Ailing allure penalty: [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color]"
			});
		}
		if (skills.hasSkill("trait.old"))
		{
			result.push({
				id = 53,
				type = "text",
				icon = "skills/status_effect_60.png",
				text = "Old allure penalty: [color=" + this.Const.UI.Color.NegativeValue + "]-20[/color]"
			});
		}


		return result;
	}

	function applyToNeighbors()
	{
		local actor = this.getContainer().getActor();
		if (actor == null || !actor.isPlacedOnMap())
		{
			return;
		}


		local enemies = this.Tactical.Entities.getAllHostilesAsArray();
		local tile = actor.getTile();

		// all enemies within 1 tile get a chance to be dazed based on allure vs resolve
		local targets = this.Tactical.Entities.getAllInstances();
		local allure = actor.allure();

		local dazedEntities = [];

		foreach (entity in enemies)
		{
			local resolve = entity.getBravery();
			local distance = entity.getTile().getDistanceTo(tile);
			local chance = ::Lewd.Const.AllureToDazeBaseChance + (allure - resolve) * ::Lewd.Const.AllureToDazeChanceMultiplier - distance * ::Lewd.Const.AllureToDazeDistancePenalty;
			// if (!entity.isAlliedWith(actor) && entity.getTile().getDistanceTo(tile) <= 1)
			if (chance > 0)
			{
				// ::logInfo("Target " + entity.getName() + " bravery: " + resolve);
				// ::logInfo("Chance to daze " + entity.getName() + ": " + chance + "%");
				local roll = this.Math.rand(0, 100);

				if (roll < chance)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(entity) + " beholds " +this.Const.UI.getColorizedEntityName(actor) + "'s beauty " + " (Chance: " + chance + ", Rolled: " + roll + ") (" + allure + " allure vs " + resolve + " bravery)");
					local daze = this.new("scripts/skills/effects/dazed_effect");
					entity.getSkills().add(daze);
					if (roll < chance - ::Lewd.Const.CritChanceThreshold)
					{
						local stunned = this.new("scripts/skills/effects/stunned_effect");
						entity.getSkills().add(stunned);
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(entity) + " is dazed and stunned!");
					} else
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(entity) + " is dazed!");
					}

					dazedEntities.push(entity);
				}
			}
		}

		if (dazedEntities.len() > 0)
		{
			this.displayDazedEffectsOnSelf();
		}
	}

	function displayDazedEffectsOnSelf()
	{
		local actor = this.getContainer().getActor();

		this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, actor.getPos());

		local tile = actor.getTile();
		// also play slutty visual text above your head
		local skills = actor.getSkills();

		// have different pool of lists to play from depending on your traits
		local masochismChance = 0;
		if (skills.hasSkill("trait.masochism_third"))
		{
			masochismChance = 50;
		}
		else if (skills.hasSkill("trait.masochism_second"))
		{
			masochismChance = 35;
		}
		else if (skills.hasSkill("trait.masochism_first"))
		{
			masochismChance = 20;
		}

		local useMaso = masochismChance > 0 && this.Math.rand(1, 100) <= masochismChance;
		local effectList = useMaso ? ::Lewd.Quote.Maso : ::Lewd.Quote.Charm;
		local effect_to_play = effectList[this.Math.rand(0, effectList.len() - 1)];
		this.Tactical.spawnSpriteEffect(effect_to_play, this.createColor("#ffffff"), tile, this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration + this.m.Delay, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
	}

	function onMovementFinished()
	{
		::logInfo("Entrancing Beauty effect triggered onMovementFinished, applying to neighbors");
		this.applyToNeighbors();
	}

	function onTurnStart()
	{
		::logInfo("Entrancing Beauty effect triggered onTurnStart, applying to neighbors");
		this.applyToNeighbors();
	}
});

