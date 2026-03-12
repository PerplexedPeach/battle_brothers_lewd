// Surrender to Pleasure — sub-gated active ability
// Costs all remaining AP. Applies a buff that boosts self-pleasure received by mounters.
// Requires: being mounted, sub score >= threshold
// Granted/removed dynamically by lewd_subdom_effect based on sub tier
this.surrender_to_pleasure_skill <- this.inherit("scripts/skills/skill", {
	m = {
		LastAPCost = 0
	},
	function create()
	{
		this.m.ID = "actives.surrender_to_pleasure";
		this.m.Name = "Surrender to Pleasure";
		this.m.Description = "Stop resisting and give in to the sensations, making it far more pleasurable for those on top of you.";
		this.m.Icon = "skills/surrender_to_pleasure.png";
		this.m.IconDisabled = "skills/surrender_to_pleasure_bw.png";
		this.m.SoundOnUse = [
			"sounds/long_moans/long_moan_1.wav",
			"sounds/long_moans/long_moan_2.wav",
			"sounds/long_moans/long_moan_3.wav",
			"sounds/long_moans/long_moan_4.wav",
			"sounds/long_moans/long_moan_5.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.NonTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = ::Lewd.Const.SurrenderToPleasureMinAP;
		this.m.FatigueCost = ::Lewd.Const.SurrenderToPleasureFatigueCost;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getActionPointCost()
	{
		local actor = this.getContainer().getActor();
		if (actor == null)
			return ::Lewd.Const.SurrenderToPleasureMinAP;
		this.m.LastAPCost = this.Math.max(::Lewd.Const.SurrenderToPleasureMinAP, actor.getActionPoints());
		return this.m.LastAPCost;
	}

	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		if (actor != null)
			this.m.ActionPointCost = this.Math.max(::Lewd.Const.SurrenderToPleasureMinAP, actor.getActionPoints());
	}

	function isHidden()
	{
		local actor = this.getContainer().getActor();
		// Only visible when mounted
		if (!actor.getSkills().hasSkill("effects.lewd_mounted"))
			return true;
		return false;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
			return false;
		local actor = this.getContainer().getActor();
		// Must be mounted
		if (!actor.getSkills().hasSkill("effects.lewd_mounted"))
			return false;
		// Can't stack
		if (actor.getSkills().hasSkill("effects.surrender_to_pleasure"))
			return false;
		return true;
	}

	function getTooltip()
	{
		local actor = this.getContainer().getActor();
		local apSpent = actor != null ? actor.getActionPoints() : ::Lewd.Const.SurrenderToPleasureMinAP;
		local subScore = actor != null ? ::Lewd.Mastery.getSubScore(actor) : 0;
		local mounterPct = this.Math.floor((apSpent * subScore) / ::Lewd.Const.SurrenderToPleasureMounterDivisor * 100);
		local selfPct = this.Math.floor((apSpent * subScore) / ::Lewd.Const.SurrenderToPleasureSelfDivisor * 100);

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
				id = 5,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Consumes [color=" + this.Const.UI.Color.NegativeValue + "]all[/color] remaining Action Points"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Mounters receive [color=" + this.Const.UI.Color.PositiveValue + "]+" + mounterPct + "%[/color] self-pleasure when using sex abilities on you (scales with AP and submission)"
			}
		];

		if (selfPct > 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "You receive [color=" + this.Const.UI.Color.NegativeValue + "]+" + selfPct + "%[/color] more pleasure (half scaling)"
			});
		}

		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Lasts until the start of your next turn"
		});
		ret.push({
			id = 9,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Requires being [color=" + this.Const.UI.Color.NegativeValue + "]mounted[/color]"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.getSkills().hasSkill("effects.surrender_to_pleasure"))
		{
			local apSpent = this.m.LastAPCost; // cached from getActionPointCost() before engine deducted AP
			local subScore = ::Lewd.Mastery.getSubScore(_user);
			local effect = this.new("scripts/skills/effects/surrender_to_pleasure_effect");
			effect.setParams(apSpent, subScore);
			_user.getSkills().add(effect);
			::logInfo("[surrender_to_pleasure] " + _user.getName() + " surrenders to pleasure (AP:" + apSpent + " sub:" + subScore + " mounterMult:" + effect.getMounterMult() + " selfMult:" + effect.getSelfVulnMult() + ")");

			if (_user.isPlacedOnMap())
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " surrenders to pleasure...");

			return true;
		}
		return false;
	}
});
