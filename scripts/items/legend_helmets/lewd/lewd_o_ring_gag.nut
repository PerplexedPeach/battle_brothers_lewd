this.lewd_o_ring_gag <- this.inherit("scripts/items/legend_helmets/legend_helmet_upgrade", {
	m = {},
	function create()
	{
		this.legend_helmet_upgrade.create();
		this.m.Type = this.Const.Items.HelmetUpgrades.Top;
		this.m.ID = "legend_helmet_upgrade.head.lewd_o_ring_gag";
		this.m.Name = "O-Ring Gag";
		this.m.Description = "A steel ring held in place by black leather straps, forcing the mouth open. It makes speech impossible and breathing labored, but the vulnerability it creates has its own kind of power.";
		this.m.ArmorDescription = "An o-ring gag.";
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Value = 800;
		this.m.Condition = 10;
		this.m.ConditionMax = 10;
		this.m.StaminaModifier = 0;
		this.m.IsDroppedAsLoot = true;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_lewd_o_ring_gag_" + variant;
		this.m.SpriteDamaged = "bust_lewd_o_ring_gag_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_lewd_o_ring_gag_" + variant + "_dead";
		this.m.Icon = "legend_helmets/icon_lewd_o_ring_gag_" + variant + ".png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = this.m.Icon;
		this.m.OverlayIconLarge = this.m.OverlayIcon;
	}

	function getTooltip()
	{
		local result = this.legend_helmet_upgrade.getTooltip();
		local C = ::Lewd.Const;
		result.push({ id = 20, type = "text", icon = "ui/icons/allure.png",
			text = "Allure [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.HeadORingGagAllure + "[/color]"
		});
		result.push({ id = 21, type = "text", icon = "ui/icons/bravery.png",
			text = "Resolve [color=" + this.Const.UI.Color.NegativeValue + "]" + C.HeadORingGagResolve + "[/color]"
		});
		result.push({ id = 22, type = "text", icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]+" + this.Math.floor((C.HeadORingGagReceivedPleasureMult - 1.0) * 100) + "%[/color] pleasure received"
		});
		result.push({ id = 23, type = "text", icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + C.HeadORingGagOralPleasureBonus + "[/color] oral pleasure dealt and received from force oral"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		this.legend_helmet_upgrade.onArmorTooltip(_result);
		_result.push({ id = 20, type = "text", icon = "ui/icons/special.png",
			text = "+" + ::Lewd.Const.HeadORingGagAllure + " Allure, " + ::Lewd.Const.HeadORingGagResolve + " Resolve, +oral pleasure, +" + this.Math.floor((::Lewd.Const.HeadORingGagReceivedPleasureMult - 1.0) * 100) + "% pleasure received"
		});
	}

	function onUpdateProperties( _properties )
	{
		this.legend_helmet_upgrade.onUpdateProperties(_properties);
		_properties.Allure += ::Lewd.Const.HeadORingGagAllure;
		_properties.Bravery += ::Lewd.Const.HeadORingGagResolve;
		_properties.ReceivedPleasureMult *= ::Lewd.Const.HeadORingGagReceivedPleasureMult;
	}
});
