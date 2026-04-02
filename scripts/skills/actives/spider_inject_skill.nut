// Spider Inject: spider oviposits into a rooted (webbed) target.
// Adds spider_eggs_effect (the persistent egg injury). Each subsequent climax
// adds +1 egg stack via onOwnerClimax on the effect itself.
// Requires target to be rooted (from web or other source).
this.spider_inject_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.spider_inject";
		this.m.Name = "Oviposit";
		this.m.Description = "Inject eggs into a helpless, immobilized prey.";
		this.m.Icon = "skills/lewd_spider_oviposit.png";
		this.m.IconDisabled = "skills/lewd_spider_oviposit_bw.png";
		this.m.Overlay = "lewd_spider_oviposit";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/giant_spider_idle_01.wav",
			"sounds/enemies/dlc2/giant_spider_idle_02.wav",
			"sounds/enemies/dlc2/giant_spider_idle_03.wav"
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
		this.m.IsHidden = true;
		this.m.ActionPointCost = ::Lewd.Const.SpiderInjectAP;
		this.m.FatigueCost = ::Lewd.Const.SpiderInjectFatigue;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	// Hidden skills are blocked by base isUsable -- bypass for AI-only skill
	function isUsable()
	{
		if (!this.m.IsUsable) return false;
		if (!this.getContainer().getActor().getCurrentProperties().IsAbleToUseSkills) return false;
		return true;
	}

	function isAffordable()
	{
		local actor = this.getContainer().getActor();
		return actor.getActionPoints() >= this.m.ActionPointCost;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsOccupiedByActor) return false;

		local target = _targetTile.getEntity();
		local user = _originTile.IsOccupiedByActor ? _originTile.getEntity() : null;

		// Target must be female with PleasureMax
		if (target.getGender() != 1) return false;
		if (target.getPleasureMax() <= 0) return false;

		// Target must not be allied
		if (user != null && user.isAlliedWith(target)) return false;

		// Target must be rooted (webbed)
		if (!target.getCurrentProperties().IsRooted) return false;

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;

		if (_targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " injects into " + this.Const.UI.getColorizedEntityName(target));
		}

		// Play multi-shake animation mimicking vaginal penetration
		this.playInjectAnimation(_user, _targetTile);

		// Schedule effect application after animation completes
		local tag = {
			User = _user,
			Target = target
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 2000, this.onApplyEffect.bindenv(this), tag);
		return true;
	}

	function playInjectAnimation( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (_user.isHiddenToPlayer() && target.isHiddenToPlayer()) return;

		local userTile = _user.getTile();
		local dir = userTile.getDirectionTo(_targetTile);
		local beyondTile = _targetTile.hasNextTile(dir) ? _targetTile.getNextTile(dir) : _targetTile;

		local webSounds = [
			"sounds/enemies/dlc2/giant_spider_shoot_net_hit_01.wav",
			"sounds/enemies/dlc2/giant_spider_shoot_net_hit_02.wav",
			"sounds/enemies/dlc2/giant_spider_shoot_net_hit_03.wav"
		];

		// 4 shakes at 500ms intervals -- spider thrusts toward target, target pushed away
		for (local i = 0; i < 4; i++)
		{
			local delay = i * 500;
			local isLast = i == 3;
			local uInt = isLast ? 4 : 3;
			local tInt = isLast ? 6 : 5;
			local webSound = webSounds[this.Math.rand(0, webSounds.len() - 1)];
			local moanSound = i == 0
				? ::Lewd.Const.SoundIntenseMoans[this.Math.rand(0, ::Lewd.Const.SoundIntenseMoans.len() - 1)]
				: null;

			this.Time.scheduleEvent(this.TimeUnit.Virtual, delay,
				function(_d) {
					if (_d.User.isAlive())
					{
						this.Tactical.getShaker().cancel(_d.User);
						this.Tactical.getShaker().shake(_d.User, _d.TargetTile, _d.UInt);
						this.Sound.play(_d.WebSound, this.Const.Sound.Volume.Skill, _d.User.getPos());
					}
					if (_d.Target.isAlive())
					{
						this.Tactical.getShaker().cancel(_d.Target);
						this.Tactical.getShaker().shake(_d.Target, _d.BeyondTile, _d.TInt);
						if (_d.MoanSound != null)
							this.Sound.play(_d.MoanSound, this.Const.Sound.Volume.Skill, _d.Target.getPos());
					}
				}.bindenv(this),
				{ User = _user, Target = target, TargetTile = _targetTile, BeyondTile = beyondTile, UInt = uInt, TInt = tInt, WebSound = webSound, MoanSound = moanSound });
		}

		this.Tactical.getCamera().quake(_user, target, 2.0, 0.1, 0.2);
	}

	function onApplyEffect( _tag )
	{
		local user = _tag.User;
		local target = _tag.Target;

		if (!target.isAlive()) return;

		// Add egg injury -- each climax while carrying adds +1 stack via onOwnerClimax
		if (!target.getSkills().hasSkill("effects.spider_eggs"))
			target.getSkills().add(this.new("scripts/skills/effects/spider_eggs_effect"));

		// Apply pleasure to push target toward climax
		local pleasure = ::Lewd.Const.SpiderInjectPleasure;
		target.addPleasure(pleasure, user);
		::logInfo("[spider_inject] " + user.getName() + " injected " + target.getName() + " (+" + pleasure + " pleasure)");

		// Apply horny to target if not already horny
		if (!target.getSkills().hasSkill("effects.lewd_horny"))
			target.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
	}
});
