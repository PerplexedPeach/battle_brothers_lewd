// Base class for male/aggressor sex abilities (grope, force oral, penetrate, mating press)
// Simpler than female_sex_skill — no tiers or mastery system
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

	function getSelfPleasure()
	{
		return this.m.SelfPleasure;
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

	function getHitchance( _targetEntity )
	{
		if (!_targetEntity.isAttackable()) return 0;
		return this.getHitChanceAgainst(_targetEntity);
	}

	function getHitFactors( _targetTile )
	{
		local ret = [];
		local target = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
		if (target == null) return ret;

		local user = this.getContainer().getActor();
		local melSkill = user.getCurrentProperties().getMeleeSkill();
		local melDef = target.getCurrentProperties().getMeleeDefense();
		local diff = melSkill - melDef;

		ret.push({
			icon = "ui/icons/melee_skill.png",
			text = "Melee Skill: [color=" + this.Const.UI.Color.PositiveValue + "]" + melSkill + "[/color]"
		});
		ret.push({
			icon = "ui/icons/melee_defense.png",
			text = "Target Melee Defense: [color=" + this.Const.UI.Color.NegativeValue + "]" + melDef + "[/color]"
		});

		if (diff >= 0)
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + diff + "%[/color] from Melee Skill advantage"
			});
		else
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + diff + "%[/color] from Melee Defense advantage"
			});

		if (target.getSkills().hasSkill("effects.lewd_mounted"))
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.MaleSexMountedHitBonus + "%[/color] target is mounted"
			});

		if (this.isAutoHit(target))
			ret.push({
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Auto-hit[/color] (target is horny/open)"
			});

		return ret;
	}

	function getHitChanceAgainst( _target )
	{
		if (this.isAutoHit(_target)) return 95;

		local user = this.getContainer().getActor();
		local melSkill = user.getCurrentProperties().getMeleeSkill();
		local melDef = _target.getCurrentProperties().getMeleeDefense();
		local chance = this.m.BaseHitChance + (melSkill - melDef);
		if (_target.getSkills().hasSkill("effects.lewd_mounted"))
			chance += ::Lewd.Const.MaleSexMountedHitBonus;
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

		// Surrender to Pleasure: target is more vulnerable to pleasure (half scaling)
		local surrenderEffect = _target.getSkills().getSkillByID("effects.surrender_to_pleasure");
		if (surrenderEffect != null)
			pleasure = this.Math.floor(pleasure * surrenderEffect.getSelfVulnMult());

		return this.Math.max(1, pleasure);
	}

	// Virtual — children can override for mount-specific bonus pleasure
	function calculateMountBonus( _target )
	{
		return 0;
	}

	// Post-hit hook — base applies self-pleasure + horny + Pliant Body + Willing Victim + Surrender
	function onHit( _user, _target )
	{
		local selfP = this.m.SelfPleasure;

		// Pliant Body: target's accommodating body gives attacker more self-pleasure + target recovers fatigue
		if (_target.getSkills().hasSkill("perk.lewd_pliant_body"))
		{
			selfP = this.Math.floor(selfP * ::Lewd.Const.PliantBodyReflectionMult);
			_target.m.Fatigue = this.Math.max(0, _target.m.Fatigue - ::Lewd.Const.PliantBodyFatigueRecovery);
		}

		// Surrender to Pleasure: target has given in, mounters feel it more
		local surrenderEffect = _target.getSkills().getSkillByID("effects.surrender_to_pleasure");
		if (surrenderEffect != null)
			selfP = this.Math.floor(selfP * surrenderEffect.getMounterMult());

		if (selfP > 0 && _user.getPleasureMax() > 0)
			_user.addPleasure(selfP);

		// Willing Victim: target deals counter-pleasure back to attacker
		if (_target.getSkills().hasSkill("perk.lewd_willing_victim") && _user.getPleasureMax() > 0)
			_user.addPleasure(::Lewd.Const.WillingVictimCounterPleasure, _target);

		this.tryApplyHorny(_target);
	}

	function getTooltip()
	{
		local pos = this.Const.UI.Color.PositiveValue;
		local neg = this.Const.UI.Color.NegativeValue;
		local result = this.sex_skill_base.getTooltip();

		// Pleasure info
		result.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Deals [color=" + pos + "]pleasure[/color] to the target (scales with Melee Skill)"
		});

		// Hit chance
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Hit chance: [color=" + pos + "]" + this.m.BaseHitChance + "%[/color] base, modified by Melee Skill vs target Melee Defense"
		});

		// Mounted hit bonus
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "[color=" + pos + "]+" + ::Lewd.Const.MaleSexMountedHitBonus + "%[/color] hit chance against mounted targets"
		});

		// Self-pleasure
		if (this.m.SelfPleasure > 0)
		{
			result.push({
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts [color=" + neg + "]" + this.m.SelfPleasure + "[/color] pleasure on yourself"
			});
		}

		// Horny chance
		result.push({
			id = 9,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + pos + "]" + ::Lewd.Const.HornyApplyChance + "%[/color] chance to inflict Horny on hit"
		});

		// Auto-hit + target restriction
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + pos + "]Auto-hit[/color] against Horny or Open Invitation targets"
		});
		result.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Only usable on female targets with Pleasure capacity"
		});

		return result;
	}
});
