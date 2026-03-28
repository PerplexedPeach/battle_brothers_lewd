this.lewd_corset <- this.inherit("scripts/items/legend_armor/legend_armor_upgrade", {
	m = {},
	function create()
	{
		this.legend_armor_upgrade.create();
		this.m.Type = this.Const.Items.ArmorUpgrades.Plate;
		this.m.ID = "legend_armor.body.lewd_corset";
		this.m.Name = "Black Corset";
		this.m.Description = "A structured corset of serpent leather dyed midnight black, with gold filigree tracing the boning and clasps. It cinches the waist and lifts the bust with an authority that borders on architectural.";
		this.m.ArmorDescription = "A gold-accented black corset.";
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Value = 1500;
		this.m.Condition = 25;
		this.m.ConditionMax = 25;
		this.m.StaminaModifier = -2;
		this.m.IsDroppedAsLoot = true;
	}

	function updateVariant()
	{
		// Plate layer: only needs SpriteBack
		this.m.SpriteBack = "bust_lewd_corset_01";
		this.m.SpriteDamagedBack = "bust_lewd_corset_01_damaged";
		this.m.SpriteCorpseBack = "bust_lewd_corset_01_dead";
		this.m.Icon = "legend_armor/icon_lewd_corset_01.png";
		this.m.IconLarge = "legend_armor/inventory_lewd_corset_01.png";
		this.m.OverlayIcon = "legend_armor/overlay_lewd_corset_01.png";
		this.m.OverlayIconLarge = "legend_armor/inventory_lewd_corset_01.png";
	}

	function getLewdTooltipDetail( _result )
	{
		local C = ::Lewd.Const;
		_result.push({ id = 20, type = "text", icon = "ui/icons/allure.png",
			text = "Allure [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.ClothingAllureCorset + "[/color]"
		});
		_result.push({ id = 21, type = "text", icon = "ui/icons/initiative.png",
			text = "Initiative [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.ClothingCorsetInitiative + "[/color] (posture correction)"
		});
		_result.push({ id = 22, type = "text", icon = "ui/icons/fatigue.png",
			text = "Fatigue Recovery [color=" + this.Const.UI.Color.NegativeValue + "]" + C.ClothingCorsetFatigueRecoveryPenalty + "[/color] per turn (restrictive boning)"
		});
	}

	function getTooltip()
	{
		local result = this.legend_armor_upgrade.getTooltip();
		this.getLewdTooltipDetail(result);
		return result;
	}

	function onArmorTooltip( _result )
	{
		this.legend_armor_upgrade.onArmorTooltip(_result);
		local C = ::Lewd.Const;
		_result.push({ id = 20, type = "text", icon = "ui/icons/special.png",
			text = "Allure +" + C.ClothingAllureCorset + ", Initiative +" + C.ClothingCorsetInitiative + ", Fatigue Recovery " + C.ClothingCorsetFatigueRecoveryPenalty
		});
	}

	function onUpdateProperties( _properties )
	{
		this.legend_armor_upgrade.onUpdateProperties(_properties);
		_properties.Allure += ::Lewd.Const.ClothingAllureCorset;
		_properties.Initiative += ::Lewd.Const.ClothingCorsetInitiative;
		_properties.FatigueRecoveryRate += ::Lewd.Const.ClothingCorsetFatigueRecoveryPenalty;
	}
});
