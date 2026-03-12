// Carnal Knowledge: T3 Debauchery — unlocks Penetrate Vaginal + Force Oral without Horny
this.perk_lewd_carnal_knowledge <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_carnal_knowledge";
		this.m.Name = ::Const.Strings.PerkName.LewdCarnalKnowledge;
		this.m.Description = ::Const.Strings.PerkDescription.LewdCarnalKnowledge;
		this.m.Icon = "ui/perks/lewd_carnal_knowledge.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("actives.male_penetrate_vaginal"))
		{
			actor.getSkills().add(this.new("scripts/skills/actives/male_penetrate_vaginal_skill"));
		}
		if (!actor.getSkills().hasSkill("actives.male_force_oral"))
		{
			actor.getSkills().add(this.new("scripts/skills/actives/male_force_oral_skill"));
		}
		// TODO: add male penetration mastery effect when implemented
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("effects.lewd_horny"))
		{
			this.getContainer().removeByID("actives.male_penetrate_vaginal");
			this.getContainer().removeByID("actives.male_force_oral");
		}
	}
});
