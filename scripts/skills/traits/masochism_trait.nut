// Base class for masochism traits (Likes Pain / Masochist / Pain Slut)
// Children set config values in create()
this.masochism_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		DefensePenalty = 0,
		NegStatusDuration = 0,
		DamageReductionMult = 1.0,
		DamageReductionPct = 100,       // display value for tooltip (e.g. 80 for 80%)
		PleasureFromDamageRate = 0.0,
		PleasureFromDamagePct = 0,       // display value for tooltip (e.g. 10 for 10%)
		AllureBonus = 0,
		PleasureMaxBonus = 0,
		HasPhysicalResist = false,
		HasStunImmunity = false,
		HeadBrush = "",
		HasBodyPiercing = false,
		DamageLogText = ""
	},
	function create()
	{
		this.character_trait.create();
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
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
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Does not lose morale from losing hitpoints"
			},
			{
				id = 17,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Increases duration of negative status effects by " + this.m.NegStatusDuration + " turn" + (this.m.NegStatusDuration > 1 ? "s" : "")
			},
			{
				id = 18,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.DefensePenalty + "[/color] Melee Defense"
			},
			{
				id = 19,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.DefensePenalty + "[/color] Ranged Defense"
			},
			{
				id = 20,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.DefensePenalty + "[/color] Allure"
			},
			{
				id = 21,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Only receive [color=" + this.Const.UI.Color.PositiveValue + "] " + this.m.DamageReductionPct + "%[/color] of any damage to hitpoints from attacks (stacks with other sources)"
			}
		];

		if (this.m.HasPhysicalResist)
		{
			result.push({
				id = 22,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Gains resistance against physical status effects"
			});
		}

		if (this.m.HasStunImmunity)
		{
			result.push({
				id = 23,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Gains immunity against stuns"
			});
		}

		result.push({
			id = 24,
			type = "text",
			icon = "ui/icons/pleasure.png",
			text = "Converts [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.PleasureFromDamagePct + "%[/color] of hitpoint damage received into pleasure"
		});

		return result;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
		{
			return;
		}

		_properties.DamageReceivedRegularMult *= this.m.DamageReductionMult;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();

		local piercing_head = actor.addSprite("piercing_head");
		piercing_head.setBrush(this.m.HeadBrush);
		piercing_head.Visible = true;

		if (this.m.HasBodyPiercing)
		{
			local piercing_body = actor.addSprite("piercing_body");
			piercing_body.setBrush("plug_nipple");
			piercing_body.Visible = true;
		}

		actor.setDirty(true);

		// Endurance perk tree (requires Delicate)
		local bg = actor.getBackground();
		if (bg != null && actor.getSkills().hasSkill("trait.delicate") && !bg.hasPerkGroup(::Const.Perks.EnduranceTree))
			bg.addPerkGroup(::Const.Perks.EnduranceTree.Tree);
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		local piercing_head = actor.getSprite("piercing_head");
		piercing_head.setBrush("");

		if (this.m.HasBodyPiercing)
		{
			local piercing_body = actor.getSprite("piercing_body");
			piercing_body.setBrush("");
		}

		actor.setDirty(true);
	}

	function onUpdate( _properties )
	{
		_properties.RangedDefense -= this.m.DefensePenalty;
		_properties.MeleeDefense -= this.m.DefensePenalty;
		_properties.NegativeStatusEffectDuration += this.m.NegStatusDuration;
		_properties.IsAffectedByLosingHitpoints = false;

		if (this.m.HasPhysicalResist)
			_properties.IsResistantToPhysicalStatuses = true;

		if (this.m.HasStunImmunity)
			_properties.IsImmuneToStun = true;

		_properties.Allure += this.m.AllureBonus;
		_properties.PleasureMax += this.m.PleasureMaxBonus;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints > 0)
		{
			local actor = this.getContainer().getActor();
			if (actor.getPleasureMax() > 0)
			{
				local rate = this.m.PleasureFromDamageRate;
				if (actor.getSkills().hasSkill("perk.lewd_pain_feeds_pleasure"))
					rate *= ::Lewd.Const.PainFeedsPleasureMult;
				local gain = this.Math.max(1, this.Math.floor(_damageHitpoints * rate));
				actor.addPleasure(gain);
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " " + this.m.DamageLogText + " (+" + gain + " pleasure)");
			}
		}
	}
});
