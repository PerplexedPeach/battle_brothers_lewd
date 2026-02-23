this.perk_lewd_offering <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_offering";
		this.m.Name = ::Const.Strings.PerkName.LewdOffering;
		this.m.Description = ::Const.Strings.PerkDescription.LewdOffering;
		this.m.Icon = "ui/perks/lewd_offering.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("actives.lewd_anal"))
		{
			actor.getSkills().add(this.new("scripts/skills/actives/anal_skill"));
		}
		if (!actor.getSkills().hasSkill("effects.lewd_mastery_anal"))
		{
			actor.getSkills().add(this.new("scripts/skills/effects/lewd_mastery_anal_effect"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.lewd_anal");
		this.getContainer().removeByID("effects.lewd_mastery_anal");
	}
});
