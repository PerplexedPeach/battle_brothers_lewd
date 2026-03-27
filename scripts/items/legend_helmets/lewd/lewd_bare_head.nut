this.lewd_bare_head <- this.inherit("scripts/items/legend_helmets/legend_helmet", {
	m = {},
	function create()
	{
		this.legend_helmet.create();
		this.m.ID = "armor.head.lewd_bare_head";
		this.m.Name = "Bare Head";
		this.m.Description = "Nothing but your own head. A base for more... expressive additions.";
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 0;
		this.m.Condition = 1;
		this.m.ConditionMax = 1;
		this.m.StaminaModifier = 0;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.IsDroppedAsLoot = false;
	}

	function updateVariant()
	{
		this.m.Sprite = "";
		this.m.SpriteDamaged = "";
		this.m.SpriteCorpse = "";
		this.m.Icon = "legend_helmets/overlay_lewd_bare_head.png";
		this.m.IconLarge = this.m.Icon;
	}

	function getIcon()
	{
		foreach (u in this.m.Upgrades)
		{
			if (u != null)
				return this.m.Icon;
		}
		return "legend_helmets/icon_lewd_bare_head.png";
	}

	function getIconOverlay()
	{
		local L = [];
		foreach (u in this.m.Upgrades)
		{
			if (u != null)
			{
				L.push(u.getOverlayIcon());
			}
		}
		if (L.len() == 0)
		{
			return [""];
		}
		return L;
	}

	function getIconLargeOverlay()
	{
		return this.getIconOverlay();
	}
});
