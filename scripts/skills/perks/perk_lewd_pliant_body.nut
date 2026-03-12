// Pliant Body: +50% enemy self-pleasure when they sex you, mounter fatigue drain, horny lock while mounting you, fatigue recovery on being sexed, -25% own sex ability fatigue cost
// Checked in male_sex_skill.onHit, male_force_oral_skill.onHit, lewd_mounted_effect.onTurnEnd, lewd_horny_effect.onTurnEnd, female_sex_skill.getFatigueCost
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
