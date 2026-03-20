// Shared charm/seduce logic for Tease and Entrancing Beauty
// Centralizes the allure-vs-resolve formula, racial resistance, crit check, and horny application

::Lewd.Charm <- {};

// Get racial charm resistance for a target entity
// Returns flat bonus to effective resolve (higher = harder to charm)
::Lewd.Charm.getRacialResistance <- function( _target )
{
	if (::Lewd.Mastery.isOrc(_target)) return ::Lewd.Const.CharmResistOrc;
	if (::Lewd.Mastery.isGoblin(_target)) return ::Lewd.Const.CharmResistGoblin;
	if (::Lewd.Mastery.isUnhold(_target)) return ::Lewd.Const.CharmResistUnhold;
	if (::Lewd.Mastery.isWolf(_target)) return ::Lewd.Const.CharmResistWolf;
	if (::Lewd.Mastery.isSpider(_target)) return ::Lewd.Const.CharmResistSpider;
	if (::Lewd.Mastery.isAlp(_target)) return ::Lewd.Const.CharmResistAlp;
	if (::Lewd.Mastery.isLindwurm(_target)) return ::Lewd.Const.CharmResistLindwurm;
	return 0;
};

// Calculate charm chance
// _allure: user's effective allure (already includes any flat bonuses like TeaseAllureBonus)
// _resolve: target's base resolve (before racial resistance)
// _distance: tile distance between user and target
// _params: table with { BaseChance, Scale, DistancePenalty }
// Returns raw chance (NOT clamped -- caller decides clamping)
::Lewd.Charm.calcChance <- function( _allure, _resolve, _racialResist, _distance, _params )
{
	local effectiveResolve = _resolve + _racialResist;
	return _params.BaseChance + (_allure - effectiveResolve) * _params.Scale - (_distance - 1) * _params.DistancePenalty;
};

// Apply horny (+ optional stun on crit) to a target
// Returns 0=miss, 1=hit (horny), 2=crit (horny+stun)
// Uses getroottable() since ::Lewd.Charm functions lack script-instance `this` context
::Lewd.Charm.applyCharm <- function( _target, _chance )
{
	local gt = getroottable();
	local roll = gt.Math.rand(1, 100);

	if (roll > _chance)
		return 0;

	// Apply or refresh Horny
	if (!_target.getSkills().hasSkill("effects.lewd_horny"))
	{
		local horny = gt.new("scripts/skills/effects/lewd_horny_effect");
		_target.getSkills().add(horny);
	}
	else
	{
		_target.getSkills().getSkillByID("effects.lewd_horny").onRefresh();
	}

	// Crit: if roll is far enough below chance, also stun
	if (roll < _chance - ::Lewd.Const.CritChanceThreshold)
	{
		local stunned = gt.new("scripts/skills/effects/stunned_effect");
		_target.getSkills().add(stunned);
		return 2;
	}

	return 1;
};

// Apply or transfer an orc claim from _orc to _target
// Handles: new claims, transfers from a previous claimer, flag/effect bookkeeping
// Does NOT handle cum sprites or projectiles -- caller is responsible for visuals
::Lewd.Charm.applyOrcClaim <- function( _orc, _target )
{
	local gt = getroottable();

	// If target is already claimed by this orc, no-op
	if (_target.getSkills().hasSkill("effects.orc_claimed"))
	{
		local existing = _target.getSkills().getSkillByID("effects.orc_claimed");
		if (existing.getClaimerID() == _orc.getID())
		{
			::logInfo("[orc_claim] " + _target.getName() + " already claimed by " + _orc.getName() + ", no-op");
			return false;
		}

		// Transfer: remove old claim from previous orc
		local oldClaimerID = existing.getClaimerID();
		local oldClaimer = gt.Tactical.getEntityByID(oldClaimerID);
		if (oldClaimer != null && oldClaimer.isAlive())
		{
			oldClaimer.getSkills().removeByID("effects.orc_claiming");
			oldClaimer.getFlags().set("lewdOrcClaimTarget", -1);
			::logInfo("[orc_claim] transferred claim on " + _target.getName() + " from " + oldClaimer.getName() + " to " + _orc.getName());
		}

		// Update existing effect to new claimer
		existing.setClaimerID(_orc.getID());
	}
	else
	{
		// New claim
		local effect = gt.new("scripts/skills/effects/orc_claimed_effect");
		_target.getSkills().add(effect);
		effect.setClaimerID(_orc.getID());
	}

	// Set claim flag on the orc
	_orc.getFlags().set("lewdOrcClaimTarget", _target.getID());

	// Add or update claiming effect on the orc
	if (_orc.getSkills().hasSkill("effects.orc_claiming"))
	{
		_orc.getSkills().getSkillByID("effects.orc_claiming").setTarget(_target.getID(), _target.getName());
	}
	else
	{
		local claimingEffect = gt.new("scripts/skills/effects/orc_claiming_effect");
		_orc.getSkills().add(claimingEffect);
		claimingEffect.setTarget(_target.getID(), _target.getName());
	}

	::logInfo("[orc_claim] " + _orc.getName() + " claims " + _target.getName());
	return true;
};
