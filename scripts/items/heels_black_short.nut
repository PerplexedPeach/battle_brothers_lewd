this.heels_black_short <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.heels_black_short";
		this.m.Name = "Short Black Heels";
		this.m.Description = "Strappy shoes reminescent of gladiator sandals, but with a heel. The heel is not very high, but it still forces the wearer to walk in a more elegant, but also more vulnerable way. They are made of mysterious black leather and are adorned by gold buckles.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/black_heels_short.png";
		this.m.Sprite = "black_heels_short";

		this.m.Value = 1000;
		this.m.IsPrecious = true;

		this.getFlags().set("heelHeight", 1);
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
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "Heel height: [color=" + this.Const.UI.Color.NegativeValue + "]1 (low)[/color]"
		});
		result.push({
			id = 16,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Chance to inflict \'Dazed\' to those engaged in melee with chance scaling with [color=" + this.Const.UI.Color.PositiveValue + "]Allure[/color] contested by their resolve"
		});
		result.push({
			id = 17,
			type = "text",
			icon = "ui/icons/allure.png",
			text = "Increases Allure by [color=" + this.Const.UI.Color.PositiveValue + "]5[/color]"
		});
		result.push({
			id = 18,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = "Reduces initiative by [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color]"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		// reduce ranged defense and initiative
		_properties.RangedDefense -= 2;
		_properties.Initiative -= 5;

		// TODO pain tolerance, increase damage reduction (or have it not trigger morale loss from taking damage)

		local actor = this.getContainer().getActor();				
		local morale = actor.getSprite("morale");
		morale.Visible = false;
	}

	function onEquip()
	{
		this.accessory.onEquip();
		local actor = this.getContainer().getActor();				
		actor.getFlags().set("heelHeight", this.getFlags().get("heelHeight"));
		actor.getFlags().set("allureHeels", 5);

		local skill = this.new("scripts/skills/effects/entrancing_beauty_effect");
		skill.setItem(this);
		this.addSkill(skill);

		skill = this.new("scripts/skills/effects/heel_walking_effect");
		skill.setItem(this);
		this.addSkill(skill);

		::logInfo("Equipped heels with heel height: " + actor.getFlags().get("heelHeight"));
	}

	function onUnequip()
	{
		this.accessory.onUnequip();
		local actor = this.getContainer().getActor();				
		actor.getFlags().set("heelHeight", 0);
		actor.getFlags().set("allureHeels", 0);
		::logInfo("Unequipped heels, reset heel height to: " + actor.getFlags().get("heelHeight"));
	}
});
