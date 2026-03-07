// Base class for all sex abilities (both player/female and enemy/male)
// Provides shared: create() flags, onUse() flow, playSound, rollHit, tryApplyHorny,
// isAutoHit, onVerifyTarget, logMiss/logHit, getTooltip base entries
// Subclasses: female_sex_skill (tiers/mastery), male_sex_skill (flat values)
this.sex_skill_base <- this.inherit("scripts/skills/skill", {
	m = {
		SexType = "",
		HitText = [],
		MissText = [],
		SoundOnHitMale = [],
		SexDelay = 400,
		ShakeCount = 1,
		ShakeIntensity = 4,
		ShakeTargetAway = false,
		ShakeTargetDelay = 0,
		ShakeTargetIntensity = 0
	},
	function create()
	{
		this.m.SoundOnUse = [];
		this.m.SoundOnHit = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = true;
		this.m.IsDoingForwardMove = false;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.Delay = 400;
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

		_user.getFlags().set("lewdAlluringUsed", 1);
		::logInfo("[sex] " + _user.getName() + " uses " + this.m.ID + " on " + target.getName());

		// Roll hit up front so we can play the right animation
		local hitResult = this.rollHit(_user, target);
		::logInfo("[sex]   hit roll:" + hitResult.roll + " chance:" + hitResult.chance
			+ " autoHit:" + this.isAutoHit(target) + " -> " + (hitResult.hit ? "HIT" : "MISS"));

		if (hitResult.hit)
		{
			this.playLungeAnimation(_user, _targetTile);
			this.playSoundOnHit(target);
		}
		else
		{
			this.playMissAnimation(_user, _targetTile);
		}

		this.getContainer().setBusy(true);

		local delay = hitResult.hit ? this.m.SexDelay : 100;
		this.Time.scheduleEvent(this.TimeUnit.Virtual, delay,
			this.onScheduledSexHit.bindenv(this), {
				Container = this.getContainer(),
				User = _user,
				Target = target,
				HitResult = hitResult
			});

		return true;
	}

	function getBeyondTile( _fromTile, _toTile )
	{
		// Returns the tile beyond _toTile, continuing the direction from _fromTile to _toTile
		local dir = _fromTile.getDirectionTo(_toTile);
		if (_toTile.hasNextTile(dir))
			return _toTile.getNextTile(dir);
		return _toTile;
	}

	function shakeWithFlash( _entity, _tile, _intensity, _flash, _layers )
	{
		this.Tactical.getShaker().cancel(_entity);
		if (_flash && !_entity.isHiddenToPlayer())
			this.Tactical.getShaker().shake(_entity, _tile, _intensity,
				::Lewd.Const.SexFlashColor, ::Lewd.Const.SexFlashHighlight,
				::Lewd.Const.SexFlashFactor, ::Lewd.Const.SexFlashSaturation,
				_layers, 1.0);
		else
			this.Tactical.getShaker().shake(_entity, _tile, _intensity);
	}

	function playLungeAnimation( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (_user.isHiddenToPlayer() && target.isHiddenToPlayer())
			return;

		local userTile = _user.getTile();
		local targetInt = this.m.ShakeTargetIntensity > 0 ? this.m.ShakeTargetIntensity : this.m.ShakeIntensity;
		local isOnlyShake = this.m.ShakeCount <= 1;
		local flashUser = this.getSelfPleasure() > 0;
		local layers = this.Const.ShakeCharacterLayers[2];

		// Determine shake tiles based on mode
		local userShakeTile;
		local targetShakeTile;

		if (this.m.ShakeTargetAway)
		{
			// Thrust/fucking mode: male toward female, female away from male
			if (_user.getGender() == 0)
			{
				userShakeTile = _targetTile;
				targetShakeTile = this.getBeyondTile(userTile, _targetTile);
			}
			else
			{
				userShakeTile = this.getBeyondTile(_targetTile, userTile);
				targetShakeTile = userTile;
			}
		}
		else
		{
			// Non-penetrative: shake toward each other
			userShakeTile = _targetTile;
			targetShakeTile = userTile;
		}

		// First shake: user (with pink flash if only shake and has self-pleasure)
		this.shakeWithFlash(_user, userShakeTile, this.m.ShakeIntensity, isOnlyShake && flashUser, layers);

		// First shake: target (with pink flash if this is the only shake)
		if (this.m.ShakeTargetDelay <= 0)
		{
			this.shakeWithFlash(target, targetShakeTile, targetInt, isOnlyShake, layers);
		}
		else
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, this.m.ShakeTargetDelay,
				function(_d) {
					if (_d.Target.isAlive())
						this.shakeWithFlash(_d.Target, _d.ShakeTile, _d.Intensity, _d.Flash, _d.Layers);
				}.bindenv(this),
				{ Target = target, ShakeTile = targetShakeTile, Intensity = targetInt, Flash = isOnlyShake, Layers = layers });
		}

		// Camera quake on first shake
		this.Tactical.getCamera().quake(_user, target, 2.0, 0.1, 0.2);

		// Additional shakes for multi-thrust abilities (500ms interval)
		if (this.m.ShakeCount > 1)
		{
			for (local i = 1; i < this.m.ShakeCount; i++)
			{
				local shakeDelay = i * 500;
				local isLast = i == this.m.ShakeCount - 1;
				local userInt = isLast
					? this.m.ShakeIntensity
					: this.m.ShakeIntensity - 1;
				local tInt = isLast
					? targetInt
					: targetInt - 1;
				this.Time.scheduleEvent(this.TimeUnit.Virtual, shakeDelay,
					function(_d) {
						if (_d.User.isAlive())
							this.shakeWithFlash(_d.User, _d.UserShakeTile, _d.UserInt, _d.IsLast && _d.FlashUser, _d.Layers);
						if (_d.Target.isAlive())
							this.shakeWithFlash(_d.Target, _d.TargetShakeTile, _d.TargetInt, _d.IsLast, _d.Layers);
						this.Tactical.getCamera().quake(_d.User, _d.Target, 2.0, 0.1, 0.2);
					}.bindenv(this),
					{ User = _user, Target = target, UserShakeTile = userShakeTile, TargetShakeTile = targetShakeTile, UserInt = userInt, TargetInt = tInt, IsLast = isLast, FlashUser = flashUser, Layers = layers });
			}
		}
	}

	function playMissAnimation( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (_user.isHiddenToPlayer() && target.isHiddenToPlayer())
			return;

		// Light shake toward each other, no flash, no camera quake
		local userTile = _user.getTile();
		this.Tactical.getShaker().shake(_user, _targetTile, 2);
		this.Tactical.getShaker().shake(target, userTile, 2);
	}

	function onScheduledSexHit( _info )
	{
		_info.Container.setBusy(false);

		local user = _info.User;
		local target = _info.Target;

		if (!user.isAlive() || !target.isAlive()) return;

		local hitResult = _info.HitResult;
		if (!hitResult.hit)
		{
			this.logMiss(user, target, hitResult);
			return;
		}

		local pleasure = this.calculatePleasure(target);
		local selfP = this.getSelfPleasure();
		::logInfo("[sex]   pleasure:" + pleasure + " self:" + selfP + " target pleasure:"
			+ target.getPleasure() + "/" + target.getPleasureMax());
		target.addPleasure(pleasure, user);
		this.logHit(user, target, pleasure, hitResult, selfP);
		this.onHit(user, target);
		this.recordSexContinuation(user, target);
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

	function logHit( _user, _target, _pleasure, _hitResult, _selfPleasure = 0 )
	{
		local verb = this.m.HitText[this.Math.rand(0, this.m.HitText.len() - 1)];
		local selfStr = _selfPleasure > 0 ? " (self: " + _selfPleasure + ")" : "";
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " " + verb + " " + this.Const.UI.getColorizedEntityName(_target) + " for " + _pleasure + " pleasure" + selfStr + " (roll:" + _hitResult.roll + " chance:" + _hitResult.chance + ")");
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

	function getSelfPleasure()
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
