// Horny status effect — applied by sex abilities (50% on hit) and entrancing beauty
// Debuffs: -15 Resolve, -15% Initiative, -5 Melee Defense
// Sex abilities auto-hit horny targets
// Lasts 2 turns, refreshable
this.lewd_horny_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2
	},
	function create()
	{
		this.m.ID = "effects.lewd_horny";
		this.m.Name = "Horny";
		this.m.Icon = "skills/lewd_horny.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Overwhelmed by arousal, unable to focus. Will wear off in [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] turn(s).";
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.HornyResolvePenalty + "[/color] Resolve"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] Initiative"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.HornyMeleeDefPenalty + "[/color] Melee Defense"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Sex abilities [color=" + this.Const.UI.Color.NegativeValue + "]auto-hit[/color] this target"
			}
		];
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();

		// resistance check
		if (actor.getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
		{
			if (!actor.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " resisted becoming horny");
			}
			this.removeSelf();
			return;
		}

		this.m.TurnsLeft = ::Lewd.Const.HornyDuration;
	}

	function onRefresh()
	{
		this.m.TurnsLeft = ::Lewd.Const.HornyDuration;
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += ::Lewd.Const.HornyResolvePenalty;
		_properties.InitiativeMult *= ::Lewd.Const.HornyInitiativeMult;
		_properties.MeleeDefense += ::Lewd.Const.HornyMeleeDefPenalty;

		local actor = this.getContainer().getActor();
		if (actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned") && !this.getContainer().hasSkill("effects.dazed"))
		{
			actor.getSprite("status_stunned").setBrush("bust_dazed");
			actor.getSprite("status_stunned").Visible = true;
			actor.setDirty(true);
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		if (actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned") && !this.getContainer().hasSkill("effects.dazed"))
		{
			actor.getSprite("status_stunned").Visible = false;
		}

		actor.setDirty(true);
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

	function onCombatFinished()
	{
		this.removeSelf();
	}
});
