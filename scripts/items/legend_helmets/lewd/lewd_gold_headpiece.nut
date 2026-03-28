this.lewd_gold_headpiece <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.ID = "armor.head.lewd_gold_headpiece";
		this.m.Name = "Gold Headpiece";
		this.m.Description = "An ornate golden headpiece with sharp, sweeping points. It frames the face like a crown but carries no title, only the unmistakable air of someone who expects to be obeyed.";
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 2500;
		this.m.Condition = 15;
		this.m.ConditionMax = 15;
		this.m.StaminaModifier = -1;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.IsDroppedAsLoot = true;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_lewd_gold_headpiece_" + variant;
		this.m.SpriteDamaged = "bust_lewd_gold_headpiece_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_lewd_gold_headpiece_" + variant + "_dead";
		this.m.Icon = "legend_helmets/icon_lewd_gold_headpiece_" + variant + ".png";
		this.m.IconLarge = this.m.Icon;
	}

	function getTooltip()
	{
		local result = this.legend_helmet.getTooltip();
		local C = ::Lewd.Const;
		result.push({ id = 20, type = "text", icon = "ui/icons/allure.png",
			text = "Allure [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.HeadGoldHeadpieceAllure + "[/color]"
		});
		result.push({ id = 21, type = "text", icon = "ui/icons/bravery.png",
			text = "Resolve [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.HeadGoldHeadpieceResolve + "[/color]"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.legend_helmet.onUpdateProperties(_properties);
		_properties.Allure += ::Lewd.Const.HeadGoldHeadpieceAllure;
		_properties.Bravery += ::Lewd.Const.HeadGoldHeadpieceResolve;
	}
});
