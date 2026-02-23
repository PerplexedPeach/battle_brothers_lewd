// Experienced Lover: +50% mastery point gain rate
// Checked in lewd_mastery_effect.addPoints() via actor.getSkills().hasSkill("perk.lewd_experienced_lover")
this.perk_lewd_experienced_lover <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_experienced_lover";
		this.m.Name = ::Const.Strings.PerkName.LewdExperiencedLover;
		this.m.Description = ::Const.Strings.PerkDescription.LewdExperiencedLover;
		this.m.Icon = "ui/perks/lewd_experienced_lover.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
});
