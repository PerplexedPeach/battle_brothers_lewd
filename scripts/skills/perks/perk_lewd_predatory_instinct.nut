// Predatory Instinct: +10% hit and +15% damage vs Horny targets (regular attacks)
// Hit bonus applied via onBeingAttacked hook in mod_lewd.nut (target-side defense reduction)
// Damage bonus applied via onDamageReceived hook in mod_lewd.nut
this.perk_lewd_predatory_instinct <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_predatory_instinct";
		this.m.Name = ::Const.Strings.PerkName.LewdPredatoryInstinct;
		this.m.Description = ::Const.Strings.PerkDescription.LewdPredatoryInstinct;
		this.m.Icon = "ui/perks/lewd_predatory_instinct.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
});
