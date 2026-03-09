// Drained Tier 3 — Enthralled
this.drained_third <- this.inherit("scripts/skills/traits/drained_trait", {
	m = {},
	function create()
	{
		this.drained_trait.create();
		this.m.ID = "trait.drained_third";
		this.m.Name = "Enthralled";
		this.m.Icon = "ui/traits/drained_third_trait.png";
		this.m.Description = "Utterly devoted, body and soul. They exist only to serve and protect her, throwing themselves into danger without a second thought. Whatever person they once were has been consumed by mindless, absolute obsession.";
		this.m.Excluded = [
			"trait.drained_first",
			"trait.drained_second",
		];
		this.m.XPMult = ::Lewd.Const.DrainedThirdXPMult;
		this.m.MeleeSkillPenalty = -::Lewd.Const.DrainedThirdMeleeSkill;
		this.m.RangedSkillPenalty = -::Lewd.Const.DrainedThirdRangedSkill;
		this.m.HitpointsBonus = ::Lewd.Const.DrainedThirdHitpoints;
		this.m.BraveryBonus = ::Lewd.Const.DrainedThirdBravery;
		this.m.DailyWageMult = ::Lewd.Const.DrainedThirdDailyWageMult;
		this.m.WagePct = 100;
		this.m.XPPct = 40;
	}
});
