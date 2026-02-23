// Applied to the TARGET being mounted (the one underneath)
this.lewd_mounted_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 0,
		MounterID = 0
	},
	function create()
	{
		this.m.ID = "effects.lewd_mounted";
		this.m.Name = "Mounted";
		this.m.Description = "Someone is on top of you, restricting your movement and making you vulnerable.";
		this.m.Icon = "skills/lewd_mounted.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = false;
	}

	function setMounter( _entityID )
	{
		this.m.MounterID = _entityID;
	}

	function getMounterID()
	{
		return this.m.MounterID;
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
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.MountMeleeDefPenalty + "[/color] Melee Defense"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] Initiative"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]25%[/color] more pleasure received"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Cannot move (rooted)"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Turns remaining: [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color]"
			}
		];
	}

	function onAdded()
	{
		this.m.TurnsLeft = ::Lewd.Const.MountDuration;
		local actor = this.getContainer().getActor();

		if (actor.isPlacedOnMap())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " is mounted!");
		}
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense += ::Lewd.Const.MountMeleeDefPenalty;
		_properties.InitiativeMult *= ::Lewd.Const.MountInitiativeMult;
		_properties.IsRooted = true;
	}

	function onTurnEnd()
	{
		this.m.TurnsLeft -= 1;
		if (this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
		else
		{
			// check if mounter still alive and adjacent
			local mounter = this.Tactical.getEntityByID(this.m.MounterID);
			if (mounter == null || !mounter.isAlive() || mounter.getHitpoints() <= 0)
			{
				this.removeSelf();
			}
		}
	}

	function onCombatFinished()
	{
		this.removeSelf();
	}

	function removeSelf()
	{
		local actor = this.getContainer().getActor();

		// also remove the mounting effect from the mounter
		local mounter = this.Tactical.getEntityByID(this.m.MounterID);
		if (mounter != null && mounter.isAlive())
		{
			mounter.getSkills().removeByID("effects.lewd_mounting");
		}

		if (actor.isPlacedOnMap())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " is no longer mounted.");
		}

		actor.getSkills().removeByID(this.m.ID);
	}
});
