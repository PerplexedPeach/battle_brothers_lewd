this.entrancing_beauty_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TriggersThisTurn = 0,
		MaxTriggersPerTurn = 2
	},
	function create()
	{
		this.m.ID = "effects.entrancing_beauty";
		this.m.Name = "Entrancing Beauty";
		this.m.Description = "Your beauty enchants those around you, making them horny and vulnerable.";
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
				text = "Chance to inflict \'Horny\' (or on crit \'Horny + Stunned\') around you with chance scaling with [color=" + this.Const.UI.Color.PositiveValue + "]Allure (" + allure + ")[/color] and distance contested by their resolve."
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
		if (this.m.TriggersThisTurn >= this.m.MaxTriggersPerTurn)
		{
			::logInfo("[beauty] trigger " + (this.m.TriggersThisTurn + 1) + " blocked (max " + this.m.MaxTriggersPerTurn + ")");
			return;
		}

		local actor = this.getContainer().getActor();
		if (actor == null || !actor.isPlacedOnMap())
		{
			return;
		}

		this.m.TriggersThisTurn++;

		local enemies = this.Tactical.Entities.getAllHostilesAsArray();
		local tile = actor.getTile();

		local allure = actor.allure();
		::logInfo("[beauty] " + actor.getName() + " trigger #" + this.m.TriggersThisTurn + " allure:" + allure + " enemies:" + enemies.len());

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

			::logInfo("[beauty]   " + entity.getName() + " dist:" + distance + " resolve:" + resolve + " chance:" + chance + (hasPheromones ? " (pheromones)" : ""));

			if (chance > 0)
			{
				local roll = this.Math.rand(0, 100);
				::logInfo("[beauty]   roll:" + roll + " vs chance:" + chance + " -> " + (roll < chance ? "HIT" : "miss"));

				if (roll < chance)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(entity) + " beholds " + this.Const.UI.getColorizedEntityName(actor) + "'s beauty (roll:" + roll + " chance:" + chance + ")");

					if (!entity.getSkills().hasSkill("effects.lewd_horny"))
					{
						local horny = this.new("scripts/skills/effects/lewd_horny_effect");
						entity.getSkills().add(horny);
					}
					else
					{
						entity.getSkills().getSkillByID("effects.lewd_horny").onRefresh();
					}

					if (roll < chance - ::Lewd.Const.CritChanceThreshold)
					{
						local stunned = this.new("scripts/skills/effects/stunned_effect");
						entity.getSkills().add(stunned);
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(entity) + " becomes horny and is stunned!");
					}
					else
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(entity) + " becomes horny!");
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
		this.applyToNeighbors();
	}

	function onTurnStart()
	{
		this.m.TriggersThisTurn = 0;
		this.applyToNeighbors();
	}
});

