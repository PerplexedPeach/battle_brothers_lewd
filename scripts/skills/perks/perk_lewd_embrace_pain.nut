this.perk_lewd_embrace_pain <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_embrace_pain";
		this.m.Name = ::Const.Strings.PerkName.LewdEmbracePain;
		this.m.Description = ::Const.Strings.PerkDescription.LewdEmbracePain;
		this.m.Icon = "ui/perks/lewd_embrace_pain.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.PleasureMax += ::Lewd.Const.EmbracePainPleasureMax;
	}
});
