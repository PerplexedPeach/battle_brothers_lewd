this.lewd_piercing_chains <- this.inherit("scripts/items/legend_armor/legend_armor_upgrade", {
	m = {},
	function create()
	{
		this.legend_armor_upgrade.create();
		this.m.Type = this.Const.Items.ArmorUpgrades.Attachment;
		this.m.ID = "legend_armor_upgrade.body.lewd_piercing_chains";
		this.m.Name = "Piercing Chains";
		this.m.Description = "Delicate gold chains connecting intimate piercings across the torso. They chime softly with every movement, a sound that makes men lose their train of thought. The deeper one surrenders, the more powerful they become.";
		this.m.ArmorDescription = "Gold piercing chains";
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 2000;
		this.m.Condition = 10;
		this.m.ConditionMax = 10;
		this.m.StaminaModifier = -1;
		this.m.IsDroppedAsLoot = true;
	}

	function updateVariant()
	{
		// Attachment layer: front and back use same sprite
		this.m.SpriteFront = "bust_lewd_piercing_chains_01_front";
		this.m.SpriteBack = "bust_lewd_piercing_chains_01_back";
		this.m.SpriteDamagedFront = "bust_lewd_piercing_chains_01_front";
		this.m.SpriteDamagedBack = "bust_lewd_piercing_chains_01_back";
		this.m.SpriteCorpseFront = "";
		this.m.SpriteCorpseBack = "bust_lewd_piercing_chains_01_dead";
		this.m.Icon = "legend_armor/icon_lewd_piercing_chains_01.png";
		this.m.IconLarge = "legend_armor/inventory_lewd_piercing_chains_01.png";
		this.m.OverlayIcon = "legend_armor/overlay_lewd_piercing_chains_01.png";
		this.m.OverlayIconLarge = "legend_armor/inventory_lewd_piercing_chains_01.png";
	}

	function getLewdTooltipDetail( _result )
	{
		local C = ::Lewd.Const;
		local subText = " (scales with Sub score)";
		_result.push({ id = 20, type = "text", icon = "ui/icons/allure.png",
			text = "Allure [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.ClothingPiercingChainsAllureBase + " to +" + (C.ClothingPiercingChainsAllureBase + C.ClothingPiercingChainsAllureScale) + "[/color]" + subText
		});
		_result.push({ id = 21, type = "text", icon = "ui/icons/bravery.png",
			text = "Resolve [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.ClothingPiercingChainsResolveBase + " to +" + (C.ClothingPiercingChainsResolveBase + C.ClothingPiercingChainsResolveScale) + "[/color]" + subText
		});
		_result.push({ id = 22, type = "text", icon = "ui/icons/initiative.png",
			text = "Initiative [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.ClothingPiercingChainsInitiativeBase + " to +" + (C.ClothingPiercingChainsInitiativeBase + C.ClothingPiercingChainsInitiativeScale) + "[/color]" + subText
		});
		_result.push({ id = 23, type = "text", icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + C.ClothingPiercingChainsHornyChanceBase + "-" + (C.ClothingPiercingChainsHornyChanceBase + C.ClothingPiercingChainsHornyChanceScale) + "%[/color] chance to inflict Horny on attacker when hit" + subText
		});
		_result.push({ id = 24, type = "text", icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]+" + C.ClothingPiercingChainsSelfPleasure + "[/color] self-pleasure per turn"
		});
		_result.push({ id = 25, type = "text", icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]+" + this.Math.floor(C.ClothingPiercingChainsPainToPleasure * 100) + "%[/color] pain-to-pleasure conversion"
		});
	}

	function getTooltip()
	{
		local result = this.legend_armor_upgrade.getTooltip();
		this.getLewdTooltipDetail(result);
		return result;
	}

	function onArmorTooltip( _result )
	{
		this.legend_armor_upgrade.onArmorTooltip(_result);
		_result.push({ id = 20, type = "text", icon = "ui/icons/special.png",
			text = "Allure, Resolve, Init, Horny when hit (scales with Sub). +Pleasure/turn, +Pain-to-pleasure"
		});
	}

	function onUpdateProperties( _properties )
	{
		this.legend_armor_upgrade.onUpdateProperties(_properties);
		local actor = this.getContainer().getActor();
		local sub = ::Lewd.Mastery.getSubScore(actor);
		local cap = ::Lewd.Const.DomSubCap.tofloat();

		_properties.Allure += ::Lewd.Const.ClothingPiercingChainsAllureBase + this.Math.floor(sub * ::Lewd.Const.ClothingPiercingChainsAllureScale / cap);
		_properties.Bravery += ::Lewd.Const.ClothingPiercingChainsResolveBase + this.Math.floor(sub * ::Lewd.Const.ClothingPiercingChainsResolveScale / cap);
		_properties.Initiative += ::Lewd.Const.ClothingPiercingChainsInitiativeBase + this.Math.floor(sub * ::Lewd.Const.ClothingPiercingChainsInitiativeScale / cap);
		_properties.PainToPleasureRate += ::Lewd.Const.ClothingPiercingChainsPainToPleasure;
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		if (actor.isAlive() && actor.getPleasureMax() > 0)
		{
			actor.addPleasure(::Lewd.Const.ClothingPiercingChainsSelfPleasure);
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + "'s piercing chains tug with every movement (+" + ::Lewd.Const.ClothingPiercingChainsSelfPleasure + " pleasure)");
		}
	}

	function onBeingHit( _attacker, _skill, _hitInfo )
	{
		if (_attacker == null || !_attacker.isAlive()) return;
		if (_attacker.getSkills().hasSkill("effects.lewd_horny")) return;

		local actor = this.getContainer().getActor();
		local sub = ::Lewd.Mastery.getSubScore(actor);
		local cap = ::Lewd.Const.DomSubCap.tofloat();
		local chance = ::Lewd.Const.ClothingPiercingChainsHornyChanceBase + this.Math.floor(sub * ::Lewd.Const.ClothingPiercingChainsHornyChanceScale / cap);

		if (this.Math.rand(1, 100) <= chance)
		{
			_attacker.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_attacker) + " is distracted by " + this.Const.UI.getColorizedEntityName(actor) + "'s chains");
		}
	}
});
