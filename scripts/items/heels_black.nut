this.heels_black <- this.inherit("scripts/items/accessory/accessory", {
	m = {},
	function create()
	{
		this.accessory.create();
		this.m.ID = "accessory.heels_black";
		this.m.Name = "Black Heels of Temptation";
		this.m.Description = "Elegant black heels that are both stylish and dangerous. The heels are quite high, forcing the wearer to walk in a more elegant, but also more vulnerable way. They are made of mysterious black leather and are adorned by gold buckles. They seem to exude a subtle aura of temptation, making the wearer more alluring to others, but also making them more susceptible to being targeted by unwanted attention.";
		this.m.SlotType = this.Const.ItemSlot.Accessory;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "accessory/black_heels.png";
		this.m.Sprite = "black_heels";

		this.m.Value = 3000;
		this.m.IsPrecious = true;

		this.getFlags().set("heelHeight", 3);
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
			text = "Heel height: [color=" + this.Const.UI.Color.NegativeValue + "]3 (high)[/color]"
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
			text = "Increases Allure by [color=" + this.Const.UI.Color.PositiveValue + "]10[/color]"
		});
		result.push({
			id = 18,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = "Reduces initiative by [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color]"
		});
		result.push({
			id = 19,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = "Reduces ranged defense by [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color]"
		});
		result.push({
			id = 20,
			type = "text",
			icon = "ui/icons/chance_to_hit_head.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] Chance To Hit Head"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		// reduce ranged defense and initiative
		_properties.RangedDefense -= 5;
		_properties.Initiative -= 10;
		_properties.HitChance[this.Const.BodyPart.Head] += 5;

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
		actor.getFlags().set("allureHeels", 10);

		local skill = this.new("scripts/skills/effects/entrancing_beauty_effect");
		skill.setItem(this);
		this.addSkill(skill);

		skill = this.new("scripts/skills/effects/heel_walking_effect");
		skill.setItem(this);
		this.addSkill(skill);

		skill = this.new("scripts/skills/actives/seduce_skill");
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
