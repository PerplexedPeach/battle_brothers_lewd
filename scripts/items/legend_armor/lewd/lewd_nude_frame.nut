this.lewd_nude_frame <- this.inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.ID = "legend_armor.body.lewd_nude_frame";
		this.m.Name = "Bare Skin";
		this.m.Description = "Nothing but your own skin. A frame for more... decorative additions.";
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 0;
		this.m.Condition = 1;
		this.m.ConditionMax = 1;
		this.m.StaminaModifier = 0;
		this.m.ShowOnCharacter = false;
		this.m.HideBody = false;
		this.m.IsDroppedAsLoot = false;
	}

	function updateVariant()
	{
		this.m.Sprite = "";
		this.m.SpriteDamaged = "";
		this.m.SpriteCorpse = "";
		this.m.Icon = "legend_armor/icon_lewd_nude_frame.png";
		this.m.IconLarge = "legend_armor/inventory_lewd_nude_frame.png";
	}

	function onUpdateProperties( _properties )
	{
		this.legend_armor.onUpdateProperties(_properties);
	}
});
