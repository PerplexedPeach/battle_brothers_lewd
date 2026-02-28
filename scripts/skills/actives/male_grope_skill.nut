// Grope — basic male sex ability, always available when horny
// Low AP cost, no mount required, low pleasure
// Scales with Melee Skill
this.male_grope_skill <- this.inherit("scripts/skills/actives/male_sex_skill", {
	m = {},
	function create()
	{
		this.male_sex_skill.create();
		this.m.ID = "actives.male_grope";
		this.m.Name = "Grope";
		this.m.Description = "Roughly grope the target, dealing a small amount of pleasure.";
		this.m.Icon = "skills/lewd_hands_t1.png";
		this.m.IconDisabled = "skills/lewd_hands_t1_bw.png";
		this.m.Overlay = "lewd_hands_t1";
		this.m.ActionPointCost = ::Lewd.Const.MaleGropeAP;
		this.m.FatigueCost = ::Lewd.Const.MaleGropeFatigue;
		this.m.BasePleasure = ::Lewd.Const.MaleGropeBasePleasure;
		this.m.MeleeSkillScale = ::Lewd.Const.MaleGropeMeleeSkillScale;
		this.m.BaseHitChance = ::Lewd.Const.MaleGropeBaseHitChance;
		this.m.SelfPleasure = 0;
		this.m.HitText = ["roughly gropes", "fondles", "paws at"];
		this.m.MissText = ["grope", "fondle", "grab"];
	}
});
