this.masochism_third <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.m.ID = "trait.masochism_third";
		this.m.Name = "Pain Slut";
		this.m.Description = "You love pain and subjecting yourself to nasty experiences. You are the ultimate masochist.";
		this.m.Icon = "ui/traits/masochism_third_trait.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.Excluded = [
			"trait.masochism_first",
			"trait.masochism_second",
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
				text = "Increases duration of negative status effects by 2 turns"
			},
			{
				id = 18,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] Melee Defense"
			},
			{
				id = 19,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] Ranged Defense"
			},
			{
				id = 20,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Allure"
			},
			{
				id = 21,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Only receive [color=" + this.Const.UI.Color.PositiveValue + "] 50%[/color] of any damage to hitpoints from attacks (stacks with other sources)"
			},
			{
				id = 22,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Gains resistance against physical status effects"
			},
			{
				id = 23,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Gains immunity against stuns"
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

		_properties.DamageReceivedRegularMult *= 0.5;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local tattoo_head = actor.getSprite("tattoo_head");
		tattoo_head.Visible = true;
		tattoo_head.setBrush("piercing_nose_mouth");
		local tattoo_body = actor.getSprite("tattoo_body");
		tattoo_body.Visible = true;
		tattoo_body.setBrush("plug_nipple");
		actor.setDirty(true);
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		local tattoo_head = actor.getSprite("tattoo_head");
		tattoo_head.setBrush("");
		local tattoo_body = actor.getSprite("tattoo_body");
		tattoo_body.setBrush("");
		actor.setDirty(true);
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		_properties.RangedDefense -= 15;
		_properties.MeleeDefense -= 15;
		// less concerned about removing negative status effects
		_properties.NegativeStatusEffectDuration += 2;
		_properties.IsAffectedByLosingHitpoints = false;
		_properties.IsResistantToPhysicalStatuses = true;
		_properties.IsImmuneToStun = true;
	}
});

