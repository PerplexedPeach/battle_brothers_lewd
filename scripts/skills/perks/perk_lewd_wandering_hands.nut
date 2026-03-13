// Wandering Hands: T1 Debauchery — unlocks Grope without Horny, grants grope mastery
this.perk_lewd_wandering_hands <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_wandering_hands";
		this.m.Name = ::Const.Strings.PerkName.LewdWanderingHands;
		this.m.Description = ::Const.Strings.PerkDescription.LewdWanderingHands;
		this.m.Icon = "ui/perks/lewd_wandering_hands.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("actives.male_grope"))
		{
			actor.getSkills().add(this.new("scripts/skills/actives/male_grope_skill"));
		}
		if (!actor.getSkills().hasSkill("effects.male_mastery_grope"))
		{
			actor.getSkills().add(this.new("scripts/skills/effects/male_mastery_grope_effect"));
		}
	}

	function onRemoved()
	{
		// Only remove if not horny (horny also grants these)
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("effects.lewd_horny"))
		{
			this.getContainer().removeByID("actives.male_grope");
		}
	}
});
