// Base class for male/aggressor sex abilities (grope, force oral, penetrate, mating press)
// Simpler than lewd_sex_skill — no tiers or mastery system
// Children set member variables in create()
// Usable by enemies when horny, and eventually by male player characters via perks
this.male_sex_skill <- this.inherit("scripts/skills/actives/sex_skill_base", {
	m = {
		BasePleasure = 0,
		MeleeSkillScale = 0.0,
		BaseHitChance = 0,
		SelfPleasure = 0,
		HitText = [],
		MissText = []
	},
	function create()
	{
		this.sex_skill_base.create();
	}

	function isHidden()
	{
		local actor = this.getContainer().getActor();
		if (actor.getSkills().hasSkill("effects.lewd_horny")) return false;
		// Future: check for male perk unlock
		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.sex_skill_base.onVerifyTarget(_originTile, _targetTile)) return false;
		if (_targetTile.getEntity().getGender() != 1) return false;
		return true;
	}

	function getHitChanceAgainst( _target )
	{
		if (this.isAutoHit(_target)) return 95;

		local user = this.getContainer().getActor();
		local melSkill = user.getCurrentProperties().getMeleeSkill();
		local melDef = _target.getCurrentProperties().getMeleeDefense();
		local chance = this.m.BaseHitChance + (melSkill - melDef);
		return this.Math.max(20, this.Math.min(95, chance));
	}

	function calculatePleasure( _target )
	{
		local user = this.getContainer().getActor();
		local pleasure = this.m.BasePleasure;
		pleasure += this.Math.floor(user.getCurrentProperties().getMeleeSkill() * this.m.MeleeSkillScale);

		// mount bonus
		if (_target.getSkills().hasSkill("effects.lewd_mounted"))
			pleasure += this.calculateMountBonus(_target);

		return this.Math.max(1, pleasure);
	}

	// Virtual — children can override for mount-specific bonus pleasure
	function calculateMountBonus( _target )
	{
		return 0;
	}

	// Post-hit hook — base applies self-pleasure + horny
	function onHit( _user, _target )
	{
		if (this.m.SelfPleasure > 0 && _user.getPleasureMax() > 0)
			_user.addPleasure(this.m.SelfPleasure);

		this.tryApplyHorny(_target);
	}

	function getTooltip()
	{
		local result = this.sex_skill_base.getTooltip();
		result.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Deals pleasure to the target (scales with Melee Skill)"
		});
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Only usable on female targets"
		});
		return result;
	}
});
