// Spider Companion -- equippable pet accessory that grants an Unleash Spider skill.
// Spawns a player-allied spider in combat. Obtained from spider egg sac lootbox.
this.lewd_spider_pet_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {
		Skill = null,
		PetName = ""
	},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.lewd_spider_pet";
		this.m.Name = "Spider Companion";
		this.m.Description = "A small spider raised from an egg sac, now loyal to its handler. It can web enemies, bite with venomous fangs, and skitter across the battlefield. Equip to gain the ability to unleash it in combat.";
		this.m.Icon = "misc/inventory_spider_pet.png";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.ItemType = this.Const.Items.ItemType.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsChangeableInBattle = false;
		this.m.Value = 1500;
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
			}
		];
		return result;
	}

	function setPetName( _name )
	{
		this.m.PetName = _name;
		this.m.Name = _name + " (Spider Companion)";
	}

	function getName()
	{
		if (this.m.PetName.len() > 0)
			return this.m.PetName + " (Spider Companion)";
		return "Spider Companion";
	}

	function onEquip()
	{
		this.accessory.onEquip();
		local skill = this.new("scripts/skills/actives/lewd_unleash_spider_skill");
		skill.setItem(this);
		skill.setEntityScript("scripts/entity/tactical/lewd_spider_companion");
		skill.setEntityName(this.m.PetName.len() > 0 ? this.m.PetName : "Spider Companion");
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
			this.m.Name = this.m.PetName + " (Spider Companion)";
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}
});
