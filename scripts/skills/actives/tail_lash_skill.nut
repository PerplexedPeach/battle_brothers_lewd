this.tail_lash_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.tail_lash";
		this.m.Name = "Tail Lash";
		this.m.Description = "Lash out with your tail, striking a target at range. Weak against heavy armor, but its supernatural edge cuts deep into flesh. Inflicts pleasure and may leave the target aroused.";
		this.m.KilledString = "Lashed to death";
		this.m.Icon = "skills/tail_lash.png";
		this.m.IconDisabled = "skills/tail_lash_bw.png";
		this.m.Overlay = "tail_lash";
		this.m.SoundOnUse = [
			"sounds/combat/whip_01.wav",
			"sounds/combat/whip_02.wav",
			"sounds/combat/whip_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/whip_hit_01.wav",
			"sounds/combat/whip_hit_02.wav",
			"sounds/combat/whip_hit_03.wav",
			"sounds/combat/whip_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = ::Lewd.Const.TailDirectDamageMultBase;
		this.m.ActionPointCost = ::Lewd.Const.TailLashAP;
		this.m.FatigueCost = ::Lewd.Const.TailLashFatigue;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		local actor = this.getContainer().getActor();
		local allure = actor.getCurrentProperties().getAllure();

		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] tiles"
		});

		local pleasure = this.Math.floor(allure * ::Lewd.Const.TailPleasureScale);
		if (pleasure > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts [color=" + this.Const.UI.Color.PositiveValue + "]" + pleasure + "[/color] pleasure on hit"
			});
		}

		ret.push({
			id = 9,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.TailHornyChance + "%[/color] chance to inflict Horny on hit"
		});

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		// Update DirectDamageMult based on partner climaxes so tooltip reflects current value
		local actor = this.getContainer().getActor();
		local climaxes = actor.getFlags().getAsInt("lewdPartnerClimaxes");
		if (climaxes > 0)
			this.m.DirectDamageMult = ::Lewd.Const.TailDirectDamageMultBase + ::Lewd.Const.TailDirectDamageMultBonus * (climaxes.tofloat() / (climaxes + ::Lewd.Const.TailDirectDamageClimaxHalf));
		else
			this.m.DirectDamageMult = ::Lewd.Const.TailDirectDamageMultBase;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local success = this.attackEntity(_user, target);

		if (success && target.isAlive() && !target.isDying())
		{
			local allure = _user.getCurrentProperties().getAllure();

			// Deal pleasure on hit
			local pleasure = this.Math.floor(allure * ::Lewd.Const.TailPleasureScale);
			if (pleasure > 0 && target.getPleasureMax() > 0)
			{
				target.addPleasure(pleasure, _user);
			}

			// Chance to inflict horny
			if (this.Math.rand(1, 100) <= ::Lewd.Const.TailHornyChance && target.getMoraleState() != this.Const.MoraleState.Ignore)
			{
				if (!target.getSkills().hasSkill("effects.lewd_horny"))
				{
					target.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
					if (!target.isHiddenToPlayer())
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " is aroused by the lash");
				}
			}
		}

		return success;
	}
});
