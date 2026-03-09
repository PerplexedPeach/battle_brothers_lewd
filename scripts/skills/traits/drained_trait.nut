// Base class for Drained traits (Sapped / Enthralled / Hollowed)
// Consequence of having essence drained by a succubus.
// Children set config values in create().
this.drained_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		XPMult = 1.0,
		MeleeSkillPenalty = 0,
		RangedSkillPenalty = 0,
		HitpointsBonus = 0,
		BraveryBonus = 0,
		DailyWageMult = 1.0,
		WagePct = 0,      // display value (e.g. 10 for -10%)
		XPPct = 0          // display value (e.g. 15 for -15%)
	},
	function create()
	{
		this.character_trait.create();
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
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
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.MeleeSkillPenalty + "[/color] Melee Skill"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.RangedSkillPenalty + "[/color] Ranged Skill"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.XPPct + "%[/color] Experience Gain"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.HitpointsBonus + "[/color] Hitpoints"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.BraveryBonus + "[/color] Resolve"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/asset_daily_money.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]-" + this.m.WagePct + "%[/color] Daily Wages"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += -this.m.MeleeSkillPenalty;
		_properties.RangedSkill += -this.m.RangedSkillPenalty;
		_properties.Hitpoints += this.m.HitpointsBonus;
		_properties.Bravery += this.m.BraveryBonus;
		_properties.XPGainMult *= this.m.XPMult;
		_properties.DailyWageMult *= this.m.DailyWageMult;
	}
});
