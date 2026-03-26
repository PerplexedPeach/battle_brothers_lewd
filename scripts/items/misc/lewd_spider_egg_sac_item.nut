// Spider Egg Sac -- stackable lootbox item from spider oviposition.
// Equip to a character's accessory slot to open one egg and roll the loot table.
// Remaining eggs in the stack are returned to the stash.
this.lewd_spider_egg_sac_item <- this.inherit("scripts/items/item", {
	m = {
		Amount = 1
	},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.lewd_spider_egg_sac";
		this.m.Name = "Spider Egg Sac";
		this.m.Description = "A translucent silk sac pulsing faintly with life. Equip to a character to crack one open and see what hatches. May contain gossamer, or something more exotic.";
		this.m.Icon = "misc/inventory_webknecht_silk.png";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Loot;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.Value = 200;
	}

	function setAmount( _n )
	{
		this.m.Amount = _n;
	}

	function getAmount()
	{
		return this.m.Amount;
	}

	function getName()
	{
		if (this.m.Amount > 1)
			return "Spider Egg Sac (x" + this.m.Amount + ")";
		return "Spider Egg Sac";
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
				text = "Equip to open one egg and discover what's inside"
			}
		];

		if (this.m.Amount > 1)
		{
			result.push({
				id = 11,
				type = "text",
				icon = "ui/icons/asset_supplies.png",
				text = "Contains [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Amount + "[/color] eggs"
			});
		}

		return result;
	}

	function onEquip()
	{
		this.item.onEquip();

		local stash = this.World.Assets.getStash();

		// Roll the loot table for one egg
		this.openOneEgg(stash);

		// Return remaining eggs to stash as a new item
		if (this.m.Amount > 1)
		{
			local remaining = this.new("scripts/items/misc/lewd_spider_egg_sac_item");
			remaining.setAmount(this.m.Amount - 1);
			stash.add(remaining);
		}

		// Mark this item as spent
		this.m.Amount = 0;
		this.m.Name = "Empty Egg Sac";
		this.m.Description = "A spent egg sac. Discard this.";
		this.m.Value = 0;
	}

	function openOneEgg( _stash )
	{
		local totalWeight = ::Lewd.Const.SpiderEggWeightRarePet
			+ ::Lewd.Const.SpiderEggWeightPet
			+ ::Lewd.Const.SpiderEggWeightSilk2
			+ ::Lewd.Const.SpiderEggWeightSilk1
			+ ::Lewd.Const.SpiderEggWeightDyes
			+ ::Lewd.Const.SpiderEggWeightNothing;

		local roll = this.Math.rand(1, totalWeight);
		local threshold = 0;

		threshold += ::Lewd.Const.SpiderEggWeightRarePet;
		if (roll <= threshold)
		{
			::logInfo("[egg_sac] RARE PET (roll=" + roll + "/" + totalWeight + ")");
			_stash.add(this.new("scripts/items/misc/lewd_rare_spider_pet_item"));
			return;
		}

		threshold += ::Lewd.Const.SpiderEggWeightPet;
		if (roll <= threshold)
		{
			::logInfo("[egg_sac] PET (roll=" + roll + "/" + totalWeight + ")");
			_stash.add(this.new("scripts/items/misc/lewd_spider_pet_item"));
			return;
		}

		threshold += ::Lewd.Const.SpiderEggWeightSilk2;
		if (roll <= threshold)
		{
			::logInfo("[egg_sac] 2x SILK (roll=" + roll + "/" + totalWeight + ")");
			_stash.add(this.new("scripts/items/misc/spider_silk_item"));
			_stash.add(this.new("scripts/items/misc/spider_silk_item"));
			return;
		}

		threshold += ::Lewd.Const.SpiderEggWeightSilk1;
		if (roll <= threshold)
		{
			::logInfo("[egg_sac] 1x SILK (roll=" + roll + "/" + totalWeight + ")");
			_stash.add(this.new("scripts/items/misc/spider_silk_item"));
			return;
		}

		threshold += ::Lewd.Const.SpiderEggWeightDyes;
		if (roll <= threshold)
		{
			::logInfo("[egg_sac] DYES (roll=" + roll + "/" + totalWeight + ")");
			_stash.add(this.new("scripts/items/trade/dies_item"));
			return;
		}

		::logInfo("[egg_sac] Nothing (roll=" + roll + "/" + totalWeight + ")");
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeU16(this.m.Amount);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.Amount = _in.readU16();
	}
});
