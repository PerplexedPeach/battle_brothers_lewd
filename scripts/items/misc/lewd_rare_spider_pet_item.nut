// Rare Spider Companion -- enhanced pet accessory from rare egg sac lootbox roll.
// Spawns a stronger player-allied spider with boosted stats.
this.lewd_rare_spider_pet_item <- this.inherit("scripts/items/accessory/accessory", {
	m = {
		Skill = null
	},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.lewd_rare_spider_pet";
		this.m.Name = "Radiant Spider Companion";
		this.m.Description = "A magnificent specimen that shimmers with an iridescent sheen. Larger and stronger than its common kin, with venom that can stun even armored foes. A prized and fearsome companion.";
		this.m.Icon = "misc/inventory_webknecht_silk.png";
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

	function onEquip()
	{
		this.accessory.onEquip();
		local skill = this.new("scripts/skills/actives/lewd_unleash_spider_skill");
		skill.setItem(this);
		skill.setEntityScript("scripts/entity/tactical/lewd_rare_spider_companion");
		skill.setEntityName("Radiant Spider");
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
