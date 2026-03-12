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
		this.m.IsDoubleGrippable = true;
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
		this._updateDynamicStats();
		local result = this.weapon.getTooltip();
		local actor = this.getContainer() != null ? this.getContainer().getActor() : null;

		if (actor != null)
		{
			local allure = actor.getCurrentProperties().getAllure();
			local climaxes = actor.getFlags().getAsInt("lewdPartnerClimaxes");

			local allureBonus = this.Math.floor(allure * ::Lewd.Const.TailAllureDamageScale);
			if (allureBonus > 0)
			{
				result.push({
					id = 60,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "Damage includes [color=" + this.Const.UI.Color.PositiveValue + "]+" + allureBonus + "[/color] from [color=" + this.Const.UI.Color.PositiveValue + "]" + allure + "[/color] Allure"
				});
			}

			if (climaxes > 0)
			{
				local armorPenBonus = this.Math.floor(::Lewd.Const.TailDirectDamageMultBonus * (climaxes * 1.0 / (climaxes + ::Lewd.Const.TailDirectDamageClimaxHalf)) * 100);
				local headHitBonus = this.Math.floor(::Lewd.Const.TailHeadHitChanceBonus * (climaxes * 1.0 / (climaxes + ::Lewd.Const.TailHeadHitClimaxHalf)));
				result.push({
					id = 61,
					type = "text",
					icon = "ui/icons/direct_damage.png",
					text = "Armor penetration includes [color=" + this.Const.UI.Color.PositiveValue + "]+" + armorPenBonus + "%[/color] from climaxes dealt (" + climaxes + ")"
				});
				if (headHitBonus > 0)
				{
					result.push({
						id = 62,
						type = "text",
						icon = "ui/icons/chance_to_hit_head.png",
						text = "Head hit chance includes [color=" + this.Const.UI.Color.PositiveValue + "]+" + headHitBonus + "%[/color] from climaxes dealt"
					});
				}
			}

			local pleasure = this.Math.floor(allure * ::Lewd.Const.TailPleasureScale);
			if (pleasure > 0)
			{
				result.push({
					id = 63,
					type = "text",
					icon = "ui/icons/pleasure.png",
					text = "Deals [color=" + this.Const.UI.Color.PositiveValue + "]" + pleasure + "[/color] pleasure on hit"
				});
			}

			result.push({
				id = 64,
				type = "text",
				icon = "ui/icons/morale.png",
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

	function _updateDynamicStats()
	{
		local actor = this.getContainer() != null ? this.getContainer().getActor() : null;

		// Bake allure into weapon damage range
		this.m.RegularDamage = ::Lewd.Const.TailBaseDamageMin;
		this.m.RegularDamageMax = ::Lewd.Const.TailBaseDamageMax;

		// Bake climax scaling into direct damage mult and head hit chance
		this.m.DirectDamageMult = ::Lewd.Const.TailDirectDamageMultBase;
		this.m.ChanceToHitHead = 0;

		if (actor != null)
		{
			local allure = actor.getCurrentProperties().getAllure();
			local bonus = this.Math.floor(allure * ::Lewd.Const.TailAllureDamageScale);
			this.m.RegularDamage += bonus;
			this.m.RegularDamageMax += bonus;

			local climaxes = actor.getFlags().getAsInt("lewdPartnerClimaxes");
			if (climaxes > 0)
			{
				this.m.DirectDamageMult += ::Lewd.Const.TailDirectDamageMultBonus * (climaxes * 1.0 / (climaxes + ::Lewd.Const.TailDirectDamageClimaxHalf));
				this.m.ChanceToHitHead = this.Math.floor(::Lewd.Const.TailHeadHitChanceBonus * (climaxes * 1.0 / (climaxes + ::Lewd.Const.TailHeadHitClimaxHalf)));
			}
		}
	}

	function onUpdateProperties( _properties )
	{
		this._updateDynamicStats();
		this.weapon.onUpdateProperties(_properties);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/tail_lash_skill"));
		this.addSkill(this.new("scripts/skills/actives/whip_into_shape_skill"));
		this.addSkill(this.new("scripts/skills/actives/playful_slap_skill"));
	}
});
