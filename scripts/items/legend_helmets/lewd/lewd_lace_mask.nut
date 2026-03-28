this.lewd_lace_mask <- this.inherit("scripts/items/legend_helmets/legend_helmet_upgrade", {
	m = {},
	function create()
	{
		this.legend_helmet_upgrade.create();
		this.m.Type = this.Const.Items.HelmetUpgrades.Vanity;
		this.m.ID = "legend_helmet_upgrade.head.lewd_lace_mask";
		this.m.Name = "Lace Mask";
		this.m.Description = "A delicate mask of black lace that veils the eyes without fully blinding. The world beyond becomes a soft blur of shapes and shadows, sharpening every other sense.";
		this.m.ArmorDescription = "A black lace mask.";
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 1000;
		this.m.Condition = 5;
		this.m.ConditionMax = 5;
		this.m.StaminaModifier = 0;
		this.m.Vision = ::Lewd.Const.HeadLaceMaskVision;
		this.m.IsDroppedAsLoot = true;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_lewd_lace_mask_" + variant;
		this.m.SpriteDamaged = "bust_lewd_lace_mask_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_lewd_lace_mask_" + variant + "_dead";
		this.m.Icon = "legend_helmets/icon_lewd_lace_mask_" + variant + ".png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = this.m.Icon;
		this.m.OverlayIconLarge = this.m.OverlayIcon;
	}

	function getTooltip()
	{
		local result = this.legend_helmet_upgrade.getTooltip();
		local C = ::Lewd.Const;
		result.push({ id = 20, type = "text", icon = "ui/icons/allure.png",
			text = "Allure [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.HeadLaceMaskAllure + "[/color]"
		});
		result.push({ id = 21, type = "text", icon = "ui/icons/vision.png",
			text = "Vision [color=" + this.Const.UI.Color.NegativeValue + "]" + C.HeadLaceMaskVision + "[/color]"
		});
		result.push({ id = 22, type = "text", icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]+" + this.Math.floor((C.HeadLaceMaskReceivedPleasureMult - 1.0) * 100) + "%[/color] pleasure received (heightened senses)"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		this.legend_helmet_upgrade.onArmorTooltip(_result);
		_result.push({ id = 20, type = "text", icon = "ui/icons/special.png",
			text = "+" + ::Lewd.Const.HeadLaceMaskAllure + " Allure, " + ::Lewd.Const.HeadLaceMaskVision + " Vision, +" + this.Math.floor((::Lewd.Const.HeadLaceMaskReceivedPleasureMult - 1.0) * 100) + "% pleasure received"
		});
	}

	function onUpdateProperties( _properties )
	{
		this.legend_helmet_upgrade.onUpdateProperties(_properties);
		_properties.Allure += ::Lewd.Const.HeadLaceMaskAllure;
		_properties.ReceivedPleasureMult *= ::Lewd.Const.HeadLaceMaskReceivedPleasureMult;
	}
});
