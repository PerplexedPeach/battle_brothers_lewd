// Drained Tier 2 — Drained
this.drained_second <- this.inherit("scripts/skills/traits/drained_trait", {
	m = {},
	function create()
	{
		this.drained_trait.create();
		this.m.ID = "trait.drained_second";
		this.m.Name = "Drained";
		this.m.Icon = "ui/traits/drained_second_trait.png"; // TODO: generate icon
		this.m.Description = "Eyes glazed and thoughts clouded, every waking moment is consumed by thoughts of her. They obey without hesitation, endure without complaint, and ask for nothing in return.";
		this.m.Excluded = [
			"trait.drained_first",
			"trait.drained_third",
		];
		this.m.XPMult = ::Lewd.Const.DrainedSecondXPMult;
		this.m.MeleeSkillPenalty = -::Lewd.Const.DrainedSecondMeleeSkill;
		this.m.RangedSkillPenalty = -::Lewd.Const.DrainedSecondRangedSkill;
		this.m.HitpointsBonus = ::Lewd.Const.DrainedSecondHitpoints;
		this.m.BraveryBonus = ::Lewd.Const.DrainedSecondBravery;
		this.m.DailyWageMult = ::Lewd.Const.DrainedSecondDailyWageMult;
		this.m.WagePct = 25;
		this.m.XPPct = 35;
	}
});
