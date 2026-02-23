// Transcendence: Own Climax removes AP/MelDef penalties, gives +10 Allure instead
// Checked in climax_effect onUpdate to modify stat changes
this.perk_lewd_transcendence <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_transcendence";
		this.m.Name = ::Const.Strings.PerkName.LewdTranscendence;
		this.m.Description = ::Const.Strings.PerkDescription.LewdTranscendence;
		this.m.Icon = "ui/perks/lewd_transcendence.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
});
