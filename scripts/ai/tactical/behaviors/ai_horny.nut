// AI behavior for horny entities — evaluates and uses male sex skills
// Injected into enemy agents when they gain the Horny effect
// Behavior ID registered via Const.AI.Behavior.ID.COUNT in mod_lewd.nut
this.ai_horny <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		SelectedSkill = null
	},
	function create()
	{
		this.behavior.create();
		this.m.ID = ::Lewd.Const.AIBehaviorIDHorny;
		this.m.Order = this.Const.AI.Behavior.Order.AttackDefault;
	}

	function onEvaluate( _entity )
	{
		// Must have Horny effect
		if (!_entity.getSkills().hasSkill("effects.lewd_horny"))
			return 0;

		// Must have enough AP for cheapest skill (grope = 3 AP)
		if (_entity.getActionPoints() < ::Lewd.Const.MaleGropeAP)
			return 0;

		// Find adjacent female targets with PleasureMax > 0
		local myTile = _entity.getTile();
		local bestScore = 0.0;
		local bestTile = null;
		local bestSkill = null;

		for (local i = 0; i < 6; i++)
		{
			if (!myTile.hasNextTile(i)) continue;
			local tile = myTile.getNextTile(i);
			if (!tile.IsOccupiedByActor) continue;
			local target = tile.getEntity();
			if (target == null) continue;
			if (!target.isAlive()) continue;
			if (_entity.isAlliedWith(target)) continue;
			if (target.getGender() != 1) continue;
			if (target.getPleasureMax() <= 0) continue;

			// Score this target
			local targetScore = 1.0;

			// Prefer targets close to climax (finish them off)
			targetScore += target.getPleasurePct() * 0.5;

			// Prefer targets already mounted (more skills available, vulnerable)
			if (target.getSkills().hasSkill("effects.lewd_mounted"))
				targetScore += 0.5;

			// Prefer targets we're already mounting (continue what we started)
			if (_entity.getSkills().hasSkill("effects.lewd_mounting"))
			{
				local mountingEffect = _entity.getSkills().getSkillByID("effects.lewd_mounting");
				if (mountingEffect.getTargetID() == target.getID())
					targetScore += 1.0;
			}

			// Prefer horny targets (auto-hit from base class)
			if (target.getSkills().hasSkill("effects.lewd_horny"))
				targetScore += 0.3;

			// Find best available skill for this target
			local skill = this.findBestSkill(_entity, target, tile);
			if (skill == null) continue;

			if (targetScore > bestScore)
			{
				bestScore = targetScore;
				bestTile = tile;
				bestSkill = skill;
			}
		}

		if (bestTile == null || bestSkill == null)
			return 0;

		this.m.TargetTile = bestTile;
		this.m.SelectedSkill = bestSkill;
		return ::Lewd.Const.HornyAIScore * bestScore;
	}

	function findBestSkill( _entity, _target, _targetTile )
	{
		local penetrate = _entity.getSkills().getSkillByID("actives.male_penetrate");
		local forceOral = _entity.getSkills().getSkillByID("actives.male_force_oral");
		local grope = _entity.getSkills().getSkillByID("actives.male_grope");

		local targetMounted = _target.getSkills().hasSkill("effects.lewd_mounted");
		local userMounting = _entity.getSkills().hasSkill("effects.lewd_mounting");

		// If already mounting this target, prefer penetrate (refresh mount + bonus pleasure)
		if (userMounting && penetrate != null && this.canUseSkill(_entity, penetrate, _targetTile))
		{
			local mountingEffect = _entity.getSkills().getSkillByID("effects.lewd_mounting");
			if (mountingEffect.getTargetID() == _target.getID())
				return penetrate;
		}

		// If target is mounted (by anyone), force oral is very effective
		if (targetMounted && forceOral != null && this.canUseSkill(_entity, forceOral, _targetTile))
			return forceOral;

		// Penetrate to establish mount (high value even if not yet mounted)
		if (penetrate != null && this.canUseSkill(_entity, penetrate, _targetTile))
			return penetrate;

		// Fallback: grope (cheapest, always works)
		if (grope != null && this.canUseSkill(_entity, grope, _targetTile))
			return grope;

		return null;
	}

	function canUseSkill( _entity, _skill, _targetTile )
	{
		if (_entity.getActionPoints() < _skill.getActionPointCost())
			return false;
		if (_entity.getFatigue() + _skill.getFatigueCost() > _entity.getFatigueMax())
			return false;
		if (!_skill.onVerifyTarget(_entity.getTile(), _targetTile))
			return false;
		return true;
	}

	function onExecute( _entity )
	{
		// First frame: adjust camera to target
		if (this.m.IsFirstExecuted)
		{
			this.m.IsFirstExecuted = false;
			if (this.m.TargetTile != null)
				this.getAgent().adjustCameraToTarget(this.m.TargetTile);
			return false;
		}

		// Second frame: use skill
		if (this.m.SelectedSkill != null && this.m.TargetTile != null)
		{
			this.m.SelectedSkill.use(this.m.TargetTile);
		}
		this.m.TargetTile = null;
		this.m.SelectedSkill = null;
		return true;
	}
});
