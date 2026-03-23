this.lewd_fishnets <- this.inherit("scripts/items/legend_armor/legend_armor_upgrade", {
	m = {},
	function create()
	{
		this.legend_armor_upgrade.create();
		this.m.Type = this.Const.Items.ArmorUpgrades.Tabbard;
		this.m.ID = "legend_armor.body.lewd_fishnets";
		this.m.Name = "Fishnets";
		this.m.Description = "Stockings woven from gossamer into a diamond mesh pattern so delicate it looks like it was spun by something not entirely natural. They catch the light in ways that draw the eye and hold it. The higher the heel, the more they flatter the leg.";
		this.m.ArmorDescription = "A pair of gossamer fishnets";
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 800;
		this.m.Condition = 5;
		this.m.ConditionMax = 5;
		this.m.StaminaModifier = 0;
		this.m.IsDroppedAsLoot = true;
	}

	function updateVariant()
	{
		// No bust sprite -- fishnets are a lower body item
		this.m.SpriteBack = "";
		this.m.SpriteDamagedBack = "";
		this.m.SpriteCorpseBack = "";
		this.m.Icon = "legend_armor/icon_lewd_fishnets_01.png";
		this.m.IconLarge = "legend_armor/inventory_lewd_fishnets_01.png";
		this.m.OverlayIcon = "legend_armor/overlay_lewd_fishnets_01.png";
		this.m.OverlayIconLarge = "legend_armor/inventory_lewd_fishnets_01.png";
	}

	function getLewdTooltipDetail( _result )
	{
		_result.push({ id = 20, type = "text", icon = "ui/icons/allure.png",
			text = "Allure [color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.ClothingAllureFishnets + "[/color]"
		});
		local heelHeight = 0;
		if (this.getContainer() != null)
			heelHeight = this.getContainer().getActor().getFlags().getAsInt("heelHeight");
		_result.push({ id = 21, type = "text", icon = "ui/icons/initiative.png",
			text = "Initiative [color=" + this.Const.UI.Color.PositiveValue + "]+" + heelHeight + "[/color] (equal to heel height)"
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
		local heelHeight = 0;
		if (this.getContainer() != null)
			heelHeight = this.getContainer().getActor().getFlags().getAsInt("heelHeight");
		_result.push({ id = 20, type = "text", icon = "ui/icons/special.png",
			text = "Allure +" + ::Lewd.Const.ClothingAllureFishnets + ", Initiative +" + heelHeight + " (heel height)"
		});
	}

	function onUpdateProperties( _properties )
	{
		this.legend_armor_upgrade.onUpdateProperties(_properties);
		_properties.Allure += ::Lewd.Const.ClothingAllureFishnets;
		local actor = this.getContainer().getActor();
		local heelHeight = actor.getFlags().getAsInt("heelHeight");
		_properties.Initiative += heelHeight;
	}
});
