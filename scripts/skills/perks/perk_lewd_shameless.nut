// Shameless: Own Climax dazes adjacent enemies + deals pleasure to sex partner
// Hooks into climax_effect onAdded to apply daze and partner pleasure
this.perk_lewd_shameless <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_shameless";
		this.m.Name = ::Const.Strings.PerkName.LewdShameless;
		this.m.Description = ::Const.Strings.PerkDescription.LewdShameless;
		this.m.Icon = "ui/perks/lewd_shameless.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
});
