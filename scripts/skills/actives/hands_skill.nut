// Hands skill — Clumsy Groping (T1) -> Handjob (T2) -> Skilled Handjob (T3)
// Scales with Melee Skill
this.hands_skill <- this.inherit("scripts/skills/actives/lewd_sex_skill", {
	m = {},
	function create()
	{
		this.lewd_sex_skill.create();
		this.m.ID = "actives.lewd_hands";
		this.m.SexType = "hands";
		this.m.MasteryID = "effects.lewd_mastery_hands";
		this.m.PerkID = "perk.lewd_nimble_fingers";
		this.m.ScalingText = "Melee Skill and Dominance";
		this.m.T3Debuff = { Init = ::Lewd.Const.HandsT3InitDebuff, Duration = ::Lewd.Const.HandsT3DebuffDuration };
		this.m.Tiers = [
			{
				Name = "Clumsy Groping",
				Description = "Clumsily grope the target, dealing a small amount of pleasure.",
				Icon = "skills/lewd_hands_t1.png",
				IconDisabled = "skills/lewd_hands_t1_bw.png",
				Overlay = "lewd_hands_t1",
				AP = ::Lewd.Const.HandsT1AP,
				Fatigue = ::Lewd.Const.HandsT1Fatigue,
				BasePleasure = ::Lewd.Const.HandsT1BasePleasure,
				BaseHitChance = ::Lewd.Const.HandsT1BaseHitChance,
				MeleeSkillScale = ::Lewd.Const.HandsT1MeleeSkillScale,
				DomScale = ::Lewd.Const.HandsT1DomScale,
				MountBonus = 0,
				HitText = ["clumsily gropes", "awkwardly fondles"],
				MissText = ["grope", "fondle"]
			},
			{
				Name = "Handjob",
				Description = "Use your hands to pleasure the target with practiced movements.",
				Icon = "skills/lewd_hands_t2.png",
				IconDisabled = "skills/lewd_hands_t2_bw.png",
				Overlay = "lewd_hands_t2",
				AP = ::Lewd.Const.HandsT2AP,
				Fatigue = ::Lewd.Const.HandsT2Fatigue,
				BasePleasure = ::Lewd.Const.HandsT2BasePleasure,
				BaseHitChance = ::Lewd.Const.HandsT2BaseHitChance,
				MeleeSkillScale = ::Lewd.Const.HandsT2MeleeSkillScale,
				DomScale = ::Lewd.Const.HandsT2DomScale,
				MountBonus = ::Lewd.Const.HandsT2MountBonus,
				HitText = ["strokes", "caresses"],
				MissText = ["stroke", "caress"]
			},
			{
				Name = "Skilled Handjob",
				Description = "Skillfully pleasure the target with expert hand technique, reducing their initiative.",
				Icon = "skills/lewd_hands_t3.png",
				IconDisabled = "skills/lewd_hands_t3_bw.png",
				Overlay = "lewd_hands_t3",
				AP = ::Lewd.Const.HandsT3AP,
				Fatigue = ::Lewd.Const.HandsT3Fatigue,
				BasePleasure = ::Lewd.Const.HandsT3BasePleasure,
				BaseHitChance = ::Lewd.Const.HandsT3BaseHitChance,
				MeleeSkillScale = ::Lewd.Const.HandsT3MeleeSkillScale,
				DomScale = ::Lewd.Const.HandsT3DomScale,
				MountBonus = ::Lewd.Const.HandsT3MountBonus,
				HitText = ["skillfully pleasures", "expertly edges"],
				MissText = ["pleasure", "edge"]
			}
		];
		this.m.Name = this.m.Tiers[0].Name;
		this.m.Description = this.m.Tiers[0].Description;
		this.m.Icon = this.m.Tiers[0].Icon;
		this.m.IconDisabled = this.m.Tiers[0].IconDisabled;
		this.m.Overlay = this.m.Tiers[0].Overlay;
		this.m.ActionPointCost = this.m.Tiers[0].AP;
		this.m.FatigueCost = this.m.Tiers[0].Fatigue;
	}

	function getAPCost()
	{
		local ap = this.getTierConfig().AP;
		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryHandsAPThreshold)
			ap += ::Lewd.Const.MasteryHandsAPBonus;
		return this.Math.max(1, ap);
	}

	function getHitChanceAgainst( _target )
	{
		if (this.isAutoHit(_target)) return 100;

		local user = this.getContainer().getActor();
		local allure = user.allure();
		local resolve = _target.getBravery();
		local chance = this.getBaseHitChance() + (allure - resolve) * ::Lewd.Const.SexHitChanceAllureResolveScale;

		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryHandsHitThreshold)
			chance += ::Lewd.Const.MasteryHandsHitBonus;

		return this.Math.max(::Lewd.Const.SexHitChanceMin, this.Math.min(::Lewd.Const.SexHitChanceMax, chance));
	}

	function calculateStatPleasure( _target )
	{
		local user = this.getContainer().getActor();
		local cfg = this.getTierConfig();
		local pleasure = this.Math.floor(user.getCurrentProperties().getMeleeSkill() * cfg.MeleeSkillScale);
		local domScore = ::Lewd.Mastery.getDomScore(user);
		if (domScore > 0)
			pleasure += this.Math.floor(domScore * cfg.DomScale);
		return pleasure;
	}

	function calculateMasteryPleasureBonus()
	{
		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryHandsPleasureThreshold)
			return ::Lewd.Const.MasteryHandsPleasureBonus;
		return 0;
	}

	function getTooltip()
	{
		local result = this.lewd_sex_skill.getTooltip();
		if (this.getTier() >= 3)
		{
			result.push({
				id = 7,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "Applies [color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.HandsT3InitDebuff + "[/color] Initiative debuff for " + ::Lewd.Const.HandsT3DebuffDuration + " turn"
			});
		}
		return result;
	}
});
