// Magical flight — teleport to an empty tile within range
// Based on darkflight (necrosavant), but uses pink magic visuals instead of bat particles
// Unlocked via lewd_flight_awakening event at high climax count
this.lewd_flight_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.lewd_flight";
		this.m.Name = "Arcane Flight";
		this.m.Description = "Dissolve into shimmering light and rematerialize at a distant point. Your body has become as much energy as flesh, and the space between two places is merely a suggestion.";
		this.m.Icon = "skills/lewd_flight.png";
		this.m.IconDisabled = "skills/lewd_flight_bw.png";
		this.m.Overlay = "lewd_flight";
		this.m.SoundOnUse = [
			"sounds/enemies/vampire_takeoff_01.wav",
			"sounds/enemies/vampire_takeoff_02.wav",
			"sounds/enemies/vampire_takeoff_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/vampire_landing_01.wav",
			"sounds/enemies/vampire_landing_02.wav",
			"sounds/enemies/vampire_landing_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = ::Lewd.Const.FlightAP;
		this.m.FatigueCost = ::Lewd.Const.FlightFatigue;
		this.m.MinRange = ::Lewd.Const.FlightMinRange;
		this.m.MaxRange = ::Lewd.Const.FlightMaxRange;
		this.m.MaxLevelDifference = ::Lewd.Const.FlightMaxLevelDifference;
	}

	function getTooltip()
	{
		local pos = this.Const.UI.Color.PositiveValue;
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
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Teleport to any empty tile within [color=" + pos + "]" + this.m.MaxRange + "[/color] tiles"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ignores Zone of Control"
			}
		];
	}

	function isHidden()
	{
		return !this.getContainer().getActor().getFlags().has("lewdFlightGranted");
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsEmpty)
			return false;
		return true;
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile,
			OnDone = this.onTeleportDone,
			OnFadeIn = this.onFadeIn,
			OnFadeDone = this.onFadeDone,
			OnTeleportStart = this.onTeleportStart,
			IgnoreColors = false
		};

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " uses Arcane Flight");
		}

		if (_user.getTile().IsVisibleForPlayer)
		{
			// Pink glow on departure
			this.Tactical.spawnSpriteEffect("pheromones", this.createColor("#ff69b4"), _user.getTile(),
				this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY,
				this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale,
				this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);

			// Use darkflight bat particles for the departure
			if (this.Const.Tactical.DarkflightStartParticles.len() != 0)
			{
				for (local i = 0; i < this.Const.Tactical.DarkflightStartParticles.len(); i = ++i)
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DarkflightStartParticles[i].Brushes, _user.getTile(), this.Const.Tactical.DarkflightStartParticles[i].Delay, this.Const.Tactical.DarkflightStartParticles[i].Quantity, this.Const.Tactical.DarkflightStartParticles[i].LifeTimeQuantity, this.Const.Tactical.DarkflightStartParticles[i].SpawnRate, this.Const.Tactical.DarkflightStartParticles[i].Stages);
				}
			}

			_user.storeSpriteColors();
			_user.fadeTo(this.createColor("00000000"), ::Lewd.Const.FlightFadeOutDuration);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, ::Lewd.Const.FlightFadeOutDuration, this.onTeleportStart, tag);
		}
		else if (_targetTile.IsVisibleForPlayer)
		{
			_user.storeSpriteColors();
			_user.fadeTo(this.createColor("00000000"), 0);
			this.onTeleportStart(tag);
		}
		else
		{
			tag.IgnoreColors = true;
			this.onTeleportStart(tag);
		}

		return true;
	}

	function onTeleportStart( _tag )
	{
		this.Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, _tag.OnDone, _tag, false, 2.0);
	}

	function onTeleportDone( _entity, _tag )
	{
		if (!_entity.isHiddenToPlayer())
		{
			// Pink glow on arrival
			this.Tactical.spawnSpriteEffect("pheromones", this.createColor("#ff69b4"), _entity.getTile(),
				this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY,
				this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale,
				this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);

			// Darkflight arrival particles
			if (this.Const.Tactical.DarkflightEndParticles.len() != 0)
			{
				for (local i = 0; i < this.Const.Tactical.DarkflightEndParticles.len(); i = ++i)
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DarkflightEndParticles[i].Brushes, _entity.getTile(), this.Const.Tactical.DarkflightEndParticles[i].Delay, this.Const.Tactical.DarkflightEndParticles[i].Quantity, this.Const.Tactical.DarkflightEndParticles[i].LifeTimeQuantity, this.Const.Tactical.DarkflightEndParticles[i].SpawnRate, this.Const.Tactical.DarkflightEndParticles[i].Stages);
				}
			}

			this.Time.scheduleEvent(this.TimeUnit.Virtual, 800, _tag.OnFadeIn, _tag);

			if (_entity.getTile().IsVisibleForPlayer && _tag.Skill.m.SoundOnHit.len() > 0)
			{
				this.Sound.play(_tag.Skill.m.SoundOnHit[this.Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _entity.getPos());
			}
		}
		else
		{
			_tag.OnFadeIn(_tag);
		}
	}

	function onFadeIn( _tag )
	{
		if (!_tag.IgnoreColors)
		{
			if (_tag.User.isHiddenToPlayer())
			{
				_tag.User.restoreSpriteColors();
			}
			else
			{
				_tag.User.fadeToStoredColors(::Lewd.Const.FlightFadeInDuration);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, ::Lewd.Const.FlightFadeInDuration, _tag.OnFadeDone, _tag);
			}
		}
	}

	function onFadeDone( _tag )
	{
		_tag.User.restoreSpriteColors();
	}
});
