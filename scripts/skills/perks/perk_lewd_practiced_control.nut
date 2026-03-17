// Practiced Control: -50% self-pleasure reflection + -25% fatigue cost on sex abilities
// SelfPleasureMult and SexFatigueMult set via onUpdate
this.perk_lewd_practiced_control <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_practiced_control";
		this.m.Name = ::Const.Strings.PerkName.LewdPracticedControl;
		this.m.Description = ::Const.Strings.PerkDescription.LewdPracticedControl;
		this.m.Icon = "ui/perks/lewd_practiced_control.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.SelfPleasureMult *= ::Lewd.Const.PracticedControlReflectionMult;
		_properties.SexFatigueMult *= ::Lewd.Const.PracticedControlFatigueMult;
	}
});
