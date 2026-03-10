this.playful_slap_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.playful_slap";
		this.m.Name = "Playful Slap";
		this.m.Description = "A teasing flick of the tail. Barely hurts, but the lingering supernatural touch can overwhelm the senses and leave the target burning with desire.";
		this.m.KilledString = "Slapped to death";
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
		this.m.InjuriesOnBody = null;
		this.m.InjuriesOnHead = null;
		this.m.DirectDamageMult = 0.1;
		this.m.ActionPointCost = ::Lewd.Const.PlayfulSlapAP;
		this.m.FatigueCost = ::Lewd.Const.PlayfulSlapFatigue;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}

	function getTooltip()
	{
		local actor = this.getContainer().getActor();
		local allure = actor.getCurrentProperties().getAllure();
		local hornyChance = this.Math.min(::Lewd.Const.PlayfulSlapHornyMaxChance, ::Lewd.Const.PlayfulSlapHornyBaseChance + this.Math.floor(allure * ::Lewd.Const.PlayfulSlapHornyAllureScale));

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
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]" + ::Lewd.Const.PlayfulSlapBaseDamage + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + ::Lewd.Const.PlayfulSlapBaseDamageMax + "[/color] damage to hitpoints"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] tiles"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + hornyChance + "%[/color] chance to inflict Horny on hit"
			}
		];

		local pleasure = this.Math.floor(allure * ::Lewd.Const.TailPleasureScale);
		if (pleasure > 0)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts [color=" + this.Const.UI.Color.PositiveValue + "]" + pleasure + "[/color] pleasure on hit"
			});
		}

		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			// Override weapon damage with playful slap's low damage
			_properties.DamageRegularMin = ::Lewd.Const.PlayfulSlapBaseDamage;
			_properties.DamageRegularMax = ::Lewd.Const.PlayfulSlapBaseDamageMax;
		}
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
				target.addPleasure(pleasure, _user);

			// High chance to inflict horny, scaling with allure
			local hornyChance = this.Math.min(::Lewd.Const.PlayfulSlapHornyMaxChance, ::Lewd.Const.PlayfulSlapHornyBaseChance + this.Math.floor(allure * ::Lewd.Const.PlayfulSlapHornyAllureScale));
			if (this.Math.rand(1, 100) <= hornyChance && target.getMoraleState() != this.Const.MoraleState.Ignore)
			{
				if (!target.getSkills().hasSkill("effects.lewd_horny"))
				{
					target.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
					if (!target.isHiddenToPlayer())
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " is aroused by the teasing slap");
				}
			}
		}

		return success;
	}
});
