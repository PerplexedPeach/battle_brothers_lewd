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

// Returns 0 (none), 1 (Dainty), 2 (Delicate), 3 (Ethereal)
::Lewd.Mastery.getLewdTier <- function( _actor )
{
	local dominated = ["trait.ethereal", "trait.delicate", "trait.dainty"];
	foreach (id in dominated)
	{
		local skill = _actor.getSkills().getSkillByID(id);
		if (skill != null)
			return skill.m.LewdTier;
	}
	return 0;
};

::Lewd.Mastery.hasDaintyOrDelicate <- function( _actor )
{
	return ::Lewd.Mastery.getLewdTier(_actor) >= 1;
};

::Lewd.Mastery.hasDelicate <- function( _actor )
{
	return ::Lewd.Mastery.getLewdTier(_actor) >= 2;
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

// Absorb a random stat from _target into _source (where target's base > source's base).
// If _steal is true, the target also loses -1 to that stat.
// Returns { prop, label } of the absorbed stat, or null if none eligible.
::Lewd.Mastery.absorbStat <- function( _source, _target, _steal = false )
{
	local src = _source.getBaseProperties();
	local tgt = _target.getBaseProperties();
	local stats = [
		{ prop = "Hitpoints",     label = "Hitpoints" },
		{ prop = "Bravery",       label = "Resolve" },
		{ prop = "Stamina",       label = "Stamina" },
		{ prop = "MeleeSkill",    label = "Melee Skill" },
		{ prop = "RangedSkill",   label = "Ranged Skill" },
		{ prop = "MeleeDefense",  label = "Melee Defense" },
		{ prop = "RangedDefense", label = "Ranged Defense" },
		{ prop = "Initiative",    label = "Initiative" }
	];
	local eligible = [];
	foreach (s in stats)
	{
		if (src[s.prop] < tgt[s.prop])
			eligible.push(s);
	}
	if (eligible.len() == 0)
		return null;

	local s = this.Math.rand(0, eligible.len() - 1);
	local picked = eligible[s];
	src[picked.prop] += 1;
	if (_steal)
		tgt[picked.prop] -= 1;
	return picked;
};

// Visual/audio feedback when stat absorption occurs: climax overlay, long moan, double pink flash
::Lewd.Mastery.playAbsorbEffect <- function( _actor, _Tactical, _Const, _Sound, _Time )
{
	if (!_actor.isPlacedOnMap()) return;

	_Tactical.spawnSpriteEffect("climax", this.createColor("#ffffff"), _actor.getTile(),
		_Const.Tactical.Settings.SkillOverlayOffsetX, _Const.Tactical.Settings.SkillOverlayOffsetY,
		_Const.Tactical.Settings.SkillOverlayScale, _Const.Tactical.Settings.SkillOverlayScale,
		_Const.Tactical.Settings.SkillOverlayStayDuration * 2, 0, _Const.Tactical.Settings.SkillOverlayFadeDuration);

	local moans = ::Lewd.Const.SoundLongMoans;
	_Sound.play(moans[this.Math.rand(0, moans.len() - 1)], _Const.Sound.Volume.Skill, _actor.getPos());

	local layers = _Const.ShakeCharacterLayers[2];
	local tile = _actor.getTile();
	_Tactical.getShaker().shake(_actor, tile, 2,
		::Lewd.Const.SexFlashColor, ::Lewd.Const.SexFlashHighlight,
		::Lewd.Const.SexFlashFactor, ::Lewd.Const.SexFlashSaturation,
		layers, 1.0);
	_Time.scheduleEvent(this.TimeUnit.Virtual, 400, function(_d) {
		if (!_d.Entity.isAlive() || !_d.Entity.isPlacedOnMap()) return;
		_d.Tactical.getShaker().shake(_d.Entity, _d.Tile, 2,
			::Lewd.Const.SexFlashColor, ::Lewd.Const.SexFlashHighlight,
			::Lewd.Const.SexFlashFactor, ::Lewd.Const.SexFlashSaturation,
			_d.Layers, 1.0);
	}, { Entity = _actor, Tile = tile, Tactical = _Tactical, Layers = layers });
};

// Drain a target: upgrade their drained tier and steal a stat.
// _source = the succubus doing the draining, _target = the victim.
// _ctx = table with { Tactical, Const, Sound, Time } from the calling scope.
// Returns true if the target was drained (tier upgraded or stat stolen).
::Lewd.Mastery.drainTarget <- function( _source, _target, _ctx )
{
	// Upgrade drained tier
	local drainedTiers = [
		{ id = "trait.drained_third", next = null },
		{ id = "trait.drained_second", next = "scripts/skills/traits/drained_third" },
		{ id = "trait.drained_first", next = "scripts/skills/traits/drained_second" }
	];
	local upgraded = false;
	local skills = _target.getSkills();
	foreach (tier in drainedTiers)
	{
		if (skills.hasSkill(tier.id))
		{
			if (tier.next != null)
			{
				skills.removeByID(tier.id);
				skills.add(this.new(tier.next));
				upgraded = true;
			}
			break;
		}
	}
	if (!upgraded && !skills.hasSkill("trait.drained_third"))
	{
		skills.add(this.new("scripts/skills/traits/drained_first"));
		upgraded = true;
	}
	if (upgraded)
	{
		local drainedSkill = skills.getSkillByID("trait.drained_first");
		if (drainedSkill == null) drainedSkill = skills.getSkillByID("trait.drained_second");
		if (drainedSkill == null) drainedSkill = skills.getSkillByID("trait.drained_third");
		local tierName = drainedSkill != null ? drainedSkill.getName() : "Drained";
		_ctx.Tactical.EventLog.log(_ctx.Const.UI.getColorizedEntityName(_target) + " becomes " + tierName + " from " + _ctx.Const.UI.getColorizedEntityName(_source) + "'s draining touch!");
	}

	// Steal a stat
	local stolen = ::Lewd.Mastery.absorbStat(_source, _target, true);
	if (stolen != null)
		_ctx.Tactical.EventLog.log(_ctx.Const.UI.getColorizedEntityName(_source) + " drains +1 " + stolen.label + " from " + _ctx.Const.UI.getColorizedEntityName(_target));
	else if (upgraded)
		_ctx.Tactical.EventLog.log(_ctx.Const.UI.getColorizedEntityName(_source) + " drains " + _ctx.Const.UI.getColorizedEntityName(_target) + "'s essence, but has nothing left to take");

	// Visual/audio on the succubus whenever any draining occurred
	if (upgraded || stolen != null)
		::Lewd.Mastery.playAbsorbEffect(_source, _ctx.Tactical, _ctx.Const, _ctx.Sound, _ctx.Time);

	return upgraded || stolen != null;
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
		local lewdTier = ::Lewd.Mastery.getLewdTier(_actor);
		local threshold = 0;

		if (lewdTier >= 3)      threshold = ::Lewd.Const.OrgasmThresholdEthereal;
		else if (lewdTier >= 2) threshold = ::Lewd.Const.OrgasmThresholdDelicate;
		else if (lewdTier >= 1) threshold = ::Lewd.Const.OrgasmThresholdDainty;

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
