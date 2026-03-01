this.perk_lewd_willing_victim <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_willing_victim";
		this.m.Name = ::Const.Strings.PerkName.LewdWillingVictim;
		this.m.Description = ::Const.Strings.PerkDescription.LewdWillingVictim;
		this.m.Icon = "ui/perks/lewd_willing_victim.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.PleasureMax += ::Lewd.Const.WillingVictimPleasureMax;

		local actor = this.getContainer().getActor();
		if (actor.getSkills().hasSkill("effects.lewd_mounted") || actor.getSkills().hasSkill("effects.legend_grappled"))
		{
			_properties.Allure += ::Lewd.Const.WillingVictimAllure;
		}
	}
});
