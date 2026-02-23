// Sensual Focus: +10% pleasure dealt by all sex abilities
// Checked directly in skill scripts via actor.getSkills().hasSkill("perk.lewd_sensual_focus")
this.perk_lewd_sensual_focus <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_sensual_focus";
		this.m.Name = ::Const.Strings.PerkName.LewdSensualFocus;
		this.m.Description = ::Const.Strings.PerkDescription.LewdSensualFocus;
		this.m.Icon = "ui/perks/lewd_sensual_focus.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
});
