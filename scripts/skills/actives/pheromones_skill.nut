this.pheromones_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.pheromones";
		this.m.Name = "Pheromones";
		this.m.Description = "Release intoxicating pheromones that enhance your alluring presence, boosting Entrancing Beauty\'s daze chance.";
		this.m.Icon = "skills/pheromones.png";
		this.m.IconDisabled = "skills/pheromones_bw.png";
		this.m.Overlay = "pheromones";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_charm_kiss_01.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_02.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_03.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.NonTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = ::Lewd.Const.PheromonesAPCost;
		this.m.FatigueCost = ::Lewd.Const.PheromonesFatigueCost;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
		local ret = [
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Boosts Entrancing Beauty daze chance by [color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.PheromonesAllureBonus + "[/color] for [color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.PheromonesDuration + "[/color] turns"
			}
		];
		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.pheromones");
	}

	function onUse( _user, _targetTile )
	{
		if (!this.getContainer().hasSkill("effects.pheromones"))
		{
			this.m.Container.add(this.new("scripts/skills/effects/pheromones_effect"));
			return true;
		}

		return false;
	}
});
