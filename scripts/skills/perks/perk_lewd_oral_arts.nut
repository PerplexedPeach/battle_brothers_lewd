this.perk_lewd_oral_arts <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_oral_arts";
		this.m.Name = ::Const.Strings.PerkName.LewdOralArts;
		this.m.Description = ::Const.Strings.PerkDescription.LewdOralArts;
		this.m.Icon = "ui/perks/lewd_oral_arts.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("actives.lewd_oral"))
		{
			actor.getSkills().add(this.new("scripts/skills/actives/oral_skill"));
		}
		if (!actor.getSkills().hasSkill("effects.lewd_mastery_oral"))
		{
			actor.getSkills().add(this.new("scripts/skills/effects/lewd_mastery_oral_effect"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.lewd_oral");
		this.getContainer().removeByID("effects.lewd_mastery_oral");
	}
});
