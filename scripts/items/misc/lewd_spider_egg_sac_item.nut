// Spider Egg Sac -- right-click consumable lootbox item from spider oviposition.
// Right-click on a character to crack one egg and roll the loot table.
// If the sac contains multiple eggs, the remainder stays in the stash.
this.lewd_spider_egg_sac_item <- this.inherit("scripts/items/item", {
	m = {
		Amount = 1,
		IsStackable = true
	},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.lewd_spider_egg_sac";
		this.m.Name = "Spider Egg Sac";
		this.m.Description = "A translucent silk sac pulsing faintly with life. Right-click on a character to crack one open and see what hatches. May contain gossamer, or something more exotic.";
		this.m.Icon = "misc/inventory_spider_egg_sac.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsAllowedInBag = false;
		this.m.IsUsable = true;
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

	function isAmountShown()
	{
		return this.m.Amount > 1;
	}

	function getAmountString()
	{
		return "" + this.m.Amount;
	}

	function getName()
	{
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
				text = "Right-click on a character to open one egg and discover what's inside"
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

	function onUse( _actor, _item = null )
	{
		local stash = this.World.Assets.getStash();

		this.openOneEgg(stash);

		// Leave eggshells behind, stacking with existing pile if present
		local existingShells = null;
		foreach (item in stash.getItems())
		{
			if (item != null && item.getID() == "misc.lewd_spider_eggshells")
			{
				existingShells = item;
				break;
			}
		}

		if (existingShells != null)
			existingShells.setAmount(existingShells.getAmount() + 1);
		else
			stash.add(this.new("scripts/items/misc/lewd_spider_eggshells_item"));

		// Consume this item; put remainder back as new stack
		if (this.m.Amount > 1)
		{
			local remaining = this.new("scripts/items/misc/lewd_spider_egg_sac_item");
			remaining.setAmount(this.m.Amount - 1);
			stash.add(remaining);
		}

		return true;
	}

	function rollSpiderName()
	{
		local names = [
			"Silk", "Fang", "Whisper", "Needle", "Shade",
			"Tangle", "Spinner", "Lurk", "Weaver", "Skitter",
			"Gossamer", "Nib", "Dusk", "Midge", "Petal",
			"Bramble", "Cricket", "Wisp", "Thistle", "Flicker",
			"Cobweb", "Scuttle", "Nimble", "Sprig", "Glint"
		];
		return names[this.Math.rand(0, names.len() - 1)];
	}

	function rollRareSpiderName()
	{
		local names = [
			"Iridessa", "Vesper", "Nocturne", "Obsidian", "Aurelis",
			"Phantom", "Eclipse", "Shimmer", "Veilweaver", "Starfang",
			"Duskmantle", "Gossameris", "Prism", "Nightwhisper", "Opalith"
		];
		return names[this.Math.rand(0, names.len() - 1)];
	}

	function openOneEgg( _stash )
	{
		// [weight, scriptPath (null = nothing), quantity, isPet]
		local lootTable = [
			[::Lewd.Const.SpiderEggWeightRarePet,  "scripts/items/misc/lewd_rare_spider_pet_item", 1, true],
			[::Lewd.Const.SpiderEggWeightPet,      "scripts/items/misc/lewd_spider_pet_item",      1, true],
			[::Lewd.Const.SpiderEggWeightSilk2,    "scripts/items/misc/spider_silk_item",          2, false],
			[::Lewd.Const.SpiderEggWeightSilk1,    "scripts/items/misc/spider_silk_item",          1, false],
			[::Lewd.Const.SpiderEggWeightDyes,     "scripts/items/trade/dies_item",                1, false],
			[::Lewd.Const.SpiderEggWeightCoins,    "scripts/items/loot/ancient_gold_coins_item",   1, false],
			[::Lewd.Const.SpiderEggWeightNothing,   null,                                          0, false]
		];

		local totalWeight = 0;
		foreach (entry in lootTable)
			totalWeight += entry[0];

		local roll = this.Math.rand(1, totalWeight);
		local threshold = 0;

		foreach (entry in lootTable)
		{
			threshold += entry[0];
			if (roll <= threshold)
			{
				local script = entry[1];
				local qty = entry[2];
				local isPet = entry[3];

				if (script != null)
				{
					for (local i = 0; i < qty; i++)
					{
						local item = this.new(script);
						if (isPet)
							item.setPetName(script.find("rare") != null ? this.rollRareSpiderName() : this.rollSpiderName());
						_stash.add(item);
					}
					::logInfo("[egg_sac] " + script + " x" + qty + " (roll=" + roll + "/" + totalWeight + ")");
				}
				else
				{
					::logInfo("[egg_sac] Nothing (roll=" + roll + "/" + totalWeight + ")");
				}
				return;
			}
		}
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
