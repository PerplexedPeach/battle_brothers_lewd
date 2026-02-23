// Pleasure Overflow: Enemy climax splashes 25% pleasure to adjacent enemies
// Checked in climax_effect onAdded via actor.getSkills().hasSkill("perk.lewd_pleasure_overflow")
this.perk_lewd_pleasure_overflow <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_pleasure_overflow";
		this.m.Name = ::Const.Strings.PerkName.LewdPleasureOverflow;
		this.m.Description = ::Const.Strings.PerkDescription.LewdPleasureOverflow;
		this.m.Icon = "ui/perks/lewd_pleasure_overflow.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
});
