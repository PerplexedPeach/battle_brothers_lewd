this.whip_into_shape_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.whip_into_shape";
		this.m.Name = "Whip Into Shape";
		this.m.Description = "Crack your tail at an allied companion to snap them out of their funk. Triggers a morale check with high chance of success, but the intimate nature of the lash may leave them flustered.";
		this.m.KilledString = "Whipped to death";
		this.m.Icon = "skills/tail_lash.png";
		this.m.IconDisabled = "skills/tail_lash_bw.png";
		this.m.Overlay = "tail_lash";
		this.m.SoundOnUse = [
			"sounds/combat/whip_01.wav",
			"sounds/combat/whip_02.wav",
			"sounds/combat/whip_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = false;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = ::Lewd.Const.WhipIntoShapeAP;
		this.m.FatigueCost = ::Lewd.Const.WhipIntoShapeFatigue;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
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
				text = "Triggers a morale check on an allied target to rally them"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Fleeing allies are raised to at least Wavering"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] tiles"
			},
			{
				id = 10,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.WhipIntoShapeHornyChance + "%[/color] chance to make the target Horny"
			}
		];
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
			return false;

		local target = _targetTile.getEntity();
		if (target == null)
			return false;

		local user = this.getContainer().getActor();

		// Must be allied
		if (!target.isAlliedWith(user))
			return false;

		// Can't target self
		if (target.getID() == user.getID())
			return false;

		// Target must not already be Confident
		if (target.getMoraleState() >= this.Const.MoraleState.Confident)
			return false;

		// Target must be able to have morale
		if (target.getMoraleState() == this.Const.MoraleState.Ignore)
			return false;

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		if (!target.isHiddenToPlayer() || !_user.isHiddenToPlayer())
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 300, this.onDelayedEffect.bindenv(this), {
				user = _user,
				target = target
			});
		else
			this.onDelayedEffect({
				user = _user,
				target = target
			});

		return true;
	}

	function onDelayedEffect( _data )
	{
		local target = _data.target;
		local user = _data.user;

		// Morale check with high difficulty (almost guaranteed success)
		if (target.getMoraleState() == this.Const.MoraleState.Fleeing)
			target.checkMorale(this.Const.MoraleState.Steady - this.Const.MoraleState.Fleeing, 9000);
		else
			target.checkMorale(10, 9000);

		// Small chance to make ally horny
		if (this.Math.rand(1, 100) <= ::Lewd.Const.WhipIntoShapeHornyChance)
		{
			if (!target.getSkills().hasSkill("effects.lewd_horny") && target.getMoraleState() != this.Const.MoraleState.Ignore)
			{
				target.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
				if (!target.isHiddenToPlayer())
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " is flustered by the lash");
			}
		}
	}
});
