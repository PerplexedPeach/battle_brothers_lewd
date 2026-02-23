this.perk_lewd_foot_tease <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_foot_tease";
		this.m.Name = ::Const.Strings.PerkName.LewdFootTease;
		this.m.Description = ::Const.Strings.PerkDescription.LewdFootTease;
		this.m.Icon = "ui/perks/lewd_foot_tease.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("actives.lewd_feet"))
		{
			actor.getSkills().add(this.new("scripts/skills/actives/feet_skill"));
		}
		if (!actor.getSkills().hasSkill("effects.lewd_mastery_feet"))
		{
			actor.getSkills().add(this.new("scripts/skills/effects/lewd_mastery_feet_effect"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.lewd_feet");
		this.getContainer().removeByID("effects.lewd_mastery_feet");
	}
});
