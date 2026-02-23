// Masochism Tier 2 — Masochist
this.masochism_second <- this.inherit("scripts/skills/traits/masochism_trait", {
	m = {},
	function create()
	{
		this.masochism_trait.create();
		this.m.ID = "trait.masochism_second";
		this.m.Name = "Masochist";
		this.m.Description = "You enjoy pain, getting hit, and losing in general.";
		this.m.Icon = "ui/traits/masochism_second_trait.png";
		this.m.Excluded = [
			"trait.masochism_first",
			"trait.masochism_third",
		];
		this.m.DefensePenalty = 10;
		this.m.NegStatusDuration = 2;
		this.m.DamageReductionMult = 0.6;
		this.m.DamageReductionPct = 60;
		this.m.PleasureFromDamagePct = 20;
		this.m.HasPhysicalResist = true;
		this.m.AllureBonus = ::Lewd.Const.AllureFromMasochismSecond;
		this.m.PleasureMaxBonus = ::Lewd.Const.PleasureMaxFromMasochismSecond;
		this.m.PleasureFromDamageRate = ::Lewd.Const.PleasureFromDamageMasochismSecond;
		this.m.HeadBrush = "piercing_nose_mouth";
		this.m.DamageLogText = "revels in the pain";
	}
});
