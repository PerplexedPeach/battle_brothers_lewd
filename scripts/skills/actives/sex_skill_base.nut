// Base class for all sex abilities (both player/female and enemy/male)
// Provides shared: create() flags, onUse() flow, playSound, rollHit, tryApplyHorny,
// isAutoHit, onVerifyTarget, logMiss/logHit, getTooltip base entries
// Subclasses: lewd_sex_skill (tiers/mastery), male_sex_skill (flat values)
this.sex_skill_base <- this.inherit("scripts/skills/skill", {
	m = {
		SexType = "",
		HitText = [],
		MissText = []
	},
	function create()
	{
		this.m.SoundOnUse = [];
		this.m.SoundOnHit = [];
		this.m.SoundOnHitMale = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function isAutoHit( _target )
	{
		if (_target.getSkills().hasSkill("effects.open_invitation")) return true;
		if (_target.getSkills().hasSkill("effects.lewd_horny")) return true;
		return false;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
		local target = _targetTile.getEntity();
		if (target == null) return false;
		if (this.m.Container.getActor().isAlliedWith(target)) return false;
		if (target.getPleasureMax() <= 0) return false;
		return true;
	}

	function recordSexContinuation( _user, _target )
	{
		if (this.m.SexType == "") return;
		::logInfo("[sex]   recording continuation: " + _user.getName() + " <-> " + _target.getName() + " type:" + this.m.SexType);
		_user.getFlags().set("lewdCont_" + _target.getID(), this.m.SexType);
		_target.getFlags().set("lewdCont_" + _user.getID(), this.m.SexType);
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;

		::logInfo("[sex] " + _user.getName() + " uses " + this.m.ID + " on " + target.getName());
		this.Tactical.EventLog.log("[DBG] " + _user.getName() + " attempts " + this.m.ID + " on " + target.getName());

		local hitResult = this.rollHit(_user, target);
		::logInfo("[sex]   hit roll:" + hitResult.roll + " chance:" + hitResult.chance + " autoHit:" + this.isAutoHit(target) + " -> " + (hitResult.hit ? "HIT" : "MISS"));
		if (!hitResult.hit)
		{
			this.logMiss(_user, target, hitResult);
			return true;
		}

		local pleasure = this.calculatePleasure(target);
		::logInfo("[sex]   pleasure:" + pleasure + " target pleasure:" + target.getPleasure() + "/" + target.getPleasureMax());
		target.addPleasure(pleasure, _user);
		this.playSoundOnHit(target);
		this.logHit(_user, target, pleasure, hitResult);
		this.onHit(_user, target);
		this.recordSexContinuation(_user, target);
		return true;
	}

	function playSoundOnHit( _target )
	{
		local pool = _target.getGender() == 0 && this.m.SoundOnHitMale.len() > 0
			? this.m.SoundOnHitMale
			: this.m.SoundOnHit;

		if (pool.len() > 0)
			this.Sound.play(pool[this.Math.rand(0, pool.len() - 1)], this.Const.Sound.Volume.Skill, _target.getPos());
	}

	function rollHit( _user, _target )
	{
		local chance = this.getHitChanceAgainst(_target);
		local roll = this.Math.rand(1, 100);
		return { chance = chance, roll = roll, hit = roll <= chance };
	}

	function logMiss( _user, _target, _hitResult )
	{
		local verb = this.m.MissText[this.Math.rand(0, this.m.MissText.len() - 1)];
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " tries to " + verb + " " + this.Const.UI.getColorizedEntityName(_target) + " but fails (roll:" + _hitResult.roll + " chance:" + _hitResult.chance + ")");
	}

	function logHit( _user, _target, _pleasure, _hitResult )
	{
		local verb = this.m.HitText[this.Math.rand(0, this.m.HitText.len() - 1)];
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " " + verb + " " + this.Const.UI.getColorizedEntityName(_target) + " for " + _pleasure + " pleasure (roll:" + _hitResult.roll + " chance:" + _hitResult.chance + ")");
	}

	function tryApplyHorny( _target )
	{
		if (_target.getPleasureMax() <= 0) return;
		local roll = this.Math.rand(1, 100);
		if (roll > ::Lewd.Const.HornyApplyChance)
		{
			::logInfo("[sex]   horny check: roll " + roll + " > " + ::Lewd.Const.HornyApplyChance + " — no horny");
			return;
		}

		if (_target.getSkills().hasSkill("effects.lewd_horny"))
		{
			::logInfo("[sex]   horny refreshed on " + _target.getName());
			local effect = _target.getSkills().getSkillByID("effects.lewd_horny");
			effect.onRefresh();
		}
		else
		{
			::logInfo("[sex]   horny APPLIED to " + _target.getName());
			local horny = this.new("scripts/skills/effects/lewd_horny_effect");
			_target.getSkills().add(horny);
		}
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
	}

	// --- Virtual stubs (subclasses must override) ---

	function calculatePleasure( _target )
	{
		return 0;
	}

	function getHitChanceAgainst( _target )
	{
		return 0;
	}

	function isHidden()
	{
		return true;
	}

	function onHit( _user, _target )
	{
		this.tryApplyHorny(_target);
	}
});
