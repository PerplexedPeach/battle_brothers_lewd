this.perk_lewd_nimble_fingers <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_nimble_fingers";
		this.m.Name = ::Const.Strings.PerkName.LewdNimbleFingers;
		this.m.Description = ::Const.Strings.PerkDescription.LewdNimbleFingers;
		this.m.Icon = "ui/perks/lewd_nimble_fingers.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("actives.lewd_hands"))
		{
			actor.getSkills().add(this.new("scripts/skills/actives/hands_skill"));
		}
		if (!actor.getSkills().hasSkill("effects.lewd_mastery_hands"))
		{
			actor.getSkills().add(this.new("scripts/skills/effects/lewd_mastery_hands_effect"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.lewd_hands");
		this.getContainer().removeByID("effects.lewd_mastery_hands");
	}
});
