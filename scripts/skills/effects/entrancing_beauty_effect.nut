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
			}
		];

		if (actor.getSkills().hasSkill("effects.pheromones"))
		{
			result.push({
				id = 60,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Pheromones active: [color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.PheromonesAllureBonus + "[/color] daze chance bonus"
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

		local hasPheromones = actor.getSkills().hasSkill("effects.pheromones");

		local dazedEntities = [];

		foreach (entity in enemies)
		{
			local resolve = entity.getBravery();
			local distance = entity.getTile().getDistanceTo(tile);
			local chance = ::Lewd.Const.AllureToDazeBaseChance + (allure - resolve) * ::Lewd.Const.AllureToDazeChanceMultiplier - distance * ::Lewd.Const.AllureToDazeDistancePenalty;
			if (hasPheromones)
			{
				chance += ::Lewd.Const.PheromonesAllureBonus;
			}
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

