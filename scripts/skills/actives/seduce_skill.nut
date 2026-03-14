// Tease — targeted horny induction
// Ranged: allure + bonus vs resolve, distance penalty
// Melee (Grind): same formula + melee skill bonus
// On hit: applies Horny to target
this.seduce_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.tease";
		this.m.Name = "Tease";
		this.m.Description = "Flaunt yourself at a target to make them Horny. In melee range, becomes Grind for additional effectiveness.";
		this.m.Icon = "skills/seduce.png";
		this.m.IconDisabled = "skills/seduce_bw.png";
		this.m.Overlay = "active_120";
		// TODO: need a separate icon for the Grind melee variant
		this.m.SoundOnUse = ::Lewd.Const.SoundMoans;
		this.m.SoundOnHit = ::Lewd.Const.SoundCharmChimes;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = true;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = ::Lewd.Const.TeaseAP;
		this.m.FatigueCost = ::Lewd.Const.TeaseFatigue;
		this.m.MinRange = 1;
		this.m.MaxRange = ::Lewd.Const.TeaseMaxRange;
		this.m.MaxLevelDifference = 4;
	}

	function isMelee( _target )
	{
		local actor = this.getContainer().getActor();
		if (actor == null || !actor.isPlacedOnMap()) return false;
		return _target.getTile().getDistanceTo(actor.getTile()) <= 1;
	}

	function getTeaseChance( _target )
	{
		local actor = this.getContainer().getActor();
		local allure = actor.allure() + ::Lewd.Const.TeaseAllureBonus;
		local resolve = _target.getBravery();
		local distance = _target.getTile().getDistanceTo(actor.getTile());
		local chance = ::Lewd.Const.TeaseBaseChance + (allure - resolve) * ::Lewd.Const.TeaseAllureScale - (distance - 1) * ::Lewd.Const.TeaseDistancePenalty;

		// Melee bonus: Grind mode
		if (distance <= 1)
			chance += this.Math.floor(actor.getCurrentProperties().getMeleeSkill() * ::Lewd.Const.TeaseGrindMeleeScale);

		return this.Math.max(5, this.Math.min(95, chance));
	}

	function getHitchance( _targetEntity )
	{
		if (!_targetEntity.isAttackable()) return 0;
		return this.getTeaseChance(_targetEntity);
	}

	function getHitFactors( _targetTile )
	{
		local ret = [];
		local target = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
		if (target == null) return ret;

		local actor = this.getContainer().getActor();
		local baseAllure = actor.allure();
		local allure = baseAllure + ::Lewd.Const.TeaseAllureBonus;
		local resolve = target.getBravery();
		local distance = target.getTile().getDistanceTo(actor.getTile());
		local diff = allure - resolve;
		local pos = this.Const.UI.Color.PositiveValue;
		local neg = this.Const.UI.Color.NegativeValue;

		ret.push({
			icon = "ui/icons/special.png",
			text = "Base chance: [color=" + pos + "]" + ::Lewd.Const.TeaseBaseChance + "%[/color]"
		});
		ret.push({
			icon = "ui/icons/allure.png",
			text = "Allure: [color=" + pos + "]" + baseAllure + "[/color] [color=" + pos + "](+" + ::Lewd.Const.TeaseAllureBonus + " bonus)[/color]"
		});
		ret.push({
			icon = "ui/icons/bravery.png",
			text = "Target Resolve: [color=" + neg + "]" + resolve + "[/color]"
		});

		local scaled = this.Math.floor(diff * ::Lewd.Const.TeaseAllureScale);
		if (scaled >= 0)
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "[color=" + pos + "]+" + scaled + "%[/color] from Allure vs Resolve"
			});
		else
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "[color=" + neg + "]" + scaled + "%[/color] from Allure vs Resolve"
			});

		if (distance > 1)
		{
			local distPenalty = (distance - 1) * ::Lewd.Const.TeaseDistancePenalty;
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "[color=" + neg + "]-" + distPenalty + "%[/color] from distance (" + (distance - 1) + " tiles beyond melee)"
			});
		}

		if (distance <= 1)
		{
			local melBonus = this.Math.floor(actor.getCurrentProperties().getMeleeSkill() * ::Lewd.Const.TeaseGrindMeleeScale);
			ret.push({
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + pos + "]+" + melBonus + "%[/color] from Grind (Melee Skill)"
			});
		}

		return ret;
	}

	function getTooltip()
	{
		local actor = this.getContainer().getActor();
		local allure = actor.allure();
		local pos = this.Const.UI.Color.PositiveValue;
		local neg = this.Const.UI.Color.NegativeValue;
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
				text = "On hit: inflicts [color=" + pos + "]Horny[/color] on the target"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Base chance: [color=" + pos + "]" + ::Lewd.Const.TeaseBaseChance + "%[/color] with [color=" + pos + "]+" + ::Lewd.Const.TeaseAllureBonus + "[/color] Allure bonus"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "Your Allure: [color=" + pos + "]" + allure + "[/color] vs target Resolve (x" + ::Lewd.Const.TeaseAllureScale + ")"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Distance penalty: [color=" + neg + "]-" + ::Lewd.Const.TeaseDistancePenalty + "%[/color] per tile"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "In melee: [color=" + pos + "]Grind[/color] mode, adds Melee Skill * " + ::Lewd.Const.TeaseGrindMeleeScale + " to hit chance"
			}
		];
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
		local target = _targetTile.getEntity();
		if (target == null) return false;
		if (target.isAlliedWith(this.getContainer().getActor())) return false;
		if (target.getMoraleState() == this.Const.MoraleState.Ignore) return false;
		if (target.getGender() == 1) return false; // cannot tease females; use Playful Slap instead
		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;
		local distance = _targetTile.getDistanceTo(_user.getTile());

		if (distance <= 1)
		{
			// Grind mode: melee shake animation
			if (::Lewd.Const.SoundSpanking.len() > 0)
				this.Sound.play(::Lewd.Const.SoundSpanking[this.Math.rand(0, ::Lewd.Const.SoundSpanking.len() - 1)], this.Const.Sound.Volume.Skill * ::Lewd.Const.SexSoundVolume, _user.getPos());
			this.Tactical.getShaker().shake(_user, _targetTile, 3);
			this.Tactical.getShaker().shake(target, _user.getTile(), 3);
		}
		else
		{
			// Ranged mode: moan + heart projectile
			if (this.m.SoundOnUse.len() > 0)
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * ::Lewd.Const.SexSoundVolume, _user.getPos());
		}

		local tag = {
			User = _user,
			TargetTile = _targetTile,
			IsMelee = distance <= 1
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local target = _targetTile.getEntity();
		if (target == null || !target.isAlive()) return;
		if (!_user.isAlive()) return;

		local self = this;

		if (_tag.IsMelee)
		{
			// Melee: resolve immediately
			this.resolveTeaseHit(_user, target);
		}
		else
		{
			// Ranged: spawn heart projectile, resolve on arrival
			local time = this.Tactical.spawnProjectileEffect("effect_heart_01", _user.getTile(), _targetTile, 0.33, 2.0, false, false);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, time, function ( _e )
			{
				if (target.isAlive() && _user.isAlive())
					self.resolveTeaseHit(_user, target);
			}.bindenv(this), this);
		}
	}

	function resolveTeaseHit( _user, _target )
	{
		local chance = this.getTeaseChance(_target);
		local roll = this.Math.rand(1, 100);
		local isMelee = _target.getTile().getDistanceTo(_user.getTile()) <= 1;
		local modeName = isMelee ? "grinds against" : "teases";

		::logInfo("[tease] " + _user.getName() + " " + modeName + " " + _target.getName() + " (roll:" + roll + " chance:" + chance + ")");

		if (roll > chance)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " " + modeName + " " + this.Const.UI.getColorizedEntityName(_target) + " but fails (roll:" + roll + " chance:" + chance + ")");
			return;
		}

		// Apply or refresh Horny
		if (!_target.getSkills().hasSkill("effects.lewd_horny"))
		{
			local horny = this.new("scripts/skills/effects/lewd_horny_effect");
			_target.getSkills().add(horny);
		}
		else
		{
			_target.getSkills().getSkillByID("effects.lewd_horny").onRefresh();
		}

		// Crit: if roll is far enough below chance, also stun
		if (roll < chance - ::Lewd.Const.CritChanceThreshold)
		{
			local stunned = this.new("scripts/skills/effects/stunned_effect");
			_target.getSkills().add(stunned);
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_target) + " is stunned by the display!");
		}

		if (this.m.SoundOnHit.len() > 0)
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * ::Lewd.Const.SexSoundVolume, _target.getPos());

		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " " + modeName + " " + this.Const.UI.getColorizedEntityName(_target) + " and makes them Horny! (roll:" + roll + " chance:" + chance + ")");
	}

	function addResources()
	{
		this.skill.addResources();
		foreach (s in ::Lewd.Const.SoundSpanking)
			this.Tactical.addResource(s);
	}
});
