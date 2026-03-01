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

	function getContinuationSkill( _entity, _target )
	{
		// Check what entity last did to target
		local flagKey = "lewdCont_" + _target.getID();
		local sexType = null;
		if (_entity.getFlags().has(flagKey))
			sexType = _entity.getFlags().get(flagKey);

		// Also check what target last did to entity (respond in kind)
		if (sexType == null)
		{
			local reverseKey = "lewdCont_" + _entity.getID();
			if (_target.getFlags().has(reverseKey))
				sexType = _target.getFlags().get(reverseKey);
		}

		if (sexType == null) return null;
		if (!(sexType in ::Lewd.Const.AIContinuationMap)) return null;

		local skillID = ::Lewd.Const.AIContinuationMap[sexType];
		return _entity.getSkills().getSkillByID(skillID);
	}

	function pickRandomPenetrate( _entity, _targetTile )
	{
		local penVag = _entity.getSkills().getSkillByID("actives.male_penetrate_vaginal");
		local penAnal = _entity.getSkills().getSkillByID("actives.male_penetrate_anal");
		local vagUsable = penVag != null && this.canUseSkill(_entity, penVag, _targetTile);
		local analUsable = penAnal != null && this.canUseSkill(_entity, penAnal, _targetTile);

		if (vagUsable && analUsable)
			return this.Math.rand(0, 1) == 0 ? penVag : penAnal;
		if (vagUsable) return penVag;
		if (analUsable) return penAnal;
		return null;
	}

	function findBestSkill( _entity, _target, _targetTile )
	{
		local forceOral = _entity.getSkills().getSkillByID("actives.male_force_oral");
		local grope = _entity.getSkills().getSkillByID("actives.male_grope");

		// 1. Check continuation memory
		local contSkill = this.getContinuationSkill(_entity, _target);
		if (contSkill != null && this.canUseSkill(_entity, contSkill, _targetTile))
		{
			if (this.Math.rand(1, 100) <= ::Lewd.Const.AIContinuationChance)
				return contSkill;
		}

		local userMounting = _entity.getSkills().hasSkill("effects.lewd_mounting");
		local targetMounted = _target.getSkills().hasSkill("effects.lewd_mounted");

		// 2. If already mounting THIS target: random penetrate
		if (userMounting)
		{
			local mountingEffect = _entity.getSkills().getSkillByID("effects.lewd_mounting");
			if (mountingEffect.getTargetID() == _target.getID())
			{
				local pen = this.pickRandomPenetrate(_entity, _targetTile);
				if (pen != null) return pen;
			}
		}

		// 3. If target is mounted (by anyone): force oral
		if (targetMounted && forceOral != null && this.canUseSkill(_entity, forceOral, _targetTile))
			return forceOral;

		// 4. Penetrate to establish mount
		local pen = this.pickRandomPenetrate(_entity, _targetTile);
		if (pen != null) return pen;

		// 5. Fallback: grope
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
