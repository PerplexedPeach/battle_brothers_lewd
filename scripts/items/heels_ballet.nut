this.heels_ballet <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.heels_ballet";
		this.m.Name = "Heels of Subjugation";
		this.m.Description = "Sinister heels that look more like a torture or bondage device than footwear. Instead of heels, a wicked spike protrudes from the ground towards the wearer's foot, keeping them on their toes and forcing them to walk in a more elegant, but also more vulnerable way. They glow with a faint pink light, and apply a tight pressure on the wearer's feet, binding them and shaping the wearer to the designer's taste. ";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/ballet_heels.png";
		this.m.Sprite = "ballet_heels";

		this.m.Value = 10000;
		this.m.IsPrecious = true;

		this.getFlags().set("heelHeight", 5);
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
		// TODO adjust stats
		// reduce ranged defense and initiative
		_properties.RangedDefense -= 10;
		_properties.Initiative -= 20;

		// TODO increase fatigue gain on moving

		// TODO increase resolve of allies around
		// TODO passive ability for chance to daze enemies when moving in melee range
		// _properties.MeleeSkill += 5;
		// _properties.Bravery += 15;
		// _properties.FatigueRecoveryRate += 5;
	}

	function onEquip()
	{
		this.accessory.onEquip();
		local actor = this.getContainer().getActor();				
		actor.getFlags().set("heelHeight", this.getFlags().get("heelHeight"));
		// actor.m.heelHeight = this.getFlags().get("heelHeight");
		::logInfo("Equipped heels with heel height: " + actor.getFlags().get("heelHeight"));
	}

	function onUnequip()
	{
		this.accessory.onUnequip();
		local actor = this.getContainer().getActor();				
		actor.getFlags().set("heelHeight", 0);
		::logInfo("Unequipped heels, reset heel height to: " + actor.getFlags().get("heelHeight"));
	}

	// function onUpdate( _properties)
	// {
	// 	local actor = this.getContainer().getActor();				
	// 	if (this.getContainer().getActor().m.IsMoving)
	// 	{
	// 		::logInfo("Heels of subjugation triggered on move");
	// 		// local myTile = actor.getTile();			
	// 		// actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + this.Math.max(0, actor.getActionPointCosts()[myTile.Type] * _properties.MovementAPCostMult)));
	// 		// actor.setFatigue(this.Math.max(0, actor.getFatigue() - this.Math.max(0, actor.getFatigueCosts()[myTile.Type] * _properties.MovementFatigueCostMult)));			
	// 	}		
	// }


	function onRemoveWhileCursed()
	{
		::logInfo("Try to remove cursed item this: " + this.getName());
		// TODO fire event that explains this more immersively 
	}
});
