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
		if (effect.getMounterID() == _target.getID()) return true;
	}
	return false;
};

// Whether an actor is a humanoid capable of using male sex skills
// (has hands, wears armor/helmets — filters out beasts, ghosts, etc.)
::Lewd.Mastery.isHumanoid <- function( _actor )
{
	return _actor.hasSprite("helmet");
};
