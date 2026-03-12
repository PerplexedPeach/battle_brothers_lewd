// Allied Penetrate Anal — triggered automatically when a horny male brother escalates
// harassment on a mounted female ally. Inherits from male_penetrate_anal_skill.
// Overrides: targets allies, establishes mount on ally, no self-pleasure, no horny.
this.allied_penetrate_anal_skill <- this.inherit("scripts/skills/actives/male_penetrate_anal_skill", {
	m = {},
	function create()
	{
		this.male_penetrate_anal_skill.create();
		this.m.ID = "actives.allied_penetrate_anal";
		this.m.Name = "Penetrate (Anal)";
		this.m.Description = "Overwhelmed by lust, takes a mounted ally from behind.";
		this.m.ActionPointCost = ::Lewd.Const.AlliedPenetrateAnalAP;
		this.m.FatigueCost = ::Lewd.Const.AlliedPenetrateAnalFatigue;
		this.m.BasePleasure = ::Lewd.Const.AlliedPenetrateAnalBasePleasure;
		this.m.MeleeSkillScale = ::Lewd.Const.AlliedPenetrateAnalMeleeSkillScale;
		this.m.SelfPleasure = 0;
		this.m.HitText = ["can't resist and sodomizes", "takes from behind", "forces himself on"];
		this.m.MissText = ["sodomize", "take from behind", "force himself on"];
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
