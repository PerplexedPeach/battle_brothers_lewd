// Incubus Lewd Racial -- passive identifier + seal applicator
// The lewd_seal_effect checks for this skill ID to determine if climax was incubus-caused
this.incubus_lewd_racial <- this.inherit("scripts/skills/skill", {
	m = {
		SealApplied = false
	},
	function create()
	{
		this.m.ID = "racial.lewd_incubus";
		this.m.Name = "";
		this.m.Description = "";
		this.m.Type = this.Const.SkillType.Racial;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = false;
	}

	function onCombatStarted()
	{
		if (this.m.SealApplied) return;

		// Find the player character (the Transform target) and apply seal stage 1
		local woman = ::Lewd.Transform.target();
		if (woman == null) return;
		if (woman.getSkills().hasSkill("effects.lewd_seal")) return;

		woman.getSkills().add(this.new("scripts/skills/effects/lewd_seal_effect"));
		this.m.SealApplied = true;
		::logInfo("[incubus] Applied lewd seal stage 1 to " + woman.getName());
	}
});
