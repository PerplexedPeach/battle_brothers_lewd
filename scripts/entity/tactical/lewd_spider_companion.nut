// Spider Companion -- player-allied spider spawned from pet accessory.
// Inherits base game spider with slightly reduced stats (it's a pet, not a wild spider).
// Faction set externally by unleash skill.
this.lewd_spider_companion <- this.inherit("scripts/entity/tactical/enemies/spider", {
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

		// Pet adjustments
		this.m.ConfidentMoraleBrush = "icon_confident";
		this.m.IsActingImmediately = true;
		this.getCurrentProperties().TargetAttractionMult = 0.25;
		this.m.BaseProperties.IsAffectedByInjuries = false;
		this.m.CurrentProperties.IsAffectedByInjuries = false;

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
