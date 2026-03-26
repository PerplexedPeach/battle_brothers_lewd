// Spider Companion -- equippable pet accessory that grants an Unleash Spider skill.
// Spawns a player-allied spider in combat. Obtained from spider egg sac lootbox.
this.lewd_spider_pet_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {
		Skill = null
	},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.lewd_spider_pet";
		this.m.Name = "Spider Companion";
		this.m.Description = "A small spider raised from an egg sac, now loyal to its handler. It can web enemies, bite with venomous fangs, and skitter across the battlefield. Equip to gain the ability to unleash it in combat.";
		this.m.Icon = "misc/inventory_webknecht_silk.png";
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

	function onEquip()
	{
		this.accessory.onEquip();
		local skill = this.new("scripts/skills/actives/lewd_unleash_spider_skill");
		skill.setItem(this);
		skill.setEntityScript("scripts/entity/tactical/lewd_spider_companion");
		skill.setEntityName("Spider Companion");
		this.getContainer().getActor().getSkills().add(skill);
		this.m.Skill = this.WeakTableRef(skill);
	}

	function onUnequip()
	{
		if (this.m.Skill != null && !this.m.Skill.isNull())
			this.getContainer().getActor().getSkills().removeByID("actives.lewd_unleash_spider");
		this.m.Skill = null;
		this.accessory.onUnequip();
	}

	function onCombatFinished()
	{
		if (this.m.Skill != null && !this.m.Skill.isNull())
			this.m.Skill.onCombatFinished();
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}
});
