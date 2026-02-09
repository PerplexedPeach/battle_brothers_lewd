this.delicate_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.delicate";
		this.m.Name = "Delicate";
		this.m.Icon = "ui/traits/delicate_trait.png";
		this.m.Description = "With slender limbs, a delicate frame, and soft skin free of blemishes and blisters, they are not built for brute strength or the battlefield.";
		this.m.Excluded = [
			"trait.huge",
			"trait.tough",
			"trait.strong",
			"trait.brawler",
			"trait.gluttonous",
			"trait.brute",
			"trait.iron_jaw",
			"trait.dainty"
		];
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Hitpoints"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Melee Damage"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Allure"
			},
		];
	}

	function onUpdate( _properties )
	{
		_properties.Hitpoints += -10;
		_properties.MeleeDamageMult *= 0.9;
	}
});

