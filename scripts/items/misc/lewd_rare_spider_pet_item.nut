// Rare Spider Companion -- enhanced pet accessory from rare egg sac lootbox roll.
// Spawns a stronger player-allied spider with boosted stats.
this.lewd_rare_spider_pet_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {
		Skill = null,
		PetName = "",
		Entity = null
	},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.lewd_rare_spider_pet";
		this.m.Name = "Radiant Spider Companion";
		this.m.Description = "A magnificent specimen that shimmers with an iridescent sheen. Larger and stronger than its common kin, with venom that can stun even armored foes. A prized and fearsome companion.";
		this.m.Icon = "misc/inventory_spider_rare_pet.png";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.ItemType = this.Const.Items.ItemType.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsChangeableInBattle = false;
		this.m.Value = 5000;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.m.Description
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Grants [color=" + this.Const.UI.Color.PositiveValue + "]Unleash Spider[/color] active skill in combat"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Enhanced[/color] stats: more HP, higher attack, stronger venom"
			}
		];
		return result;
	}

	function setEntity( _e )
	{
		this.m.Entity = _e;
	}

	function getEntity()
	{
		return this.m.Entity;
	}

	function setPetName( _name )
	{
		this.m.PetName = _name;
		this.m.Name = _name + " (Radiant Spider)";
	}

	function getName()
	{
		if (this.m.PetName.len() > 0)
			return this.m.PetName + " (Radiant Spider)";
		return "Radiant Spider Companion";
	}

	function onEquip()
	{
		this.accessory.onEquip();
		local skill = this.new("scripts/skills/actives/lewd_unleash_spider_skill");
		skill.setItem(this);
		skill.setEntityScript("scripts/entity/tactical/lewd_rare_spider_companion");
		skill.setEntityName(this.m.PetName.len() > 0 ? this.m.PetName : "Radiant Spider");
		skill.m.Icon = "skills/lewd_unleash_spider_rare.png";
		skill.m.IconDisabled = "skills/lewd_unleash_spider_rare_bw.png";
		this.m.Skill = this.WeakTableRef(skill);
		this.addSkill(skill);
	}

	function onUnequip()
	{
		this.accessory.onUnequip();
	}

	function onCombatFinished()
	{
		if (this.m.Skill != null && !this.m.Skill.isNull())
			this.m.Skill.onCombatFinished();
	}

	function onSerialize( _out )
	{
		this.accessory.onSerialize(_out);
		_out.writeString(this.m.PetName);
	}

	function onDeserialize( _in )
	{
		this.accessory.onDeserialize(_in);
		this.m.PetName = _in.readString();
		if (this.m.PetName.len() > 0)
			this.m.Name = this.m.PetName + " (Radiant Spider)";
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}
});
