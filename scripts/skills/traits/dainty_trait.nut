this.dainty_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.dainty";
		this.m.Name = "Dainty";
		this.m.Icon = "ui/traits/dainty_trait.png";
		this.m.Description = "Slender limbs and a slight frame makes them unsuited for being on the frontline.";
		this.m.Excluded = [
			"trait.huge",
			"trait.tough",
			"trait.strong",
			"trait.brawler",
			"trait.gluttonous",
			"trait.brute",
			"trait.iron_jaw",
			"trait.delicate"
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Hitpoints"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] Melee Damage"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Allure"
			},
		];
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		::Lewd.Transform.sexy_stage_1(actor);
		::Lewd.Transform.adaptROTUAppearance(actor);
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _data )
		{
			local player = this.World.State.m.Player;
			if (player != null)
			{
				player.getSprite("body").setBrush("figure_player_dainty");
				player.getSprite("body").setHorizontalFlipping(false);
			}
		}, null);

		// Seduction Arts perk tree
		local bg = actor.getBackground();
		if (bg != null && !bg.hasPerkGroup(::Const.Perks.SeductionArtsTree))
			bg.addPerkGroup(::Const.Perks.SeductionArtsTree.Tree);
	}

	function onUpdate( _properties )
	{
		_properties.Hitpoints += -5;
		_properties.MeleeDamageMult *= 0.95;
		_properties.Allure += ::Lewd.Const.AllureFromDainty;
		_properties.PleasureMax += ::Lewd.Const.PleasureMaxFromDainty;
	}
});

