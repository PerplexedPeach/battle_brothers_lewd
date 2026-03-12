// Conqueror: T7 Debauchery — morale boost + fatigue restore + dom bonus on causing climax,
// mounted targets get additional Resolve penalty
this.perk_lewd_conqueror <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_conqueror";
		this.m.Name = ::Const.Strings.PerkName.LewdConqueror;
		this.m.Description = ::Const.Strings.PerkDescription.LewdConqueror;
		this.m.Icon = "ui/perks/lewd_conqueror.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	// Mounted Resolve penalty is applied via hook on lewd_mounted_effect onUpdate
	// Climax rewards (morale, fatigue, dom) are triggered in climax_effect.onAdded() hook
});
