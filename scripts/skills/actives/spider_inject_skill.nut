// Spider Inject: spider oviposits into a rooted (webbed) target.
// Applies significant pleasure. Egg is deposited when the TARGET climaxes
// (tracked via lewdSpiderInjected flag, checked by climax_effect).
// Requires target to be rooted (from web or other source).
this.spider_inject_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.spider_inject";
		this.m.Name = "Oviposit";
		this.m.Description = "Inject eggs into a helpless, immobilized prey.";
		this.m.Icon = "skills/active_110.png";
		this.m.IconDisabled = "skills/active_110.png";
		this.m.Overlay = "";
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

		// Schedule the actual effect application
		local tag = {
			Skill = this,
			User = _user,
			Target = target,
			TargetTile = _targetTile
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 400, this.onApplyEffect.bindenv(this), tag);
		return true;
	}

	function onApplyEffect( _tag )
	{
		local user = _tag.User;
		local target = _tag.Target;

		if (!target.isAlive()) return;

		// Shake visuals
		if (_tag.TargetTile.IsVisibleForPlayer)
		{
			local shakeDir = target.getTile().getDirectionTo(user.getTile());
			this.Tactical.getShaker().shake(target, _tag.TargetTile, 2, shakeDir, 400);
		}

		// Flag target as spider-injected: climax_effect will deposit egg on climax
		target.getFlags().set("lewdSpiderInjected", true);

		// Apply significant pleasure to target
		local pleasure = ::Lewd.Const.SpiderInjectPleasure;
		target.addPleasure(pleasure, user);
		::logInfo("[spider_inject] " + user.getName() + " injected " + target.getName() + " (+" + pleasure + " pleasure)");

		// Apply horny to target if not already horny
		if (!target.getSkills().hasSkill("effects.lewd_horny"))
			target.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
	}
});
