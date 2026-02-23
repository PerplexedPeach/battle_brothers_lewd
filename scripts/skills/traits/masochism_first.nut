// Masochism Tier 1 — Likes Pain
this.masochism_first <- this.inherit("scripts/skills/traits/masochism_trait", {
	m = {},
	function create()
	{
		this.masochism_trait.create();
		this.m.ID = "trait.masochism_first";
		this.m.Name = "Likes Pain";
		this.m.Description = "You take pleasure in your own suffering, gaining strength from pain.";
		this.m.Icon = "ui/traits/masochism_first_trait.png";
		this.m.Excluded = [
			"trait.masochism_second",
			"trait.masochism_third",
		];
		this.m.DefensePenalty = 5;
		this.m.NegStatusDuration = 1;
		this.m.DamageReductionMult = 0.8;
		this.m.DamageReductionPct = 80;
		this.m.PleasureFromDamagePct = 10;
		this.m.AllureBonus = ::Lewd.Const.AllureFromMasochismFirst;
		this.m.PleasureMaxBonus = ::Lewd.Const.PleasureMaxFromMasochismFirst;
		this.m.PleasureFromDamageRate = ::Lewd.Const.PleasureFromDamageMasochismFirst;
		this.m.HeadBrush = "piercing_nose";
		this.m.DamageLogText = "feels a rush of pleasure from the pain";
	}
});
