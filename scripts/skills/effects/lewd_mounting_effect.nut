// Applied to the MOUNTER (the one on top / the dominant position)
this.lewd_mounting_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TargetID = 0,
		IsRemoving = false
	},
	function create()
	{
		this.m.ID = "effects.lewd_mounting";
		this.m.Name = "Mounting";
		this.m.Description = "You are on top of someone, holding the dominant position.";
		this.m.Icon = "skills/lewd_mounting.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function setTarget( _entityID )
	{
		this.m.TargetID = _entityID;
	}

	function getTargetID()
	{
		return this.m.TargetID;
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
				icon = "ui/icons/special.png",
				text = "Cannot move while mounting (rooted)"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Sex abilities that require mounting are available"
			}
		];
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();

		// Swap icon for male actors — show female-underneath perspective
		if (actor.getGender() != 1)
		{
			this.m.Icon = "skills/lewd_mounted.png";
		}

		if (actor.isPlacedOnMap())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " mounts their target!");
		}
	}

	function onUpdate( _properties )
	{
		_properties.IsRooted = true;
	}

	function onDeath( _fatalityType )
	{
		// Mounter died — notify the target immediately
		local target = this.Tactical.getEntityByID(this.m.TargetID);
		if (target != null && target.isAlive() && target.getSkills().hasSkill("effects.lewd_mounted"))
		{
			local mounted = target.getSkills().getSkillByID("effects.lewd_mounted");
			local actor = this.getContainer().getActor();
			mounted.removeMounter(actor.getID());
		}
	}

	function onRemoved()
	{
		// Notify the target that this mounter is gone
		local target = this.Tactical.getEntityByID(this.m.TargetID);
		if (target != null && target.isAlive() && target.getSkills().hasSkill("effects.lewd_mounted"))
		{
			local mounted = target.getSkills().getSkillByID("effects.lewd_mounted");
			local actor = this.getContainer().getActor();
			mounted.removeMounter(actor.getID());
		}
	}

	function onTurnEnd()
	{
		// check if target still has mounted effect
		local target = this.Tactical.getEntityByID(this.m.TargetID);
		if (target == null || !target.isAlive() || target.getHitpoints() <= 0 || !target.getSkills().hasSkill("effects.lewd_mounted"))
		{
			this.removeSelf();
		}
	}

});
