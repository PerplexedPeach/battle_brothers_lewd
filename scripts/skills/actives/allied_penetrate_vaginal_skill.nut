// Allied Penetrate Vaginal — triggered automatically when a horny male brother escalates
// harassment on a mounted female ally. Inherits from male_penetrate_vaginal_skill.
// Overrides: targets allies, establishes mount on ally, no self-pleasure, no horny.
this.allied_penetrate_vaginal_skill <- this.inherit("scripts/skills/actives/male_penetrate_vaginal_skill", {
	m = {},
	function create()
	{
		this.male_penetrate_vaginal_skill.create();
		this.m.ID = "actives.allied_penetrate_vaginal";
		this.m.Name = "Penetrate (Vaginal)";
		this.m.Description = "Overwhelmed by lust, penetrates a mounted ally.";
		this.m.ActionPointCost = ::Lewd.Const.AlliedPenetrateVaginalAP;
		this.m.FatigueCost = ::Lewd.Const.AlliedPenetrateVaginalFatigue;
		this.m.BasePleasure = ::Lewd.Const.AlliedPenetrateVaginalBasePleasure;
		this.m.MeleeSkillScale = ::Lewd.Const.AlliedPenetrateVaginalMeleeSkillScale;
		this.m.SelfPleasure = 0;
		this.m.HitText = ["can't resist and penetrates", "takes advantage of", "thrusts into"];
		this.m.MissText = ["penetrate", "take advantage of", "thrust into"];
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
		// Requires target to be mounted (by anyone)
		if (!target.getSkills().hasSkill("effects.lewd_mounted")) return false;
		return true;
	}

	function onHit( _user, _target )
	{
		// No horny application on allies, no self-pleasure
		return 0;
	}
});
