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
				text = "Chance to inflict \'Dazed\' (or on crit \'Stunned\') to those engaged in melee with chance scaling with [color=" + this.Const.UI.Color.PositiveValue + "]Allure (" + allure + ")[/color] contested by their resolve"
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
			// if (!entity.isAlliedWith(actor) && entity.getTile().getDistanceTo(tile) <= 1)
			if (entity.getTile().getDistanceTo(tile) <= 1)
			{
				local resolve = entity.getBravery();
				local chance = (::Lewd.Const.AllureToDazeBaseChance + (allure - resolve) * ::Lewd.Const.AllureToDazeChanceMultiplier); 

				// ::logInfo("Target " + entity.getName() + " bravery: " + resolve);
				// ::logInfo("Chance to daze " + entity.getName() + ": " + chance + "%");
				local roll = this.Math.rand(0, 100);

				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(entity) + " beholds " +this.Const.UI.getColorizedEntityName(actor) + "'s beauty " + " (Chance: " + chance + ", Rolled: " + roll + ") (" + allure + " allure vs " + resolve + " bravery)");
				if (roll < chance)
				{
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
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, actor.getPos());
		}
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

