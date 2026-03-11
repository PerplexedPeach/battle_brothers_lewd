this.tail_whip <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.tail_whip";
		this.m.Name = "Spaded Tail";
		this.m.Description = "A long, sinuous tail ending in a spade-shaped tip. Deceptively strong, it can lash out with surprising reach and force. In the hands of its owner, it is as much a weapon as it is a mark of her nature.";
		this.m.Categories = "Tail, One-Handed";
		this.m.IconLarge = "weapons/tail_whip_icon_large.png";
		this.m.Icon = "weapons/tail_whip_icon.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDroppedAsLoot = false;
		this.m.IsDoubleGrippable = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_tail_whip";
		this.m.Condition = 1;
		this.m.ConditionMax = 1;
		this.m.StaminaModifier = 0;
		this.m.Value = 6969;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = ::Lewd.Const.TailBaseDamageMin;
		this.m.RegularDamageMax = ::Lewd.Const.TailBaseDamageMax;
		this.m.ArmorDamageMult = ::Lewd.Const.TailArmorDamageMult;
		this.m.DirectDamageMult = ::Lewd.Const.TailDirectDamageMultBase;
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();
		local actor = this.getContainer() != null ? this.getContainer().getActor() : null;

		if (actor != null)
		{
			local allure = actor.getCurrentProperties().getAllure();
			local bonus = this.Math.floor(allure * ::Lewd.Const.TailAllureDamageScale);
			if (bonus > 0)
			{
				result.push({
					id = 60,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Allure adds [color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "[/color] damage (from [color=" + this.Const.UI.Color.PositiveValue + "]" + allure + "[/color] Allure)"
				});
			}

			local climaxes = actor.getFlags().getAsInt("lewdPartnerClimaxes");
			local directMult = ::Lewd.Const.TailDirectDamageMultBase;
			if (climaxes > 0)
				directMult += ::Lewd.Const.TailDirectDamageMultBonus * (climaxes * 1.0 / (climaxes + ::Lewd.Const.TailDirectDamageClimaxHalf));
			local directPct = this.Math.floor(directMult * 100);
			result.push({
				id = 61,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Direct damage: [color=" + this.Const.UI.Color.PositiveValue + "]" + directPct + "%[/color] (scales with climaxes dealt: " + climaxes + ")"
			});

			local pleasure = this.Math.floor(allure * ::Lewd.Const.TailPleasureScale);
			if (pleasure > 0)
			{
				result.push({
					id = 62,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Deals [color=" + this.Const.UI.Color.PositiveValue + "]" + pleasure + "[/color] pleasure on hit"
				});
			}

			result.push({
				id = 63,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.TailHornyChance + "%[/color] chance to inflict Horny on hit"
			});
		}

		result.push({
			id = 70,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "A natural weapon. Cannot be unequipped or dropped."
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);

		local actor = this.getContainer() != null ? this.getContainer().getActor() : null;
		if (actor != null)
		{
			local allure = actor.getCurrentProperties().getAllure();
			local bonus = this.Math.floor(allure * ::Lewd.Const.TailAllureDamageScale);
			_properties.DamageRegularMin += bonus;
			_properties.DamageRegularMax += bonus;
		}
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/tail_lash_skill"));
		this.addSkill(this.new("scripts/skills/actives/whip_into_shape_skill"));
		this.addSkill(this.new("scripts/skills/actives/playful_slap_skill"));
	}
});
