// Sensual Focus: +10% pleasure dealt by all sex abilities + Open Invitation toggle
// Checked directly in skill scripts via actor.getSkills().hasSkill("perk.lewd_sensual_focus")
this.perk_lewd_sensual_focus <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_sensual_focus";
		this.m.Name = ::Const.Strings.PerkName.LewdSensualFocus;
		this.m.Description = ::Const.Strings.PerkDescription.LewdSensualFocus;
		this.m.Icon = "ui/perks/lewd_sensual_focus.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("actives.open_invitation"))
		{
			actor.getSkills().add(this.new("scripts/skills/actives/open_invitation_skill"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("effects.open_invitation");
		this.getContainer().removeByID("actives.open_invitation");
	}
});
