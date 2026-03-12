// Allied Force Oral — triggered automatically when a horny male brother escalates harassment
// on a mounted female ally. Inherits from male_force_oral_skill.
// Overrides: targets allies instead of enemies, no self-pleasure, no horny application.
this.allied_force_oral_skill <- this.inherit("scripts/skills/actives/male_force_oral_skill", {
	m = {},
	function create()
	{
		this.male_force_oral_skill.create();
		this.m.ID = "actives.allied_force_oral";
		this.m.Name = "Force Oral";
		this.m.Description = "Overwhelmed by lust, forces himself on a mounted ally.";
		this.m.ActionPointCost = ::Lewd.Const.AlliedForceOralAP;
		this.m.FatigueCost = ::Lewd.Const.AlliedForceOralFatigue;
		this.m.BasePleasure = ::Lewd.Const.AlliedForceOralBasePleasure;
		this.m.MeleeSkillScale = 0.0;
		this.m.SelfPleasure = 0;
		this.m.HitText = ["forces himself on", "uses the mouth of"];
		this.m.MissText = ["force himself on", "use"];
	}

	function isHidden()
	{
		return true;
	}

	function isUsable()
	{
		local actor = this.getContainer().getActor();
		return this.m.IsUsable && actor.getCurrentProperties().IsAbleToUseSkills;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
		local target = _targetTile.getEntity();
		if (target == null) return false;
		if (!this.m.Container.getActor().isAlliedWith(target)) return false;
		if (target.getGender() != 1) return false;
		if (target.getPleasureMax() <= 0) return false;
		// Requires target to be mounted
		if (!target.getSkills().hasSkill("effects.lewd_mounted")) return false;
		return true;
	}

	function calculatePleasure( _target )
	{
		return this.Math.max(1, this.m.BasePleasure);
	}

	function calculateSelfPleasure( _target )
	{
		return 0;
	}

	function onHit( _user, _target )
	{
		// No horny application on allies, no self-pleasure
		return 0;
	}
});
