// Open Invitation — toggle granted by Sensual Focus perk
// When active: +15% pleasure dealt by sex abilities, but enemy sex abilities auto-hit you
// Can only toggle once per turn
this.open_invitation_skill <- this.inherit("scripts/skills/skill", {
	m = {
		ToggledThisTurn = false
	},
	function create()
	{
		this.m.ID = "actives.open_invitation";
		this.m.Name = "Open Invitation";
		this.m.Description = "Toggle: invite the enemy in, increasing pleasure dealt but leaving yourself vulnerable.";
		this.m.Icon = "skills/open_invitation.png";
		this.m.IconDisabled = "skills/open_invitation_bw.png";
		this.m.Overlay = "open_invitation";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.NonTargeted;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
		this.m.IsSerialized = false;
	}

	function isHidden()
	{
		return !this.getContainer().getActor().getSkills().hasSkill("perk.lewd_sensual_focus") || this.skill.isHidden();
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.ToggledThisTurn;
	}

	function isActive()
	{
		return this.getContainer().hasSkill("effects.open_invitation");
	}

	function getName()
	{
		if (this.isActive())
			return "Close Invitation";
		return "Open Invitation";
	}

	function getDescription()
	{
		if (this.isActive())
			return "Withdraw your invitation, returning to normal.";
		return "Invite the enemy in. Your sex abilities deal [color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] more pleasure, but enemy sex abilities [color=" + this.Const.UI.Color.NegativeValue + "]auto-hit[/color] you.";
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		if (this.isActive())
		{
			this.getContainer().removeByID("effects.open_invitation");
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " withdraws their invitation.");
		}
		else
		{
			this.getContainer().add(this.new("scripts/skills/effects/open_invitation_effect"));
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " opens an invitation!");
		}
		this.m.ToggledThisTurn = true;
		return true;
	}

	function onTurnStart()
	{
		this.m.ToggledThisTurn = false;
	}

	function onCombatFinished()
	{
		this.m.ToggledThisTurn = false;
		if (this.isActive())
			this.getContainer().removeByID("effects.open_invitation");
	}

	function getTooltip()
	{
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
			}
		];

		if (this.isActive())
		{
			result.push({
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Currently active[/color] — click to deactivate"
			});
		}
		else
		{
			result.push({
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Currently [color=" + this.Const.UI.Color.NegativeValue + "]inactive[/color] — click to activate"
			});
		}

		if (this.m.ToggledThisTurn)
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Already toggled this turn[/color]"
			});
		}

		return result;
	}
});
