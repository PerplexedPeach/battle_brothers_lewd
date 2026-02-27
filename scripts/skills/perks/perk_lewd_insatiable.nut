// Insatiable: +3 AP when you actively bring someone to climax
// Checked in climax_effect onAdded via LastPleasureSourceID tracking
this.perk_lewd_insatiable <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_insatiable";
		this.m.Name = ::Const.Strings.PerkName.LewdInsatiable;
		this.m.Description = ::Const.Strings.PerkDescription.LewdInsatiable;
		this.m.Icon = "ui/perks/lewd_insatiable.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
});
