// Drained Tier 1 — Sapped
this.drained_first <- this.inherit("scripts/skills/traits/drained_trait", {
	m = {},
	function create()
	{
		this.drained_trait.create();
		this.m.ID = "trait.drained_first";
		this.m.Name = "Sapped";
		this.m.Icon = "ui/traits/drained_first_trait.png"; // TODO: generate icon
		this.m.Description = "Something vital has been taken. Thoughts come slower and a strange fixation lingers, but the body endures and pain feels distant.";
		this.m.Excluded = [
			"trait.drained_second",
			"trait.drained_third",
		];
		this.m.XPMult = ::Lewd.Const.DrainedFirstXPMult;
		this.m.MeleeSkillPenalty = -::Lewd.Const.DrainedFirstMeleeSkill;
		this.m.RangedSkillPenalty = -::Lewd.Const.DrainedFirstRangedSkill;
		this.m.HitpointsBonus = ::Lewd.Const.DrainedFirstHitpoints;
		this.m.BraveryBonus = ::Lewd.Const.DrainedFirstBravery;
		this.m.DailyWageMult = ::Lewd.Const.DrainedFirstDailyWageMult;
		this.m.WagePct = 10;
		this.m.XPPct = 15;
	}
});
