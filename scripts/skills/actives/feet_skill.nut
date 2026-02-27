// Feet skill — Foot Tease (T1) -> Footjob (T2) -> Heel Domination (T3)
// Scales with heelSkill flag (heel system synergy)
this.feet_skill <- this.inherit("scripts/skills/actives/lewd_sex_skill", {
	m = {},
	function create()
	{
		this.lewd_sex_skill.create();
		this.m.ID = "actives.lewd_feet";
		this.m.MasteryID = "effects.lewd_mastery_feet";
		this.m.PerkID = "perk.lewd_foot_tease";
		this.m.ScalingText = "Heel Skill";
		this.m.T3Debuff = { MelDef = ::Lewd.Const.FeetT3MelDefDebuff, Duration = ::Lewd.Const.FeetT3DebuffDuration };
		this.m.Tiers = [
			{
				Name = "Foot Tease",
				Description = "Tease the target with your feet, dealing a small amount of pleasure.",
				Icon = "skills/lewd_feet_t1.png",
				IconDisabled = "skills/lewd_feet_t1_bw.png",
				Overlay = "lewd_feet_t1",
				AP = ::Lewd.Const.FeetT1AP,
				Fatigue = ::Lewd.Const.FeetT1Fatigue,
				BasePleasure = ::Lewd.Const.FeetT1BasePleasure,
				BaseHitChance = ::Lewd.Const.FeetT1BaseHitChance,
				HeelSkillScale = ::Lewd.Const.FeetT1HeelSkillScale,
				MountBonus = 0,
				HitText = ["teases with her toes", "playfully nudges"],
				MissText = ["tease", "nudge"]
			},
			{
				Name = "Footjob",
				Description = "Use your feet to pleasure the target with skilled movements.",
				Icon = "skills/lewd_feet_t2.png",
				IconDisabled = "skills/lewd_feet_t2_bw.png",
				Overlay = "lewd_feet_t2",
				AP = ::Lewd.Const.FeetT2AP,
				Fatigue = ::Lewd.Const.FeetT2Fatigue,
				BasePleasure = ::Lewd.Const.FeetT2BasePleasure,
				BaseHitChance = ::Lewd.Const.FeetT2BaseHitChance,
				HeelSkillScale = ::Lewd.Const.FeetT2HeelSkillScale,
				MountBonus = ::Lewd.Const.FeetT2MountBonus,
				HitText = ["gives a footjob to", "works her feet on"],
				MissText = ["rub", "stroke"]
			},
			{
				Name = "Heel Domination",
				Description = "Dominate the target with your heels, dealing heavy pleasure and reducing their defenses.",
				Icon = "skills/lewd_feet_t3.png",
				IconDisabled = "skills/lewd_feet_t3_bw.png",
				Overlay = "lewd_feet_t3",
				AP = ::Lewd.Const.FeetT3AP,
				Fatigue = ::Lewd.Const.FeetT3Fatigue,
				BasePleasure = ::Lewd.Const.FeetT3BasePleasure,
				BaseHitChance = ::Lewd.Const.FeetT3BaseHitChance,
				HeelSkillScale = ::Lewd.Const.FeetT3HeelSkillScale,
				MountBonus = ::Lewd.Const.FeetT3MountBonus,
				HitText = ["grinds her heel into", "dominates with her heels"],
				MissText = ["dominate", "grind into"]
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

	function getFatigueCost()
	{
		local fat = this.getTierConfig().Fatigue;
		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryFeetFatigueThreshold)
			fat += ::Lewd.Const.MasteryFeetFatigueBonus;
		return this.Math.max(1, fat);
	}

	function getHitChanceAgainst( _target )
	{
		if (this.isAutoHit(_target)) return 100;

		local user = this.getContainer().getActor();
		local allure = user.allure();
		local resolve = _target.getBravery();

		// Feet mastery: ignore portion of resolve
		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryFeetResolveIgnoreThreshold)
			resolve = this.Math.floor(resolve * (1.0 - ::Lewd.Const.MasteryFeetResolveIgnorePct));

		local chance = this.getBaseHitChance() + (allure - resolve) * ::Lewd.Const.SexHitChanceAllureResolveScale;
		return this.Math.max(::Lewd.Const.SexHitChanceMin, this.Math.min(::Lewd.Const.SexHitChanceMax, chance));
	}

	function calculateStatPleasure( _target )
	{
		local user = this.getContainer().getActor();
		local heelSkill = user.getFlags().getAsInt("heelSkill");
		local pleasure = this.Math.floor(heelSkill * this.getTierConfig().HeelSkillScale);

		// T3 heel height scaling
		if (this.getTier() >= 3)
		{
			local heelHeight = user.getFlags().getAsInt("heelHeight");
			pleasure += this.Math.floor(heelHeight * ::Lewd.Const.FeetT3HeelHeightScale);
		}

		return pleasure;
	}

	function calculateMasteryPleasureBonus()
	{
		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryFeetPleasureThreshold)
			return ::Lewd.Const.MasteryFeetPleasureBonus;
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
				icon = "ui/icons/melee_defense.png",
				text = "Applies [color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.FeetT3MelDefDebuff + "[/color] Melee Defense debuff for " + ::Lewd.Const.FeetT3DebuffDuration + " turn"
			});
		}
		return result;
	}
});
