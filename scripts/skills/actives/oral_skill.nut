// Oral skill — Clumsy Oral (T1) -> Oral Service (T2) -> Deepthroat (T3)
// Scales with Resolve and Allure
this.oral_skill <- this.inherit("scripts/skills/actives/lewd_sex_skill", {
	m = {},
	function create()
	{
		this.lewd_sex_skill.create();
		this.m.ID = "actives.lewd_oral";
		this.m.MasteryID = "effects.lewd_mastery_oral";
		this.m.PerkID = "perk.lewd_oral_arts";
		this.m.ScalingText = "Resolve and Allure";
		this.m.T3Debuff = { Resolve = ::Lewd.Const.OralT3ResolveDebuff, Duration = ::Lewd.Const.OralT3DebuffDuration };
		this.m.Tiers = [
			{
				Name = "Clumsy Oral",
				Description = "Clumsily use your mouth to pleasure the target.",
				Icon = "skills/lewd_oral.png",
				IconDisabled = "skills/lewd_oral_bw.png",
				Overlay = "lewd_oral",
				AP = ::Lewd.Const.OralT1AP,
				Fatigue = ::Lewd.Const.OralT1Fatigue,
				BasePleasure = ::Lewd.Const.OralT1BasePleasure,
				BaseHitChance = ::Lewd.Const.OralT1BaseHitChance,
				ResolveScale = ::Lewd.Const.OralT1ResolveScale,
				AllureScale = ::Lewd.Const.OralT1AllureScale,
				MountBonus = 0
			},
			{
				Name = "Oral Service",
				Description = "Service the target with practiced oral technique.",
				Icon = "skills/lewd_oral.png",
				IconDisabled = "skills/lewd_oral_bw.png",
				Overlay = "lewd_oral",
				AP = ::Lewd.Const.OralT2AP,
				Fatigue = ::Lewd.Const.OralT2Fatigue,
				BasePleasure = ::Lewd.Const.OralT2BasePleasure,
				BaseHitChance = ::Lewd.Const.OralT2BaseHitChance,
				ResolveScale = ::Lewd.Const.OralT2ResolveScale,
				AllureScale = ::Lewd.Const.OralT2AllureScale,
				MountBonus = ::Lewd.Const.OralT2MountBonus
			},
			{
				Name = "Deepthroat",
				Description = "Take it all the way, dealing heavy pleasure and shaking the target's resolve.",
				Icon = "skills/lewd_oral.png",
				IconDisabled = "skills/lewd_oral_bw.png",
				Overlay = "lewd_oral",
				AP = ::Lewd.Const.OralT3AP,
				Fatigue = ::Lewd.Const.OralT3Fatigue,
				BasePleasure = ::Lewd.Const.OralT3BasePleasure,
				BaseHitChance = ::Lewd.Const.OralT3BaseHitChance,
				ResolveScale = ::Lewd.Const.OralT3ResolveScale,
				AllureScale = ::Lewd.Const.OralT3AllureScale,
				MountBonus = ::Lewd.Const.OralT3MountBonus
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
		if (pts >= ::Lewd.Const.MasteryOralFatigueThreshold)
			fat += ::Lewd.Const.MasteryOralFatigueBonus;
		return this.Math.max(1, fat);
	}

	function calculateStatPleasure( _target )
	{
		local user = this.getContainer().getActor();
		local cfg = this.getTierConfig();
		return this.Math.floor(user.getBravery() * cfg.ResolveScale) + this.Math.floor(user.allure() * cfg.AllureScale);
	}

	function calculateMasteryPleasureBonus()
	{
		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryOralPleasureThreshold)
			return ::Lewd.Const.MasteryOralPleasureBonus;
		return 0;
	}

	function getSelfPleasure()
	{
		local tier = this.getTier();
		if (tier >= 3) return ::Lewd.Const.OralT3SelfPleasure;
		if (tier >= 2) return ::Lewd.Const.OralT2SelfPleasure;
		// T1: handled via probabilistic roll in onHit
		return 0;
	}

	function onHit( _user, _target )
	{
		// T1: probabilistic self-pleasure before base hook
		if (this.getTier() == 1 && this.Math.rand(1, 100) <= ::Lewd.Const.OralT1SelfPleasureChance)
		{
			local selfP = ::Lewd.Const.OralT1SelfPleasureAmount;
			if (selfP > 0 && _user.getPleasureMax() > 0)
				_user.addPleasure(selfP);
		}
		this.lewd_sex_skill.onHit(_user, _target);
	}

	function getTooltip()
	{
		local result = this.lewd_sex_skill.getTooltip();
		if (this.getTier() >= 3)
		{
			result.push({
				id = 7,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "Applies [color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.OralT3ResolveDebuff + "[/color] Resolve debuff for " + ::Lewd.Const.OralT3DebuffDuration + " turn"
			});
		}
		return result;
	}
});
