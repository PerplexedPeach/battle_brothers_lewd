this.lewd_facial_piercing_chain <- this.inherit("scripts/items/legend_helmets/legend_helmet_upgrade", {
	m = {},
	function create()
	{
		this.legend_helmet_upgrade.create();
		this.m.Type = this.Const.Items.HelmetUpgrades.Vanity;
		this.m.ID = "legend_helmet_upgrade.head.lewd_facial_piercing_chain";
		this.m.Name = "Facial Piercing Chain";
		this.m.Description = "A delicate gold chain connecting piercings across the nose and cheek. It catches the light with every turn of the head.";
		this.m.ArmorDescription = "Gold facial chain.";
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 1500;
		this.m.Condition = 5;
		this.m.ConditionMax = 5;
		this.m.StaminaModifier = 0;
		this.m.IsDroppedAsLoot = true;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_lewd_piercing_chain_" + variant;
		this.m.SpriteDamaged = "bust_lewd_piercing_chain_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_lewd_piercing_chain_" + variant + "_dead";
		this.m.Icon = "legend_helmets/icon_lewd_piercing_chain_" + variant + ".png";
		this.m.IconLarge = this.m.Icon;
		this.m.OverlayIcon = this.m.Icon;
		this.m.OverlayIconLarge = this.m.OverlayIcon;
	}

	function getTooltip()
	{
		local result = this.legend_helmet_upgrade.getTooltip();
		local C = ::Lewd.Const;
		result.push({ id = 20, type = "text", icon = "ui/icons/allure.png",
			text = "Allure [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.HeadPiercingChainAllure + "[/color]"
		});
		result.push({ id = 21, type = "text", icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]+" + this.Math.floor((C.HeadPiercingChainReceivedPleasureMult - 1.0) * 100) + "%[/color] pleasure received"
		});
		return result;
	}

	function onArmorTooltip( _result )
	{
		this.legend_helmet_upgrade.onArmorTooltip(_result);
		_result.push({ id = 20, type = "text", icon = "ui/icons/special.png",
			text = "+" + ::Lewd.Const.HeadPiercingChainAllure + " Allure, +" + this.Math.floor((::Lewd.Const.HeadPiercingChainReceivedPleasureMult - 1.0) * 100) + "% pleasure received"
		});
	}

	function onUpdateProperties( _properties )
	{
		this.legend_helmet_upgrade.onUpdateProperties(_properties);
		_properties.Allure += ::Lewd.Const.HeadPiercingChainAllure;
		_properties.ReceivedPleasureMult *= ::Lewd.Const.HeadPiercingChainReceivedPleasureMult;
	}
});
