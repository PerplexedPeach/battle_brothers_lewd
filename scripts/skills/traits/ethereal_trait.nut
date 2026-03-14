this.ethereal_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		LewdTier = 3
	},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.ethereal";
		this.m.Name = "Ethereal";
		this.m.Icon = "ui/traits/ethereal_trait.png";
		this.m.Description = "An otherworldly beauty radiates from every pore, as if the essence of countless encounters has crystallized into something beyond mortal. Their mere presence is intoxicating.";
		this.m.Excluded = [
			"trait.huge",
			"trait.tough",
			"trait.strong",
			"trait.brawler",
			"trait.gluttonous",
			"trait.brute",
			"trait.iron_jaw",
			"trait.dainty",
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.AllureFromEthereal + "[/color] Allure"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Others will avoid aiming for the head when attacking this character"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Immune to poison"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Grants [color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.PerkPointsFromEthereal + "[/color] additional perk points"
			},
		];
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		_hitInfo.BodyPart = this.Const.BodyPart.Body;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		local actor = this.getContainer().getActor();
		local totalDamageTaken = actor.getFlags().getAsInt("totalDamageTaken") + _damageHitpoints;
		::logInfo("Total damage taken by " + actor.getName() + ": " + totalDamageTaken);
		actor.getFlags().set("totalDamageTaken", totalDamageTaken);
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		::Lewd.Transform.sexy_stage_3(actor);
		::Lewd.Transform.adaptROTUAppearance(actor);

		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _data )
		{
			local player = this.World.State.m.Player;
			if (player != null)
			{
				player.getSprite("body").setBrush("figure_player_ethereal");
				player.getSprite("body").setHorizontalFlipping(false);
			}
		}, null);

		// Grant Tease ability
		if (!actor.getSkills().hasSkill("actives.tease"))
			actor.getSkills().add(this.new("scripts/skills/actives/seduce_skill"));

		// Grant pheromones ability
		if (!actor.getSkills().hasSkill("actives.pheromones"))
		{
			actor.getSkills().add(this.new("scripts/skills/actives/pheromones_skill"));
		}

		// Seduction Arts perk tree
		local bg = actor.getBackground();
		if (bg != null && !bg.hasPerkGroup(::Const.Perks.SeductionArtsTree))
			bg.addPerkGroup(::Const.Perks.SeductionArtsTree.Tree);

		// Endurance perk tree (Ethereal qualifies without needing Masochism for the tree)
		if (bg != null && !bg.hasPerkGroup(::Const.Perks.EnduranceTree))
			bg.addPerkGroup(::Const.Perks.EnduranceTree.Tree);

		// Succubus perk tree
		if (bg != null && !bg.hasPerkGroup(::Const.Perks.SuccubusTree))
			bg.addPerkGroup(::Const.Perks.SuccubusTree.Tree);

		// Grant perk points (flag prevents double-granting on load)
		if (!actor.getFlags().has("lewdEtherealPerkPointGranted"))
		{
			actor.m.PerkPoints += ::Lewd.Const.PerkPointsFromEthereal;
			actor.getFlags().set("lewdEtherealPerkPointGranted", true);
			::logInfo("[ethereal_trait] Granted " + ::Lewd.Const.PerkPointsFromEthereal + " perk point(s) to " + actor.getName());
		}
	}

	function onUpdate( _properties )
	{
		_properties.Hitpoints += -10;
		_properties.MeleeDamageMult *= 0.9;
		_properties.IsImmuneToHeadshots = true;
		_properties.IsImmuneToPoison = true;
		_properties.Allure += ::Lewd.Const.AllureFromEthereal;
		_properties.PleasureMax += ::Lewd.Const.PleasureMaxFromEthereal;
	}
});
