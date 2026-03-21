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

// Roll a domination check for allure events. Returns true on success.
// Higher dom score = better odds, deep sub = very unlikely to dominate.
::Lewd.Mastery.rollDomCheck <- function( _actor )
{
	local domSub = ::Lewd.Mastery.getDomSub(_actor);
	local chance = ::Lewd.Const.AllureEventDomBaseChance + domSub * ::Lewd.Const.AllureEventDomScoreScale;
	chance = this.Math.max(::Lewd.Const.AllureEventDomMinChance, this.Math.min(::Lewd.Const.AllureEventDomMaxChance, chance));
	return this.Math.rand(1, 100) <= chance;
};

// Returns a mood value based on whether an outcome aligns with the actor's dom/sub nature.
// _isDomAligned = true for dom-aligned outcomes (dom success), false for sub-aligned (sub choice, dom fail).
// Positive = outcome matches nature (feels right), negative = against nature (feels wrong).
// Range: -2.0 to +2.0, rounded to nearest 0.5. Returns 0.0 for neutral actors.
::Lewd.Mastery.getAlignedMood <- function( _actor, _isDomAligned )
{
	local domSub = ::Lewd.Mastery.getDomSub(_actor).tofloat();
	local mood = domSub / 15.0;
	if (!_isDomAligned) mood = -mood;
	mood = this.Math.max(-2.0, this.Math.min(2.0, mood));
	mood = this.Math.floor(mood * 2.0 + 0.5) / 2.0;
	return mood;
};

// Find all eligible male non-PC brothers in the roster.
::Lewd.Mastery.findMaleCandidates <- function()
{
	local brothers = this.World.getPlayerRoster().getAll();
	local candidates = [];
	foreach (bro in brothers)
	{
		if (bro.getGender() == 0 && !bro.getFlags().get("IsPlayerCharacter"))
			candidates.push(bro);
	}
	return candidates;
};

// Pick a brother from _candidates using weighted random selection.
// _config table supports:
//   domScale       - weight per dom point (e.g. 0.1 = +1.0 weight at 10 dom)
//   subScale       - weight per sub point (e.g. 0.1 = +1.0 weight at 10 sub)
//   debaucheryBonus - flat weight bonus for having the Debauchery perk tree
// Base weight is always 1.0, so every candidate has at least some chance.
::Lewd.Mastery.pickWeightedBrother <- function( _candidates, _config )
{
	if (_candidates.len() == 0) return null;
	if (_candidates.len() == 1) return _candidates[0];

	local P = 100; // precision multiplier (1.0 = 100)
	local weights = [];
	local totalWeight = 0;

	foreach (bro in _candidates)
	{
		local w = P;

		if ("domScale" in _config)
			w += this.Math.floor(::Lewd.Mastery.getDomScore(bro) * _config.domScale * P);

		if ("subScale" in _config)
			w += this.Math.floor(::Lewd.Mastery.getSubScore(bro) * _config.subScale * P);

		if ("debaucheryBonus" in _config)
		{
			local bg = bro.getBackground();
			if (bg != null && bg.hasPerkGroup(::Const.Perks.DebaucheryTree))
				w += this.Math.floor(_config.debaucheryBonus * P);
		}

		if (w < 1) w = 1;
		weights.push(w);
		totalWeight += w;
	}

	local roll = this.Math.rand(1, totalWeight);
	local cumulative = 0;

	foreach (i, w in weights)
	{
		cumulative += w;
		if (roll <= cumulative)
			return _candidates[i];
	}

	return _candidates[_candidates.len() - 1];
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

	_Tactical.spawnSpriteEffect("ethereal_trait", this.createColor("#ffffff"), _actor.getTile(),
		_Const.Tactical.Settings.SkillOverlayOffsetX, _Const.Tactical.Settings.SkillOverlayOffsetY,
		_Const.Tactical.Settings.SkillOverlayScale, _Const.Tactical.Settings.SkillOverlayScale,
		_Const.Tactical.Settings.SkillOverlayStayDuration * 2, 0, _Const.Tactical.Settings.SkillOverlayFadeDuration);

	local moans = ::Lewd.Const.SoundLongMoans;
	_Sound.play(moans[this.Math.rand(0, moans.len() - 1)], _Const.Sound.Volume.Skill, _actor.getPos());

	local chimes = ::Lewd.Const.SoundCharmChimes;
	_Sound.play(chimes[this.Math.rand(0, chimes.len() - 1)], _Const.Sound.Volume.Skill * 0.8, _actor.getPos());

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

// Upgrade a target's drained tier: none -> Sapped -> Drained -> Enthralled.
// Returns the new drained skill object, or null if already at max tier.
::Lewd.Mastery.upgradeDrainedTier <- function( _target )
{
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
	if (!upgraded) return null;

	local drainedSkill = skills.getSkillByID("trait.drained_first");
	if (drainedSkill == null) drainedSkill = skills.getSkillByID("trait.drained_second");
	if (drainedSkill == null) drainedSkill = skills.getSkillByID("trait.drained_third");
	return drainedSkill;
};

// Drain a target in tactical combat: upgrade tier, steal stat, log, play effects.
// _source = the succubus doing the draining, _target = the victim.
// _ctx = table with { Tactical, Const, Sound, Time } from the calling scope.
// Returns true if the target was drained (tier upgraded or stat stolen).
::Lewd.Mastery.drainTarget <- function( _source, _target, _ctx )
{
	local drainedSkill = ::Lewd.Mastery.upgradeDrainedTier(_target);
	local upgraded = drainedSkill != null;

	if (upgraded)
	{
		local tierName = drainedSkill.getName();
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

// Species type-checkers — match entity type against base game + Legends lists
::Lewd.Mastery.isSpecies <- function( _actor, _typeList )
{
	local t = _actor.getType();
	foreach (stype in _typeList)
		if (t == stype) return true;
	return false;
};

::Lewd.Mastery.isGoblin <- function( _actor ) { return ::Lewd.Mastery.isSpecies(_actor, ::Lewd.Const.GoblinEntityTypes); };
::Lewd.Mastery.isOrc <- function( _actor ) { return ::Lewd.Mastery.isSpecies(_actor, ::Lewd.Const.OrcEntityTypes); };
::Lewd.Mastery.isUnhold <- function( _actor ) { return ::Lewd.Mastery.isSpecies(_actor, ::Lewd.Const.UnholdEntityTypes); };
::Lewd.Mastery.isWolf <- function( _actor ) { return ::Lewd.Mastery.isSpecies(_actor, ::Lewd.Const.WolfEntityTypes); };
::Lewd.Mastery.isSpider <- function( _actor ) { return ::Lewd.Mastery.isSpecies(_actor, ::Lewd.Const.SpiderEntityTypes); };
::Lewd.Mastery.isAlp <- function( _actor ) { return ::Lewd.Mastery.isSpecies(_actor, ::Lewd.Const.AlpEntityTypes); };
::Lewd.Mastery.isLindwurm <- function( _actor ) { return ::Lewd.Mastery.isSpecies(_actor, ::Lewd.Const.LindwurmEntityTypes); };

// Orgasm threshold: how many climaxes before defeat
// Common base for all entities: Base + Bravery/40 + MaxHP/200
// Player characters add lewd trait, masochism, and perk bonuses on top
// Returns 0 if no pleasure capacity (immune)
::Lewd.Mastery.getOrgasmThreshold <- function( _actor )
{
	if (_actor.getPleasureMax() <= 0) return 0; // no pleasure capacity = immune

	// Shared base: all humanoids scale with Resolve and HP
	local resolve = _actor.getCurrentProperties().getBravery();
	local maxHP = _actor.getHitpointsMax();
	local threshold = ::Lewd.Const.OrgasmThresholdBase;
	threshold += this.Math.floor(resolve / ::Lewd.Const.OrgasmThresholdResolveDivisor);
	threshold += this.Math.floor(maxHP / ::Lewd.Const.OrgasmThresholdHPDivisor);

	// Enemy-specific bonuses
	if (!_actor.isPlayerControlled())
	{
		if ("IsMiniboss" in _actor.m && _actor.m.IsMiniboss)
			threshold += ::Lewd.Const.OrgasmThresholdMinibossBonus;

		if (this.Const.EntityType.getDefaultFaction(_actor.getType()) == this.Const.FactionType.Orcs)
			threshold += ::Lewd.Const.OrgasmThresholdOrcBonus;
	}

	// Player-specific bonuses: lewd traits, masochism, perks
	if (_actor.isPlayerControlled())
	{
		local skills = _actor.getSkills();
		local lewdTier = ::Lewd.Mastery.getLewdTier(_actor);

		if (lewdTier >= 3)      threshold += ::Lewd.Const.OrgasmThresholdEthereal;
		else if (lewdTier >= 2) threshold += ::Lewd.Const.OrgasmThresholdDelicate;
		else if (lewdTier >= 1) threshold += ::Lewd.Const.OrgasmThresholdDainty;

		// Masochism tier bonus (highest only)
		if (skills.hasSkill("trait.masochism_third"))
			threshold += ::Lewd.Const.OrgasmThresholdMasochismThird;
		else if (skills.hasSkill("trait.masochism_second"))
			threshold += ::Lewd.Const.OrgasmThresholdMasochismSecond;
		else if (skills.hasSkill("trait.masochism_first"))
			threshold += ::Lewd.Const.OrgasmThresholdMasochismFirst;

		// Perk bonuses
		if (skills.hasSkill("perk.lewd_alluring_presence"))
			threshold += ::Lewd.Const.OrgasmThresholdAlluringPresence;
		if (skills.hasSkill("perk.lewd_practiced_control"))
			threshold += ::Lewd.Const.OrgasmThresholdPracticedControl;
		if (skills.hasSkill("perk.lewd_transcendence"))
			threshold += ::Lewd.Const.OrgasmThresholdTranscendence;
		if (skills.hasSkill("perk.lewd_willing_victim"))
			threshold += ::Lewd.Const.OrgasmThresholdWillingVictim;
		if (skills.hasSkill("perk.lewd_insatiable"))
			threshold += ::Lewd.Const.OrgasmThresholdInsatiable;
		if (skills.hasSkill("perk.lewd_brutal_force"))
			threshold += ::Lewd.Const.BrutalForceOrgasmThreshold;

		::logInfo("[orgasmThreshold] " + _actor.getName() + " resolve=" + resolve + " maxHP=" + maxHP + " lewdTier=" + lewdTier + " isPC=" + _actor.isPlayerControlled() + " threshold=" + threshold);
	}

	return threshold;
};

