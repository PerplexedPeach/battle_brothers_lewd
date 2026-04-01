// Rare Spider Companion -- stronger player-allied spider with enhanced stats.
// Based on a redback-tier spider with bonus HP, damage, and defense.
// Faction set externally by unleash skill.
this.lewd_rare_spider_companion <- this.inherit("scripts/entity/tactical/enemies/spider", {
	m = {
		Item = null
	},
	function setItem( _i )
	{
		if (typeof _i == "instance")
			this.m.Item = _i;
		else
			this.m.Item = this.WeakTableRef(_i);
	}

	function onInit()
	{
		this.spider.onInit();

		// Rare pet: enhanced stats
		local b = this.m.BaseProperties;
		b.Hitpoints = 120;
		b.MeleeSkill = 75;
		b.MeleeDefense = 20;
		b.RangedDefense = 30;
		b.Initiative = 170;
		b.Bravery = 80;
		b.Armor = [40, 40];
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;

		this.m.ConfidentMoraleBrush = "icon_confident";
		this.m.IsActingImmediately = true;
		this.getCurrentProperties().TargetAttractionMult = 0.25;
		this.m.BaseProperties.IsAffectedByInjuries = false;
		this.m.CurrentProperties.IsAffectedByInjuries = false;

		// Use Legends redback spider sprites for visual distinction
		if (this.hasSprite("body"))
		{
			local bodies = ["bust_spider_redback_body_01", "bust_spider_redback_body_02", "bust_spider_redback_body_03", "bust_spider_redback_body_04"];
			this.getSprite("body").setBrush(bodies[this.Math.rand(0, bodies.len() - 1)]);
		}
		if (this.hasSprite("head"))
			this.getSprite("head").setBrush("bust_spider_redback_head_01");
		if (this.hasSprite("legs_front"))
			this.getSprite("legs_front").setBrush("bust_spider_redback_legs_front");
		if (this.hasSprite("legs_back"))
			this.getSprite("legs_back").setBrush("bust_spider_redback_legs_back");

		// Flip sprites so pet faces the player's direction
		local sprites = ["body", "head", "legs_front", "legs_back", "injury"];
		foreach (name in sprites)
			if (this.hasSprite(name))
				this.getSprite(name).setHorizontalFlipping(true);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (this.m.Item != null && !this.m.Item.isNull())
		{
			this.m.Item.setEntity(null);

			if (this.m.Item.getContainer() != null && !this.m.Item.getContainer().isNull())
			{
				if (this.m.Item.getCurrentSlotType() == this.Const.ItemSlot.Bag)
					this.m.Item.getContainer().removeFromBag(this.m.Item.get());
				else
					this.m.Item.getContainer().unequip(this.m.Item.get());
			}

			this.m.Item = null;
		}

		this.spider.onDeath(_killer, _skill, _tile, _fatalityType);
	}
});
