this.perk_lewd_alluring_presence <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_alluring_presence";
		this.m.Name = ::Const.Strings.PerkName.LewdAlluringPresence;
		this.m.Description = ::Const.Strings.PerkDescription.LewdAlluringPresence;
		this.m.Icon = "ui/perks/lewd_alluring_presence.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.Allure += ::Lewd.Const.AlluringPresenceAllure;
		_properties.PleasureMax += ::Lewd.Const.AlluringPresencePleasureMax;
	}
});
