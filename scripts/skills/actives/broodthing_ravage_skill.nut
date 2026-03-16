// Broodthing Ravage -- replaces kraken devour.
// Hits all adjacent enemies, deals massive pleasure instead of killing.
// Uses kraken_devour ID so the existing kraken AI agent picks it up.
this.broodthing_ravage_skill <- this.inherit("scripts/skills/skill", {
	m = {
		BasePleasure = 80,
		SelfPleasure = 10
	},
	function create()
	{
		// ID must match kraken_devour so the kraken_agent AI uses it
		this.m.ID = "actives.kraken_devour";
		this.m.Name = "Ravage";
		this.m.Description = "Lash out with all tentacles at once, overwhelming every adjacent victim with pleasure.";
		this.m.Icon = "skills/active_150.png";
		this.m.Overlay = "active_150";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/krake_devour_01.wav",
			"sounds/enemies/dlc2/krake_devour_02.wav",
			"sounds/enemies/dlc2/krake_devour_03.wav",
			"sounds/enemies/dlc2/krake_devour_04.wav",
			"sounds/enemies/dlc2/krake_devour_05.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 2400;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAudibleWhenHidden = false;
		this.m.IsUsingActorPitch = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 4;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
			return false;

		// Need at least one adjacent enemy
		local myTile = this.getContainer().getActor().getTile();

		for (local i = 0; i < 6; i++)
		{
			if (!myTile.hasNextTile(i))
				continue;

			local tile = myTile.getNextTile(i);

			if (tile.IsOccupiedByActor && !tile.getEntity().isAlliedWith(this.getContainer().getActor()))
				return true;
		}

		return false;
	}

	function onUse( _user, _targetTile )
	{
		// Gather all adjacent enemies
		local myTile = _user.getTile();
		local targets = [];

		for (local i = 0; i < 6; i++)
		{
			if (!myTile.hasNextTile(i))
				continue;

			local tile = myTile.getNextTile(i);

			if (tile.IsOccupiedByActor && !tile.getEntity().isAlliedWith(_user))
				targets.push(tile.getEntity());
		}

		if (targets.len() == 0)
			return false;

		this.getContainer().setBusy(true);

		// Camera shake on use
		this.Tactical.getCamera().quake(_user, targets[0], 4.0, 0.16, 0.3);

		// 5 shakes with sex sounds, longer and heavier than piledriver
		local layers = this.Const.ShakeCharacterLayers[2];

		for (local i = 0; i < 5; i++)
		{
			local shakeDelay = i * 350;
			local isLast = i == 4;
			this.Time.scheduleEvent(this.TimeUnit.Virtual, shakeDelay,
				function(_d) {
					if (!_d.User.isAlive()) return;

					// Sex sound on each thrust
					local sounds = ::Lewd.Const.SoundFucking;
					if (sounds.len() > 0)
						this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Skill * ::Lewd.Const.SexSoundVolume * 1.5, _d.User.getPos());

					// Shake all targets
					foreach (t in _d.Targets)
					{
						if (!t.isAlive()) continue;

						this.Tactical.getShaker().cancel(t);

						if (_d.IsLast)
							this.Tactical.getShaker().shake(t, _d.UserTile, 4,
								this.createColor("#ff1493"), this.createColor("#ff69b4"),
								1.5, 0.8, _d.Layers, 1.0);
						else
							this.Tactical.getShaker().shake(t, _d.UserTile, 3);
					}

					this.Tactical.getCamera().quake(_d.User, _d.Targets[0], 2.5, 0.1, 0.15);
				}.bindenv(this),
				{
					User = _user,
					Targets = targets,
					UserTile = myTile,
					IsLast = isLast,
					Layers = layers
				});
		}

		// Apply pleasure after animation (5 shakes * 350ms)
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 1750,
			function(_d) {
				if (!_d.User.isAlive())
				{
					_d.Container.setBusy(false);
					return;
				}

				foreach (target in _d.Targets)
				{
					if (!target.isAlive()) continue;

					// Only deal pleasure to targets with PleasureMax
					if (target.getPleasureMax() > 0)
					{
						local pleasure = _d.Skill.m.BasePleasure;
						local actualPleasure = target.addPleasure(pleasure, _d.User);

						// Apply horny
						if (!target.getSkills().hasSkill("effects.lewd_horny"))
						{
							local horny = this.new("scripts/skills/effects/lewd_horny_effect");
							target.getSkills().add(horny);
						}

						if (target.getTile().IsVisibleForPlayer)
							this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_d.User) + " ravages " + this.Const.UI.getColorizedEntityName(target) + " (+" + actualPleasure + " pleasure)");
					}
					else
					{
						// Non-pleasure targets take HP damage instead
						local hitInfo = clone this.Const.Tactical.HitInfo;
						hitInfo.DamageRegular = this.Math.rand(30, 50);
						hitInfo.DamageDirect = 0.5;
						hitInfo.BodyPart = this.Const.BodyPart.Body;
						hitInfo.BodyDamageMult = 1.0;
						hitInfo.FatalityChanceMult = 0.0;
						target.onDamageReceived(_d.User, _d.Skill, hitInfo);

						if (target.isAlive() && target.getTile().IsVisibleForPlayer)
							this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_d.User) + " batters " + this.Const.UI.getColorizedEntityName(target));
					}
				}

				// Self-pleasure to the broodthing
				if (_d.Skill.m.SelfPleasure > 0 && _d.User.getPleasureMax() > 0)
					_d.User.addPleasure(_d.Skill.m.SelfPleasure);

				_d.Container.setBusy(false);
			}.bindenv(this),
			{
				User = _user,
				Targets = targets,
				Skill = this,
				Container = this.getContainer()
			});

		return true;
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
