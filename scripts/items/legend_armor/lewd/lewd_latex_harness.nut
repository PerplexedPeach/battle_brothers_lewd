this.lewd_latex_harness <- this.inherit("scripts/items/legend_armor/legend_armor_upgrade", {
	m = {},
	function create()
	{
		this.legend_armor_upgrade.create();
		this.m.Type = this.Const.Items.ArmorUpgrades.Chain;
		this.m.ID = "legend_armor.body.lewd_latex_harness";
		this.m.Name = "Latex Harness";
		this.m.Description = "Straps of demon alp skin cured into a supple, form-fitting harness. The material clings to the body as if alive, warm to the touch and faintly luminous in low light. Those who command others find it amplifies their authority.";
		this.m.ArmorDescription = "A latex harness of demon alp skin";
		this.m.Variants = [1];
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Value = 2000;
		this.m.Condition = 15;
		this.m.ConditionMax = 15;
		this.m.StaminaModifier = -1;
		this.m.IsDroppedAsLoot = true;
	}

	function updateVariant()
	{
		// Chain layer: only needs SpriteBack
		this.m.SpriteBack = "bust_lewd_latex_harness_01";
		this.m.SpriteDamagedBack = "bust_lewd_latex_harness_01_damaged";
		this.m.SpriteCorpseBack = "bust_lewd_latex_harness_01_dead";
		this.m.Icon = "legend_armor/icon_lewd_latex_harness_01.png";
		this.m.IconLarge = "legend_armor/inventory_lewd_latex_harness_01.png";
		this.m.OverlayIcon = "legend_armor/overlay_lewd_latex_harness_01.png";
		this.m.OverlayIconLarge = "legend_armor/inventory_lewd_latex_harness_01.png";
	}

	function getLewdTooltipDetail( _result )
	{
		local C = ::Lewd.Const;
		local domText = " (scales with Dom score)";
		_result.push({ id = 20, type = "text", icon = "ui/icons/allure.png",
			text = "Allure [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.ClothingLatexHarnessAllureBase + " to +" + (C.ClothingLatexHarnessAllureBase + C.ClothingLatexHarnessAllureScale) + "[/color]" + domText
		});
		_result.push({ id = 21, type = "text", icon = "ui/icons/bravery.png",
			text = "Resolve [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.ClothingLatexHarnessResolveBase + " to +" + (C.ClothingLatexHarnessResolveBase + C.ClothingLatexHarnessResolveScale) + "[/color]" + domText
		});
		_result.push({ id = 22, type = "text", icon = "ui/icons/melee_defense.png",
			text = "Melee Defense [color=" + this.Const.UI.Color.PositiveValue + "]+" + C.ClothingLatexHarnessMeleeDefBase + " to +" + (C.ClothingLatexHarnessMeleeDefBase + C.ClothingLatexHarnessMeleeDefScale) + "[/color]" + domText
		});
		_result.push({ id = 23, type = "text", icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + C.ClothingLatexHarnessHornyChanceBase + "-" + (C.ClothingLatexHarnessHornyChanceBase + C.ClothingLatexHarnessHornyChanceScale) + "%[/color] chance to inflict Horny on hitting an enemy" + domText
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
			text = "Allure, Resolve, Melee Def, Horny on hit (scales with Dom)"
		});
	}

	function onUpdateProperties( _properties )
	{
		this.legend_armor_upgrade.onUpdateProperties(_properties);
		local actor = this.getContainer().getActor();
		local dom = ::Lewd.Mastery.getDomScore(actor);
		local cap = ::Lewd.Const.DomSubCap.tofloat();

		_properties.Allure += ::Lewd.Const.ClothingLatexHarnessAllureBase + this.Math.floor(dom * ::Lewd.Const.ClothingLatexHarnessAllureScale / cap);
		_properties.Bravery += ::Lewd.Const.ClothingLatexHarnessResolveBase + this.Math.floor(dom * ::Lewd.Const.ClothingLatexHarnessResolveScale / cap);
		_properties.MeleeDefense += ::Lewd.Const.ClothingLatexHarnessMeleeDefBase + this.Math.floor(dom * ::Lewd.Const.ClothingLatexHarnessMeleeDefScale / cap);
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity == null || !_targetEntity.isAlive()) return;
		if (_targetEntity.getSkills().hasSkill("effects.lewd_horny")) return;

		local actor = this.getContainer().getActor();
		local dom = ::Lewd.Mastery.getDomScore(actor);
		local cap = ::Lewd.Const.DomSubCap.tofloat();
		local chance = ::Lewd.Const.ClothingLatexHarnessHornyChanceBase + this.Math.floor(dom * ::Lewd.Const.ClothingLatexHarnessHornyChanceScale / cap);

		if (this.Math.rand(1, 100) <= chance)
		{
			_targetEntity.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " is overwhelmed by " + this.Const.UI.getColorizedEntityName(actor) + "'s presence");
		}
	}
});
