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
			{
				id = 14,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Others will avoid aiming for the head when attacking this character"
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
		::Lewd.Transform.sexy_stage_2(actor);
		::Lewd.Transform.adaptROTUAppearance(actor);

		// NOTE: hooking on updateLook isn't working for some reason, so we set the body sprite directly
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _data )
		{
			local player = this.World.State.m.Player;
			if (player != null)
			{
				player.getSprite("body").setBrush("figure_player_delicate");
				player.getSprite("body").setHorizontalFlipping(false);

			}
		}, null);

		// Grant pheromones ability
		if (!actor.getSkills().hasSkill("actives.pheromones"))
		{
			actor.getSkills().add(this.new("scripts/skills/actives/pheromones_skill"));
		}
	}

	function onUpdate( _properties )
	{
		_properties.Hitpoints += -10;
		_properties.MeleeDamageMult *= 0.9;
		_properties.IsImmuneToHeadshots = true;
		_properties.Allure += ::Lewd.Const.AllureFromDelicate;
		_properties.PleasureMax += ::Lewd.Const.PleasureMaxFromDelicate;
	}
});

