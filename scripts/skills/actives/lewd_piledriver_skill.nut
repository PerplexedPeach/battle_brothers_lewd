// Piledriver: Unhold boss grabs a target, carries them one tile, and penetrates.
// Combines fling_back's grab-and-carry with vaginal penetration mechanics.
// Only targets females with allure > 0 and PleasureMax > 0.
this.lewd_piledriver_skill <- this.inherit("scripts/skills/skill", {
	m = {
		BasePleasure = 60,
		MeleeSkillScale = 0.50,
		BaseHitChance = 80,
		SelfPleasure = 6
	},
	function create()
	{
		this.m.ID = "actives.lewd_piledriver";
		this.m.Name = "Piledriver";
		this.m.Description = "Grab a target and pin them to the ground, overwhelming them with a long, dexterous tongue.";
		this.m.Icon = "skills/active_110.png";
		this.m.IconDisabled = "skills/active_110.png";
		this.m.Overlay = "active_110";
		this.m.SoundOnUse = [
			"sounds/enemies/unhold_swipe_hit_01.wav",
			"sounds/enemies/unhold_swipe_hit_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingActorPitch = true;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function isUsable()
	{
		// Cannot use base isUsable() because it checks !isHidden(), and this skill is hidden from player UI
		local actor = this.getContainer().getActor();
		return this.m.IsUsable
			&& actor.getCurrentProperties().IsAbleToUseSkills;
	}

	function isHidden()
	{
		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsOccupiedByActor)
			return false;

		local target = _targetTile.getEntity();
		if (target == null)
			return false;

		local user = this.getContainer().getActor();
		if (target.isAlliedWith(user))
		{
			::logInfo("[piledriver] verify failed: allied");
			return false;
		}

		if (target.getGender() != 1)
		{
			::logInfo("[piledriver] verify failed: gender=" + target.getGender());
			return false;
		}

		if (target.getPleasureMax() <= 0)
		{
			::logInfo("[piledriver] verify failed: pleasureMax=" + target.getPleasureMax());
			return false;
		}

		if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			::logInfo("[piledriver] verify failed: immune to grab");
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;

		this.getContainer().setBusy(true);

		// Ensure enemy is visible to player during animation
		if (!_user.isPlayerControlled() && target.isPlayerControlled())
			_user.getTile().addVisibilityForFaction(this.Const.Faction.Player);

		// Play sound
		if (this.m.SoundOnUse.len() != 0)
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());

		// Strip defensive stances
		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");

		// Swap positions: unhold grabs target and flings them behind
		target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		this.Tactical.getNavigator().switchEntities(_user, target, null, null, 1.0);

		// Apply effects after fling animation completes
		local tag = {
			User = _user,
			Target = target
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 750, this.onApplyEffects.bindenv(this), tag);
		return true;
	}

	function onApplyEffects( _tag )
	{
		local user = _tag.User;
		local target = _tag.Target;

		if (!user.isAlive() || !target.isAlive())
		{
			this.getContainer().setBusy(false);
			return;
		}

		// Roll for hit
		local hitChance = this.calculateHitChance(user, target);
		local roll = this.Math.rand(1, 100);
		local hit = roll <= hitChance;

		if (hit)
		{
			local layers = this.Const.ShakeCharacterLayers[2];
			local userTile = user.getTile();
			local targetTile = target.getTile();

			// 3 shakes: unhold thrusts toward target, target shakes away
			local beyondTile = targetTile.hasNextTile(userTile.getDirectionTo(targetTile))
				? targetTile.getNextTile(userTile.getDirectionTo(targetTile))
				: targetTile;

			for (local i = 0; i < 3; i++)
			{
				local shakeDelay = i * 400;
				local isLast = i == 2;
				this.Time.scheduleEvent(this.TimeUnit.Virtual, shakeDelay,
					function(_d) {
						if (!_d.User.isAlive() || !_d.Target.isAlive()) return;
						// Play sex sound on each thrust
						local sounds = ::Lewd.Const.SoundFucking;
						if (sounds.len() > 0)
							this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Skill * ::Lewd.Const.SexSoundVolume, _d.Target.getPos());
						// Shake user toward target
						this.Tactical.getShaker().cancel(_d.User);
						this.Tactical.getShaker().shake(_d.User, _d.TargetTile, 3);
						// Shake target away with pink flash on final shake
						this.Tactical.getShaker().cancel(_d.Target);
						if (_d.IsLast)
							this.Tactical.getShaker().shake(_d.Target, _d.BeyondTile, 3,
								this.createColor("#ff1493"), this.createColor("#ff69b4"),
								1.5, 0.8, _d.Layers, 1.0);
						else
							this.Tactical.getShaker().shake(_d.Target, _d.BeyondTile, 2);
						this.Tactical.getCamera().quake(_d.User, _d.Target, 2.0, 0.1, 0.2);
					}.bindenv(this),
					{ User = user, Target = target, TargetTile = targetTile, BeyondTile = beyondTile, IsLast = isLast, Layers = layers });
			}

			// Apply effects after animation (3 shakes * 400ms)
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 1200,
				function(_d) {
					if (!_d.User.isAlive() || !_d.Target.isAlive())
					{
						_d.Container.setBusy(false);
						return;
					}

					this.applyMount(_d.User, _d.Target);

					local pleasure = this.calculatePleasure(_d.User, _d.Target);
					local actualPleasure = _d.Target.addPleasure(pleasure, _d.User);

					if (this.m.SelfPleasure > 0 && _d.User.getPleasureMax() > 0)
						_d.User.addPleasure(this.m.SelfPleasure);

					if (!_d.Target.getSkills().hasSkill("effects.lewd_horny"))
					{
						local horny = this.new("scripts/skills/effects/lewd_horny_effect");
						_d.Target.getSkills().add(horny);
					}

					if (_d.Target.getTile().IsVisibleForPlayer)
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_d.User) + " pins " + this.Const.UI.getColorizedEntityName(_d.Target) + " down and ravishes them with its tongue (+" + actualPleasure + " pleasure)");

					_d.Container.setBusy(false);
				}.bindenv(this),
				{ User = user, Target = target, Container = this.getContainer() });
		}
		else
		{
			// Miss: light shake, then release
			if (!user.isHiddenToPlayer() || !target.isHiddenToPlayer())
			{
				this.Tactical.getShaker().shake(user, target.getTile(), 2);
				this.Tactical.getShaker().shake(target, user.getTile(), 2);
			}

			if (target.getTile().IsVisibleForPlayer)
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " pins " + this.Const.UI.getColorizedEntityName(target) + " but fails to find purchase");

			this.Time.scheduleEvent(this.TimeUnit.Virtual, 300,
				function(_d) { _d.Container.setBusy(false); }.bindenv(this),
				{ Container = this.getContainer() });
		}
	}

	function calculateHitChance( _user, _target )
	{
		local p = _user.getCurrentProperties();
		local tp = _target.getCurrentProperties();

		// Auto-hit horny targets
		if (_target.getSkills().hasSkill("effects.lewd_horny"))
			return 95;

		local chance = this.m.BaseHitChance + (p.getMeleeSkill() - tp.getMeleeDefense());
		return this.Math.max(20, this.Math.min(95, chance));
	}

	function calculatePleasure( _user, _target )
	{
		local p = _user.getCurrentProperties();
		local pleasure = this.m.BasePleasure + this.Math.floor(p.getMeleeSkill() * this.m.MeleeSkillScale);

		// Mounted bonus
		if (_target.getSkills().hasSkill("effects.lewd_mounted"))
			pleasure += 6;

		return this.Math.max(1, pleasure);
	}

	function applyMount( _user, _target )
	{
		if (!_target.getSkills().hasSkill("effects.lewd_mounted"))
		{
			local mounted = this.new("scripts/skills/effects/lewd_mounted_effect");
			_target.getSkills().add(mounted);
			mounted.addMounter(_user.getID());
			mounted.setTurns(::Lewd.Const.MountDuration);
		}
		else
		{
			local mounted = _target.getSkills().getSkillByID("effects.lewd_mounted");
			mounted.addMounter(_user.getID());
			mounted.setTurns(::Lewd.Const.MountDuration);
		}

		if (!_user.getSkills().hasSkill("effects.lewd_mounting"))
		{
			local mounting = this.new("scripts/skills/effects/lewd_mounting_effect");
			mounting.setTarget(_target.getID());
			_user.getSkills().add(mounting);
		}
		else
		{
			local mounting = _user.getSkills().getSkillByID("effects.lewd_mounting");
			mounting.setTarget(_target.getID());
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
});
