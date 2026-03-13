// Grope — basic male sex ability, always available when horny
// Low AP cost, no mount required, low pleasure
// Scales with Melee Skill
this.male_grope_skill <- this.inherit("scripts/skills/actives/male_sex_skill", {
	m = {},
	function create()
	{
		this.male_sex_skill.create();
		this.m.SexDelay = 300;
		this.m.ShakeCount = 1;
		this.m.ShakeIntensity = 3;
		this.m.ShakeTargetDelay = 150;
		this.m.ShakeTargetIntensity = 2;
		this.m.Delay = 300;
		this.m.SoundOnUse = ::Lewd.Const.SoundSpanking;
		this.m.SoundOnHit = ::Lewd.Const.SoundMoans;
		this.m.SoundOnHitMale = ::Lewd.Const.SoundMaleMoans;
		this.m.ID = "actives.male_grope";
		this.m.SexType = "hands";
		this.m.Name = "Grope";
		this.m.Description = "Roughly grope the target, dealing a small amount of pleasure.";
		this.m.Icon = "skills/lewd_grope.png";
		this.m.IconDisabled = "skills/lewd_grope_bw.png";
		this.m.Overlay = "lewd_grope";
		this.m.ActionPointCost = ::Lewd.Const.MaleGropeAP;
		this.m.FatigueCost = ::Lewd.Const.MaleGropeFatigue;
		this.m.BasePleasure = ::Lewd.Const.MaleGropeBasePleasure;
		this.m.MeleeSkillScale = ::Lewd.Const.MaleGropeMeleeSkillScale;
		this.m.BaseHitChance = ::Lewd.Const.MaleGropeBaseHitChance;
		this.m.SelfPleasure = 0;
		this.m.HitText = ["roughly gropes", "fondles", "paws at"];
		this.m.MissText = ["grope", "fondle", "grab"];
	}

	function isHidden()
	{
		local actor = this.getContainer().getActor();
		if (actor.getSkills().hasSkill("effects.lewd_horny")) return false;
		if (actor.getSkills().hasSkill("perk.lewd_wandering_hands")) return false;
		return true;
	}

	function getGropeMastery()
	{
		return this.getContainer().getActor().getSkills().getSkillByID("effects.male_mastery_grope");
	}

	function getHitChanceAgainst( _target )
	{
		local chance = this.male_sex_skill.getHitChanceAgainst(_target);
		local mastery = this.getGropeMastery();
		if (mastery != null)
			chance += mastery.getHitBonus();
		return this.Math.max(20, this.Math.min(95, chance));
	}

	function calculatePleasure( _target )
	{
		local pleasure = this.male_sex_skill.calculatePleasure(_target);
		local mastery = this.getGropeMastery();
		if (mastery != null)
			pleasure += mastery.getPleasureBonus();
		return this.Math.max(1, pleasure);
	}

	function getHitFactors( _targetTile )
	{
		local ret = this.male_sex_skill.getHitFactors(_targetTile);
		local mastery = this.getGropeMastery();
		if (mastery != null)
		{
			local bonus = mastery.getHitBonus();
			if (bonus > 0)
				ret.push({
					icon = "ui/tooltips/positive.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "%[/color] from Grope Mastery"
				});
		}
		return ret;
	}
});
