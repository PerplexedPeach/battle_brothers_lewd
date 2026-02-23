// Pain Feeds Pleasure: +50% masochism damage-to-pleasure rate
// Checked in masochism trait onDamageReceived via actor.getSkills().hasSkill("perk.lewd_pain_feeds_pleasure")
this.perk_lewd_pain_feeds_pleasure <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_pain_feeds_pleasure";
		this.m.Name = ::Const.Strings.PerkName.LewdPainFeedsPleasure;
		this.m.Description = ::Const.Strings.PerkDescription.LewdPainFeedsPleasure;
		this.m.Icon = "ui/perks/lewd_pain_feeds_pleasure.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
});
