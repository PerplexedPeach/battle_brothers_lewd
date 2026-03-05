::Lewd.Mastery <- {};

::Lewd.Mastery.getMasteryPoints <- function( _actor, _masteryID )
{
	local skill = _actor.getSkills().getSkillByID(_masteryID);
	if (skill == null) return -1;
	return skill.getPoints();
};

::Lewd.Mastery.getMasteryTier <- function( _actor, _masteryID )
{
	local skill = _actor.getSkills().getSkillByID(_masteryID);
	if (skill == null) return 0;
	if (skill.getPoints() < 0) return 0;
	return skill.getTier();
};

::Lewd.Mastery.getMasoTier <- function( _actor )
{
	local skills = _actor.getSkills();
	if (skills.hasSkill("trait.masochism_third")) return 3;
	if (skills.hasSkill("trait.masochism_second")) return 2;
	if (skills.hasSkill("trait.masochism_first")) return 1;
	return 0;
};

::Lewd.Mastery.hasDaintyOrDelicate <- function( _actor )
{
	local skills = _actor.getSkills();
	return skills.hasSkill("trait.dainty") || skills.hasSkill("trait.delicate");
};

::Lewd.Mastery.hasDelicate <- function( _actor )
{
	return _actor.getSkills().hasSkill("trait.delicate");
};

::Lewd.Mastery.calcFatigueVulnerability <- function( _target )
{
	local fatPct = _target.getFatigue() * 1.0 / this.Math.max(1, _target.getFatigueMax());
	return this.Math.floor(fatPct * ::Lewd.Const.SexFatigueVulnerabilityBonus);
};

// --- Dom/Sub Score ---

::Lewd.Mastery.getDomSub <- function( _actor )
{
	return _actor.getFlags().getAsInt("lewdDomSub");
};

// Returns 0-30, positive only (how dominant)
::Lewd.Mastery.getDomScore <- function( _actor )
{
	return this.Math.max(0, _actor.getFlags().getAsInt("lewdDomSub"));
};

// Returns 0-30, positive only (how submissive)
::Lewd.Mastery.getSubScore <- function( _actor )
{
	return this.Math.max(0, -_actor.getFlags().getAsInt("lewdDomSub"));
};

::Lewd.Mastery.addDomSub <- function( _actor, _amount )
{
	local cur = _actor.getFlags().getAsInt("lewdDomSub");
	local next = this.Math.max(-::Lewd.Const.DomSubCap, this.Math.min(::Lewd.Const.DomSubCap, cur + _amount));
	_actor.getFlags().set("lewdDomSub", next);
};

// Check if two actors are in a mount relationship (either direction)
// Returns true if _user is mounting _target OR _target is mounting _user
::Lewd.Mastery.isMountedWith <- function( _user, _target )
{
	// user is mounting target
	if (_user.getSkills().hasSkill("effects.lewd_mounting"))
	{
		local effect = _user.getSkills().getSkillByID("effects.lewd_mounting");
		if (effect.getTargetID() == _target.getID()) return true;
	}
	// user is mounted by target
	if (_user.getSkills().hasSkill("effects.lewd_mounted"))
	{
		local effect = _user.getSkills().getSkillByID("effects.lewd_mounted");
		if (effect.hasMounter(_target.getID())) return true;
	}
	return false;
};

// Whether an actor is a humanoid capable of using male sex skills
// (has hands, wears armor/helmets — filters out beasts, ghosts, etc.)
::Lewd.Mastery.isHumanoid <- function( _actor )
{
	return _actor.hasSprite("helmet");
};

// Orgasm threshold: how many climaxes before defeat
// Returns 0 if immune (no pleasure capacity), 999 if PleasureMax <= 0 on enemies
::Lewd.Mastery.getOrgasmThreshold <- function( _actor )
{
	if (_actor.isPlayerControlled())
	{
		// Players: sum trait base + masochism + perk bonuses
		// No lewd traits = immune (can't be orgasm-defeated without pleasure capacity)
		local skills = _actor.getSkills();
		local threshold = 0;

		if (skills.hasSkill("trait.delicate"))
			threshold = ::Lewd.Const.OrgasmThresholdDelicate;
		else if (skills.hasSkill("trait.dainty"))
			threshold = ::Lewd.Const.OrgasmThresholdDainty;

		if (threshold == 0) return 0; // no lewd trait = immune

		// Masochism tier bonus (highest only)
		if (skills.hasSkill("trait.masochism_third"))
			threshold += ::Lewd.Const.OrgasmThresholdMasochismThird;
		else if (skills.hasSkill("trait.masochism_second"))
			threshold += ::Lewd.Const.OrgasmThresholdMasochismSecond;
		else if (skills.hasSkill("trait.masochism_first"))
			threshold += ::Lewd.Const.OrgasmThresholdMasochismFirst;

		// Perk bonuses
		if (skills.hasSkill("perk.lewd_practiced_control"))
			threshold += ::Lewd.Const.OrgasmThresholdPracticedControl;
		if (skills.hasSkill("perk.lewd_transcendence"))
			threshold += ::Lewd.Const.OrgasmThresholdTranscendence;
		if (skills.hasSkill("perk.lewd_willing_victim"))
			threshold += ::Lewd.Const.OrgasmThresholdWillingVictim;
		if (skills.hasSkill("perk.lewd_insatiable"))
			threshold += ::Lewd.Const.OrgasmThresholdInsatiable;

		return threshold;
	}
	else
	{
		// Enemies: base + Resolve scaling + miniboss bonus
		if (_actor.getPleasureMax() <= 0) return 999; // immune (no pleasure capacity)

		local resolve = _actor.getCurrentProperties().getBravery();
		local threshold = ::Lewd.Const.OrgasmThresholdEnemyBase;
		threshold += this.Math.floor(resolve / ::Lewd.Const.OrgasmThresholdResolveDivisor);

		if ("IsMiniboss" in _actor.m && _actor.m.IsMiniboss)
			threshold += ::Lewd.Const.OrgasmThresholdMinibossBonus;

		return threshold;
	}
};
