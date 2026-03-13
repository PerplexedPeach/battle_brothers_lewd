// Forced Entry: T5 Debauchery — unlocks Penetrate Anal without Horny
this.perk_lewd_forced_entry <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_forced_entry";
		this.m.Name = ::Const.Strings.PerkName.LewdForcedEntry;
		this.m.Description = ::Const.Strings.PerkDescription.LewdForcedEntry;
		this.m.Icon = "ui/perks/lewd_forced_entry.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("actives.male_penetrate_anal"))
		{
			actor.getSkills().add(this.new("scripts/skills/actives/male_penetrate_anal_skill"));
		}
		if (!actor.getSkills().hasSkill("effects.male_mastery_anal"))
		{
			actor.getSkills().add(this.new("scripts/skills/effects/male_mastery_anal_effect"));
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("effects.lewd_horny"))
		{
			this.getContainer().removeByID("actives.male_penetrate_anal");
		}
	}
});
