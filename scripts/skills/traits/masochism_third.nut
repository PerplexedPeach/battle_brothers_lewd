// Masochism Tier 3 — Pain Slut
this.masochism_third <- this.inherit("scripts/skills/traits/masochism_trait", {
	m = {},
	function create()
	{
		this.masochism_trait.create();
		this.m.ID = "trait.masochism_third";
		this.m.Name = "Pain Slut";
		this.m.Description = "You love pain and subjecting yourself to nasty experiences. You are the ultimate masochist.";
		this.m.Icon = "ui/traits/masochism_third_trait.png";
		this.m.Excluded = [
			"trait.masochism_first",
			"trait.masochism_second",
		];
		this.m.DefensePenalty = 15;
		this.m.NegStatusDuration = 2;
		this.m.DamageReductionMult = 0.5;
		this.m.DamageReductionPct = 50;
		this.m.PleasureFromDamagePct = 30;
		this.m.HasPhysicalResist = true;
		this.m.HasStunImmunity = true;
		this.m.AllureBonus = ::Lewd.Const.AllureFromMasochismThird;
		this.m.PleasureMaxBonus = ::Lewd.Const.PleasureMaxFromMasochismThird;
		this.m.PleasureFromDamageRate = ::Lewd.Const.PleasureFromDamageMasochismThird;
		this.m.HeadBrush = "piercing_nose_mouth";
		this.m.HasBodyPiercing = true;
		this.m.DamageLogText = "moans with pleasure from the pain";
	}
});
