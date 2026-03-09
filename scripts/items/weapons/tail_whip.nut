this.tail_whip <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.tail_whip";
		this.m.Name = "Succubus Tail";
		this.m.Description = "A long, sinuous tail ending in a tapered tip. Deceptively strong, it can lash out with surprising reach and force. In the hands of its owner, it is as much a weapon as it is a mark of her nature.";
		this.m.Categories = "Tail, One-Handed";
		this.m.IconLarge = "weapons/tail_whip_icon_large.png";
		this.m.Icon = "weapons/tail_whip_icon.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDroppedAsLoot = false;
		this.m.IsDoubleGrippable = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_tail_whip";
		this.m.Condition = 0;
		this.m.ConditionMax = 0;
		this.m.StaminaModifier = 0;
		this.m.Value = 0;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 15;
		this.m.RegularDamageMax = 25;
		this.m.ArmorDamageMult = 0.3;
		this.m.DirectDamageMult = 0.3;
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();
		result.push({
			id = 70,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "A natural weapon. Cannot be unequipped or dropped."
		});
		return result;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/tail_lash_skill"));
	}
});
