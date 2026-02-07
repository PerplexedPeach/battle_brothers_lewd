this.glowing_amulet_of_valor <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.glowing_amulet_of_valor";
		this.m.Name = "Glowing Amulet of Valor";
		this.m.Description = "A legendary amulet that radiates an otherworldly glow. It is said to have been forged by ancient smiths to grant its wearer unshakeable courage and increased physical prowess in combat.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/ballet_heels.png";
		this.m.Sprite = "ballet_heels";

		this.m.Value = 3000;
		this.m.IsPrecious = true;
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
				text = this.getDescription()
			}
		];
		result.push({
			id = 66,
			type = "text",
			text = this.getValueString()
		});

		if (this.getIconLarge() != null)
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIconLarge(),
				isLarge = true
			});
		}
		else
		{
			result.push({
				id = 3,
				type = "image",
				image = this.getIcon()
			});
		}

		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Increases Melee Skill by [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color]"
		});
		result.push({
			id = 16,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Increases Resolve by [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color]"
		});
		result.push({
			id = 17,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Increases Fatigue Recovery by [color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color]"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		_properties.MeleeSkill += 5;
		_properties.Bravery += 15;
		_properties.FatigueRecoveryRate += 5;
	}

	// function onUnequip()
	// {
	// 	// cursed item, when you try to unequip it, it just re-equips itself
	// 	local actor = this.getContainer().getActor();

	// 	::logInfo("Trying to unequip cursed item; actor: " + (actor != null ? actor.getName() : "null"));

	// 	if (actor == null)
	// 	{
	// 		return;
	// 	}

	// 	// this.item.equip(actor);
	// 	this.getContainer().equip(this.item);
	// 	// this.item.onEquip();
	// }

	function onRemoveWhileCursed()
	{
		::logInfo("Try to remove cursed item this: " + this.getName());
		// TODO fire event that explains this more immersively 
	}
});
