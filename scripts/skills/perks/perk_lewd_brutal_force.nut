// Brutal Force: T4 Debauchery — +25% pleasure from male sex abilities, +1 orgasm threshold
// Pleasure mult is checked in male_sex_skill.calculatePleasure()
this.perk_lewd_brutal_force <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_brutal_force";
		this.m.Name = ::Const.Strings.PerkName.LewdBrutalForce;
		this.m.Description = ::Const.Strings.PerkDescription.LewdBrutalForce;
		this.m.Icon = "ui/perks/lewd_brutal_force.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	// Orgasm threshold bonus is applied in mastery.nut getOrgasmThreshold()
	// Pleasure multiplier is applied in male_sex_skill.calculatePleasure()
});
