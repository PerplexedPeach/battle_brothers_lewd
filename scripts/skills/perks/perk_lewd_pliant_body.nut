// Pliant Body: -20% self-pleasure from all sex acts
// Checked directly in skill scripts via actor.getSkills().hasSkill("perk.lewd_pliant_body")
this.perk_lewd_pliant_body <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_pliant_body";
		this.m.Name = ::Const.Strings.PerkName.LewdPliantBody;
		this.m.Description = ::Const.Strings.PerkDescription.LewdPliantBody;
		this.m.Icon = "ui/perks/lewd_pliant_body.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
});
