// Orc Claim -- active skill granted by orc_lewd_racial
// Orc masturbates and cums on target to mark them as claimed
// Costs 4 AP, triggers orc's own climax (full effect including stun)
// Hidden from player UI, AI-only
this.orc_claim_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.orc_claim";
		this.m.Name = "Claim";
		this.m.Description = "Mark a target by cumming on them, claiming them as your own.";
		this.m.Icon = "skills/lewd_restrain.png";
		this.m.IconDisabled = "skills/lewd_restrain_bw.png";
		this.m.Overlay = "";
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
		this.m.ActionPointCost = ::Lewd.Const.OrcClaimAP;
		this.m.FatigueCost = ::Lewd.Const.OrcClaimFatigue;
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
		if (actor.getActionPoints() < this.m.ActionPointCost) return false;

		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
		local target = _targetTile.getEntity();
		if (target == null) return false;

		local user = _originTile.getEntity();

		// Target must be female with PleasureMax
		if (target.getGender() != 1) return false;
		if (target.getPleasureMax() <= 0) return false;

		// Target must not be allied
		if (user != null && user.isAlliedWith(target)) return false;

		// Target must not already be claimed
		if (target.getSkills().hasSkill("effects.orc_claimed"))
			return false;

		// Orc must not already have an active claim on a living target
		if (user != null && user.getFlags().has("lewdOrcClaimTarget"))
		{
			local existingID = user.getFlags().getAsInt("lewdOrcClaimTarget");
			if (existingID >= 0)
			{
				local existing = this.Tactical.getEntityByID(existingID);
				if (existing != null && existing.isAlive())
					return false;
			}
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;

		this.Tactical.EventLog.log(
			this.Const.UI.getColorizedEntityName(_user) + " masturbates furiously at " +
			this.Const.UI.getColorizedEntityName(target) + "!");

		// Point LastPleasureSourceID at the target so climax_effect handles
		// both the claim (via applyOrcClaim) and cum visuals (via cum facial logic)
		_user.m.LastPleasureSourceID = target.getID();
		_user.onClimax();

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
				icon = "ui/icons/action_points.png",
				text = "Costs [color=" + neg + "]" + ::Lewd.Const.OrcClaimAP + "[/color] Action Points"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Marks target as [color=" + neg + "]claimed[/color]"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Orc [color=" + neg + "]climaxes[/color] from the act"
			}
		];
	}
});
