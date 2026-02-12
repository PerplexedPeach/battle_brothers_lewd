this.heels_ballet <- this.inherit("scripts/items/heels", {
	m = {},
	function create()
	{
		this.heels.create();
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
		this.m.IsUnique = true;

		this.defineHeels(5, 20);
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
			text = "Heel height: [color=" + this.Const.UI.Color.NegativeValue + "]5 (extreme!)[/color]"
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
			text = "Increases Allure by [color=" + this.Const.UI.Color.PositiveValue + "]20[/color]"
		});
		result.push({
			id = 18,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = "Reduces initiative by [color=" + this.Const.UI.Color.NegativeValue + "]-20[/color]"
		});
		result.push({
			id = 19,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = "Reduces ranged defense by [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color]"
		});
		result.push({
			id = 20,
			type = "text",
			icon = "ui/icons/chance_to_hit_head.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Chance To Hit Head"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.accessory.onUpdateProperties(_properties);
		// reduce ranged defense and initiative
		_properties.RangedDefense -= 10;
		_properties.Initiative -= 20;
		_properties.HitChance[this.Const.BodyPart.Head] += 10;

		// TODO pain tolerance, increase damage reduction (or have it not trigger morale loss from taking damage)

		local actor = this.getContainer().getActor();
		local morale = actor.getSprite("morale");
		morale.Visible = false;
	}

	function onEquip()
	{
		this.heels.onEquip();

		local skill = this.new("scripts/skills/actives/seduce_skill");
		skill.setItem(this);
		this.addSkill(skill);
	}

});
