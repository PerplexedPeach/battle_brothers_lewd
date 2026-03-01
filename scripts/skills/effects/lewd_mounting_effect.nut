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

	function onTurnEnd()
	{
		// check if target still has mounted effect
		local target = this.Tactical.getEntityByID(this.m.TargetID);
		if (target == null || !target.isAlive() || target.getHitpoints() <= 0 || !target.getSkills().hasSkill("effects.lewd_mounted"))
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
		if (this.m.IsRemoving) return;
		this.m.IsRemoving = true;

		local actor = this.getContainer().getActor();
		actor.getSkills().removeByID(this.m.ID);
	}
});
