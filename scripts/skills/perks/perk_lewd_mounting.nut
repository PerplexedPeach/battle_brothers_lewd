this.perk_lewd_mounting <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_mounting";
		this.m.Name = ::Const.Strings.PerkName.LewdMounting;
		this.m.Description = ::Const.Strings.PerkDescription.LewdMounting;
		this.m.Icon = "ui/perks/lewd_mounting.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("actives.lewd_vaginal"))
		{
			actor.getSkills().add(this.new("scripts/skills/actives/vaginal_skill"));
		}
		if (!actor.getSkills().hasSkill("effects.lewd_mastery_vaginal"))
		{
			actor.getSkills().add(this.new("scripts/skills/effects/lewd_mastery_vaginal_effect"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.lewd_vaginal");
		this.getContainer().removeByID("effects.lewd_mastery_vaginal");
	}
});
