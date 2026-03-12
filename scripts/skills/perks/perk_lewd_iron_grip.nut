// Iron Grip: T6 Debauchery — grants Restrain active skill
this.perk_lewd_iron_grip <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_iron_grip";
		this.m.Name = ::Const.Strings.PerkName.LewdIronGrip;
		this.m.Description = ::Const.Strings.PerkDescription.LewdIronGrip;
		this.m.Icon = "ui/perks/lewd_iron_grip.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("actives.lewd_restrain"))
		{
			actor.getSkills().add(this.new("scripts/skills/actives/restrain_skill"));
		}
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.lewd_restrain");
	}
});
