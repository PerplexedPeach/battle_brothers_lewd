this.lewd_sheer_bodysuit <- this.inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.ID = "legend_armor.body.lewd_sheer_bodysuit";
		this.m.Name = "Sheer Bodysuit";
		this.m.Description = "A translucent bodysuit woven from gossamer so fine it catches the light like morning dew on spider silk. It conceals nothing and flatters everything.";
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 1200;
		this.m.Condition = 10;
		this.m.ConditionMax = 10;
		this.m.StaminaModifier = -1;
		this.m.ShowOnCharacter = true;
		this.m.HideBody = false;
		this.m.IsDroppedAsLoot = true;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_lewd_sheer_bodysuit_01";
		this.m.SpriteDamaged = "bust_lewd_sheer_bodysuit_01_damaged";
		this.m.SpriteCorpse = "bust_lewd_sheer_bodysuit_01_dead";
		this.m.Icon = "legend_armor/icon_lewd_sheer_bodysuit_01.png";
		this.m.IconLarge = "legend_armor/inventory_lewd_sheer_bodysuit_01.png";
	}

	function getTooltip()
	{
		local result = this.legend_armor.getTooltip();
		local C = ::Lewd.Const;
		result.push({ id = 20, type = "text", icon = "ui/icons/allure.png",
			text = "Allure [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.ClothingAllureSheerBodysuit + "[/color]"
		});
		result.push({ id = 21, type = "text", icon = "ui/icons/ranged_defense.png",
			text = "Ranged Defense [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.ClothingSheerBodysuitRangedDef + "[/color]"
		});
		result.push({ id = 22, type = "text", icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]+" + this.Math.floor((C.ClothingSheerBodysuitReceivedPleasureMult - 1.0) * 100) + "%[/color] pleasure received (heightened sensitivity)"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.legend_armor.onUpdateProperties(_properties);
		_properties.Allure += ::Lewd.Const.ClothingAllureSheerBodysuit;
		_properties.RangedDefense += ::Lewd.Const.ClothingSheerBodysuitRangedDef;
		_properties.ReceivedPleasureMult *= ::Lewd.Const.ClothingSheerBodysuitReceivedPleasureMult;
	}
});
