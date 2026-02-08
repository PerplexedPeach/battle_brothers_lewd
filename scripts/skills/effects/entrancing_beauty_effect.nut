this.entrancing_beauty_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.entrancing_beauty";
		this.m.Name = "Entrancing Beauty";
		this.m.Description = "Your beauty enchants those around you, dazing them into submission.";
		this.m.Icon = "ui/perks/allure_effect.png";
		this.m.IconMini = "allure_effect_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

	function getTooltip()
	{
		local allure = this.getContainer().getActor().allure();

		return [
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
			}
		];
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

		foreach (entity in enemies)
		{
			// if (!entity.isAlliedWith(actor) && entity.getTile().getDistanceTo(tile) <= 1)
			if (entity.getTile().getDistanceTo(tile) <= 1)
			{
				local resolve = entity.getBravery();
				local chance = (50 + (allure - resolve) * ::Lewd.Const.AllureToDazeChanceMultiplier); 

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
				}
			}
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

