// Allied Grope — triggered automatically when a male brother is distracted by high allure
// Inherits from male_grope_skill; reuses full pipeline (AP, fatigue, animation, pleasure)
// Overrides: targets allies instead of enemies, dom score boosts target defense, no horny
this.allied_grope_skill <- this.inherit("scripts/skills/actives/male_grope_skill", {
	m = {},
	function create()
	{
		this.male_grope_skill.create();
		this.m.ID = "actives.allied_grope";
		this.m.Name = "Grope";
		this.m.Description = "Distracted by overwhelming allure, roughly gropes an ally.";
		this.m.ActionPointCost = ::Lewd.Const.AlliedGropeAP;
		this.m.FatigueCost = ::Lewd.Const.AlliedGropeFatigue;
		this.m.BasePleasure = ::Lewd.Const.AlliedGropeBasePleasure;
		this.m.MeleeSkillScale = ::Lewd.Const.AlliedGropeMeleeSkillScale;
		this.m.BaseHitChance = ::Lewd.Const.MaleGropeBaseHitChance;
		this.m.SelfPleasure = 0;
		this.m.HitText = ["can\'t resist groping", "fondles", "paws at"];
		this.m.MissText = ["grope", "fondle", "grab"];
	}

	function isHidden()
	{
		return true;
	}

	function isUsable()
	{
		// Skip base isUsable() which rejects hidden skills
		local actor = this.getContainer().getActor();
		return this.m.IsUsable && actor.getCurrentProperties().IsAbleToUseSkills;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		// Skip sex_skill_base — we want allied targets, not enemies
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
		local target = _targetTile.getEntity();
		if (target == null) return false;
		if (!this.m.Container.getActor().isAlliedWith(target)) return false;
		if (target.getGender() != 1) return false;
		if (target.getPleasureMax() <= 0) return false;
		return true;
	}

	function onHit( _user, _target )
	{
		// No horny application on allies, no self-pleasure
		// Pleasure from calculatePleasure is dealt via the base onScheduledSexHit
		return 0;
	}
});
