// Pain Feeds Pleasure: +100% masochism damage-to-pleasure rate, 20% damage reduction, +33% injury threshold
// Damage-to-pleasure checked in masochism trait onDamageReceived
// Injury threshold and damage reduction applied via onUpdate
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

	function onUpdate( _properties )
	{
		_properties.ThresholdToReceiveInjuryMult *= ::Lewd.Const.PainFeedsPleasureInjuryMult;
		_properties.DamageReceivedTotalMult *= ::Lewd.Const.PainFeedsPleasureDamageReductionMult;
	}
});
