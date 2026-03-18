// Goblin Restrain — active skill granted by goblin_lewd_racial
// Goblins can restrain a target that has the climax status effect
// Costs all remaining AP (min GoblinRestrainMinAP), applies lewd_restrained_effect
this.goblin_restrain_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.goblin_restrain";
		this.m.Name = "Pin Down";
		this.m.Description = "Grab hold of a climaxing target and pin them to the ground.";
		this.m.Icon = "skills/lewd_restrain.png";
		this.m.IconDisabled = "skills/lewd_restrain_bw.png";
		this.m.Overlay = "lewd_restrain";
		this.m.SoundOnUse = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = ::Lewd.Const.GoblinRestrainMinAP;
		this.m.FatigueCost = ::Lewd.Const.GoblinRestrainFatigue;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function isHidden()
	{
		return true;
	}

	function isUsable()
	{
		// Can't use this.skill.isUsable() because it checks !isHidden()
		// and this skill is hidden from the player UI
		if (!this.m.IsUsable) return false;
		local actor = this.getContainer().getActor();
		if (!actor.getCurrentProperties().IsAbleToUseSkills) return false;
		if (actor.getActionPoints() < ::Lewd.Const.GoblinRestrainMinAP) return false;

		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
		local target = _targetTile.getEntity();
		if (target == null) return false;

		// Target must have climax effect
		if (!target.getSkills().hasSkill("effects.climax"))
			return false;

		// Target not already restrained
		if (target.getSkills().hasSkill("effects.lewd_restrained"))
			return false;

		// Target not immune to root
		if (target.getCurrentProperties().IsImmuneToRoot)
			return false;

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;

		// Spend all remaining AP
		local apLeft = _user.getActionPoints() - ::Lewd.Const.GoblinRestrainMinAP;
		if (apLeft > 0)
			_user.setActionPoints(_user.getActionPoints() - apLeft);

		::logInfo("[goblin_restrain] " + _user.getName() + " pins down " + target.getName());
		target.getSkills().add(this.new("scripts/skills/effects/lewd_restrained_effect"));

		// Add gang-up effect to target if not present
		if (!target.getSkills().hasSkill("effects.goblin_gang_up"))
			target.getSkills().add(this.new("scripts/skills/effects/goblin_gang_up_effect"));

		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " pins down " + this.Const.UI.getColorizedEntityName(target) + "!");

		return true;
	}

	function getTooltip()
	{
		local neg = this.Const.UI.Color.NegativeValue;
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
				id = 3,
				type = "text",
				text = "Costs [color=" + neg + "]all remaining AP[/color]"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Target is [color=" + neg + "]rooted[/color] in place"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Requires target to be [color=" + neg + "]climaxing[/color]"
			}
		];
	}
});
