this.masochism_first <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.m.ID = "trait.masochism_first";
		this.m.Name = "Likes Pain";
		this.m.Description = "You take pleasure in your own suffering, gaining strength from pain.";
		this.m.Icon = "ui/traits/masochism_first_trait.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.Excluded = [
			"trait.masochism_second",
			"trait.masochism_third",
		];
	}

	function getTooltip()
	{
		local actor = this.getContainer().getActor();
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
				text = "Increases duration of negative status effects by 1 turn"
			},
			{
				id = 18,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Melee Defense"
			},
			{
				id = 19,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Ranged Defense"
			},
			{
				id = 20,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Allure"
			},
			{
				id = 21,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Only receive [color=" + this.Const.UI.Color.PositiveValue + "] 80%[/color] of any damage to hitpoints from attacks (stacks with other sources)"
			},
			{
				id = 22,
				type = "text",
				icon = "ui/icons/pleasure.png",
				text = "Converts [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] of hitpoint damage received into pleasure"
			},
		];


		return result;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID() || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
		{
			return;
		}

		_properties.DamageReceivedRegularMult *= 0.8;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();

		local piercing_head = actor.addSprite("piercing_head");
		piercing_head.setBrush("piercing_nose");
		piercing_head.Visible = true;
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
		actor.setDirty(true);
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		_properties.RangedDefense -= 5;
		_properties.MeleeDefense -= 5;
		// less concerned about removing negative status effects
		_properties.NegativeStatusEffectDuration += 1;
		_properties.IsAffectedByLosingHitpoints = false;
		_properties.Allure += ::Lewd.Const.AllureFromMasochismFirst;
		_properties.PleasureMax += ::Lewd.Const.PleasureMaxFromMasochismFirst;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints > 0)
		{
			local actor = this.getContainer().getActor();
			if (actor.getPleasureMax() > 0)
			{
				local rate = ::Lewd.Const.PleasureFromDamageMasochismFirst;
				if (actor.getSkills().hasSkill("perk.lewd_pain_feeds_pleasure"))
					rate *= ::Lewd.Const.PainFeedsPleasureMult;
				local gain = this.Math.max(1, this.Math.floor(_damageHitpoints * rate));
				actor.addPleasure(gain);
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " feels a rush of pleasure from the pain (+" + gain + " pleasure)");
			}
		}
	}
});

