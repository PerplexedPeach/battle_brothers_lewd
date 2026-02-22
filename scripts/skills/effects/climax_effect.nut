this.climax_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 0
	},
	function create()
	{
		this.m.ID = "effects.climax";
		this.m.Name = "Climax";
		this.m.Description = "Overwhelmed by pleasure, leaving them dazed and vulnerable.";
		this.m.Icon = "ui/icons/allure.png";
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
	}

	function setTurns( _turns )
	{
		this.m.TurnsLeft = _turns;
	}

	function getTooltip()
	{
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
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.ClimaxAPPenalty + "[/color] Action Points"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.ClimaxMeleeDefensePenalty + "[/color] Melee Defense"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.ClimaxInitiativePenalty + "[/color] Initiative"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.ClimaxResolveBonus + "[/color] Resolve"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.ClimaxAllureBonus + "[/color] Allure"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Turns remaining: [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color]"
			}
		];
	}

	function onAdded()
	{
		this.m.TurnsLeft = ::Lewd.Const.ClimaxDuration;
		local actor = this.getContainer().getActor();

		if (actor.isPlacedOnMap())
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill, actor.getPos());
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " reaches climax!");
		}
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints += ::Lewd.Const.ClimaxAPPenalty;
		_properties.MeleeDefense += ::Lewd.Const.ClimaxMeleeDefensePenalty;
		_properties.Initiative += ::Lewd.Const.ClimaxInitiativePenalty;
		_properties.Bravery += ::Lewd.Const.ClimaxResolveBonus;
		_properties.Allure += ::Lewd.Const.ClimaxAllureBonus;
	}

	function onTurnEnd()
	{
		this.m.TurnsLeft -= 1;
		if (this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

	function onCombatFinished()
	{
		this.removeSelf();
	}

	function removeSelf()
	{
		local actor = this.getContainer().getActor();
		actor.getSkills().removeByID(this.m.ID);
	}
});
