this.seduce_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Slaves = []
	},
	function removeSlave( _entityID )
	{
		local i = this.m.Slaves.find(_entityID);

		if (i != null)
		{
			this.m.Slaves.remove(i);
		}
	}

	function isAlive()
	{
		return this.getContainer() != null && !this.getContainer().isNull() && this.getContainer().getActor() != null && !this.getContainer().getActor().isNull() && this.getContainer().getActor().isAlive() && this.getContainer().getActor().getHitpoints() > 0;
	}

	function create()
	{
		this.m.ID = "actives.seduce";
		this.m.Name = "Seduce";
		this.m.Description = "Work your charms you convince your enemies to fight for you.";
		// TODO add icons
		this.m.Icon = "skills/seduce.png";
		this.m.IconDisabled = "skills/seduce_bw.png";
		this.m.Overlay = "active_120";
		this.m.SoundOnUse = ::Lewd.Const.SoundMoans;
		this.m.SoundOnHit = [
			"sounds/enemies/dlc2/hexe_charm_chimes_01.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_02.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_03.wav",
			"sounds/enemies/dlc2/hexe_charm_chimes_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = true;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 4;
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
				text = "Base chance: [color=" + pos + "]" + ::Lewd.Const.SeduceBaseChance + "%[/color]"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "Your Allure: [color=" + pos + "]" + allure + "[/color] vs target Resolve (x" + ::Lewd.Const.SeduceAllureChanceMultiplier + ")"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Distance penalty: [color=" + neg + "]-" + ::Lewd.Const.SeduceDistancePenalty + "%[/color] per tile"
			}
		];
	}

	function getSeduceChance( _target )
	{
		local actor = this.getContainer().getActor();
		local allure = actor.allure();
		local resolve = _target.getBravery();
		local distance = _target.getTile().getDistanceTo(actor.getTile());
		local chance = ::Lewd.Const.SeduceBaseChance + (allure - resolve) * ::Lewd.Const.SeduceAllureChanceMultiplier - distance * ::Lewd.Const.SeduceDistancePenalty;
		return this.Math.max(0, this.Math.min(100, chance));
	}

	function getHitchance( _targetEntity )
	{
		if (!_targetEntity.isAttackable()) return 0;
		return this.getSeduceChance(_targetEntity);
	}

	function getHitFactors( _targetTile )
	{
		local ret = [];
		local target = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
		if (target == null) return ret;

		local actor = this.getContainer().getActor();
		local allure = actor.allure();
		local resolve = target.getBravery();
		local distance = target.getTile().getDistanceTo(actor.getTile());
		local diff = allure - resolve;
		local pos = this.Const.UI.Color.PositiveValue;
		local neg = this.Const.UI.Color.NegativeValue;

		ret.push({
			icon = "ui/icons/special.png",
			text = "Base chance: [color=" + pos + "]" + ::Lewd.Const.SeduceBaseChance + "%[/color]"
		});
		ret.push({
			icon = "ui/icons/allure.png",
			text = "Allure: [color=" + pos + "]" + allure + "[/color]"
		});
		ret.push({
			icon = "ui/icons/bravery.png",
			text = "Target Resolve: [color=" + neg + "]" + resolve + "[/color]"
		});

		local scaled = diff * ::Lewd.Const.SeduceAllureChanceMultiplier;
		if (scaled >= 0)
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "[color=" + pos + "]+" + scaled + "%[/color] from Allure vs Resolve (x" + ::Lewd.Const.SeduceAllureChanceMultiplier + ")"
			});
		else
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "[color=" + neg + "]" + scaled + "%[/color] from Allure vs Resolve (x" + ::Lewd.Const.SeduceAllureChanceMultiplier + ")"
			});

		if (distance > 0)
		{
			local distPenalty = distance * ::Lewd.Const.SeduceDistancePenalty;
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "[color=" + neg + "]-" + distPenalty + "%[/color] from distance (" + distance + " tiles)"
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
		local target = _targetTile.getEntity();
		if (target == null) return false;
		if (target.isAlliedWith(this.getContainer().getActor())) return false;
		if (target.getGender() == 1) return false;
		if (target.getMoraleState() == this.Const.MoraleState.Ignore || target.getMoraleState() == this.Const.MoraleState.Fleeing) return false;
		if (target.getCurrentProperties().MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] >= 1000.0) return false;
		if (target.getSkills().hasSkill("effects.charmed") || target.getSkills().hasSkill("effects.seduced")) return false;
		return true;
	}

	function addResources()
	{
		this.skill.addResources();
		foreach (s in ::Lewd.Const.SoundSpanking)
			this.Tactical.addResource(s);
	}

	function onUse( _user, _targetTile )
	{
		if (::Lewd.Const.SoundSpanking.len() > 0)
			this.Sound.play(::Lewd.Const.SoundSpanking[this.Math.rand(0, ::Lewd.Const.SoundSpanking.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
		local tag = {
			User = _user,
			TargetTile = _targetTile
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	function onDelayedEffect( _tag )
	{
		local _targetTile = _tag.TargetTile;
		local _user = _tag.User;
		local target = _targetTile.getEntity();
		local time = this.Tactical.spawnProjectileEffect("effect_heart_01", _user.getTile(), _targetTile, 0.33, 2.0, false, false);
		local self = this;
		this.Time.scheduleEvent(this.TimeUnit.Virtual, time, function ( _e )
		{
			local roll = this.Math.rand(0, 100);

			local resolve = target.getBravery();
			local allure = _user.allure();
			local chance = ::Lewd.Const.SeduceBaseChance + (allure - resolve) * ::Lewd.Const.SeduceAllureChanceMultiplier - _targetTile.getDistanceTo(_user.getTile()) * ::Lewd.Const.SeduceDistancePenalty;

			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " is being seduced by " + this.Const.UI.getColorizedEntityName(_user) + " (Chance: " + chance + ", Rolled: " + roll + ") (" + allure + " allure vs " + resolve + " bravery)");

			if (roll >= chance)
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " resists being seduced thanks to his resolve");
				}

				return false;
			}


			if (target.getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
			{
				if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " resists being seduced thanks to their unnatural physiology");
				}

				return false;
			}

			this.m.Slaves.push(target.getID());
			local charmed = this.new("scripts/skills/effects/charmed_effect");
			charmed.setMasterFaction(_user.getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : _user.getFaction());
			charmed.setMaster(self);
			target.getSkills().add(charmed);

			if (self.m.SoundOnHit.len() > 0)
				this.Sound.play(self.m.SoundOnHit[this.Math.rand(0, self.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, target.getPos());

			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(target) + " is seduced");
			}

		}.bindenv(this), this);
	}

	function onDeath( _fatalityType )
	{
		foreach( id in this.m.Slaves )
		{
			local e = this.Tactical.getEntityByID(id);

			if (e != null)
			{
				e.getSkills().removeByID("effects.charmed");
			}
		}

		this.m.Slaves = [];
	}
});

