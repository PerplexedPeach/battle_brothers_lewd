// AI behavior for horny orcs -- orc-specific sex skill selection
// Differs from generic ai_horny:
// - If orc has an active claim, exclusively targets that claimed victim
// - Skips targets claimed by other orcs
// - Defers to ai_orc_claim if orc has no claim and unclaimed target is adjacent
this.ai_orc_horny <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		SelectedSkill = null,
		GaveUp = false
	},
	function create()
	{
		this.m.ID = ::Lewd.Const.AIBehaviorIDOrcHorny;
		this.m.Order = this.Const.AI.Behavior.Order.AttackDefault;
		this.behavior.create();
	}

	function onTurnStarted()
	{
		this.m.GaveUp = false;
	}

	function onEvaluate( _entity )
	{
		if (this.m.GaveUp)
			return 0;

		if (!_entity.getSkills().hasSkill("effects.lewd_horny"))
			return 0;

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
			return 0;

		if (_entity.getActionPoints() < ::Lewd.Const.MaleGropeAP)
			return 0;

		::logInfo("[ai_orc_horny] " + _entity.getName() + " evaluating (AP:" + _entity.getActionPoints() + ")");

		// Check if orc has an active claim
		local claimedTargetID = -1;
		if (_entity.getFlags().has("lewdOrcClaimTarget"))
			claimedTargetID = _entity.getFlags().getAsInt("lewdOrcClaimTarget");

		local hasActiveClaim = false;
		local claimedTarget = null;
		if (claimedTargetID >= 0)
		{
			claimedTarget = this.Tactical.getEntityByID(claimedTargetID);
			if (claimedTarget != null && claimedTarget.isAlive())
				hasActiveClaim = true;
			else
				_entity.getFlags().set("lewdOrcClaimTarget", -1); // clear stale
		}

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
			if (target == null || !target.isAlive()) continue;
			if (_entity.isAlliedWith(target)) continue;
			if (target.getGender() != 1) continue;
			if (target.getPleasureMax() <= 0) continue;

			// If orc has an active claim, ONLY target the claimed victim
			if (hasActiveClaim && target.getID() != claimedTargetID)
			{
				::logInfo("[ai_orc_horny]   adj: " + target.getName() + " -- not our claim, skip");
				continue;
			}

			// Skip targets claimed by other orcs
			if (target.getSkills().hasSkill("effects.orc_claimed"))
			{
				local claimedEffect = target.getSkills().getSkillByID("effects.orc_claimed");
				if (claimedEffect.getClaimerID() != _entity.getID())
				{
					::logInfo("[ai_orc_horny]   adj: " + target.getName() + " -- claimed by another orc, skip");
					continue;
				}
			}

			// If orc has NO claim and target is unclaimed, defer to ai_orc_claim
			if (!hasActiveClaim && !target.getSkills().hasSkill("effects.orc_claimed"))
			{
				local claimSkill = _entity.getSkills().getSkillByID("actives.orc_claim");
				if (claimSkill != null && claimSkill.isUsable() && claimSkill.onVerifyTarget(myTile, tile))
				{
					::logInfo("[ai_orc_horny]   adj: " + target.getName() + " -- unclaimed, deferring to ai_orc_claim");
					return 0;
				}
			}

			local targetScore = 1.0;

			// Prefer targets close to climax
			targetScore += target.getPleasurePct() * 0.5;

			// Prefer targets already mounted (more skills available)
			if (target.getSkills().hasSkill("effects.lewd_mounted"))
				targetScore += 0.5;

			// Prefer targets we're mounting (continue what we started)
			if (_entity.getSkills().hasSkill("effects.lewd_mounting"))
			{
				local mountingEffect = _entity.getSkills().getSkillByID("effects.lewd_mounting");
				if (mountingEffect.getTargetID() == target.getID())
					targetScore += 1.0;
			}

			// Prefer horny targets (auto-hit)
			if (target.getSkills().hasSkill("effects.lewd_horny"))
				targetScore += 0.3;

			// Willing Victim / Open Invitation bonuses
			if (target.getSkills().hasSkill("perk.lewd_willing_victim"))
				targetScore += ::Lewd.Const.WillingVictimAIPriority;
			if (target.getSkills().hasSkill("effects.open_invitation"))
				targetScore += ::Lewd.Const.OpenInvitationAIPriority;

			// Find best skill for this target
			local skill = this.findBestSkill(_entity, target, tile);
			if (skill == null)
			{
				::logInfo("[ai_orc_horny]   target " + target.getName() + " -- no usable skill");
				continue;
			}

			::logInfo("[ai_orc_horny]   target " + target.getName() + " -- score:" + targetScore + " skill:" + skill.getID());

			if (targetScore > bestScore)
			{
				bestScore = targetScore;
				bestTile = tile;
				bestSkill = skill;
			}
		}

		if (bestTile == null || bestSkill == null)
		{
			::logInfo("[ai_orc_horny] " + _entity.getName() + " -- no valid target this eval");
			return 0;
		}

		local finalScore = ::Lewd.Const.OrcHornyAIScore * bestScore * this.getProperties().BehaviorMult[this.m.ID];
		::logInfo("[ai_orc_horny] " + _entity.getName() + " -- SELECTED " + bestSkill.getID() + " on " + bestTile.getEntity().getName() + " (score:" + finalScore + ")");
		this.m.TargetTile = bestTile;
		this.m.SelectedSkill = bestSkill;
		return finalScore;
	}

	function findBestSkill( _entity, _target, _targetTile )
	{
		local forceOral = _entity.getSkills().getSkillByID("actives.male_force_oral");
		local grope = _entity.getSkills().getSkillByID("actives.male_grope");

		// 1. Check continuation memory
		local contSkill = this.getContinuationSkill(_entity, _target);
		if (contSkill != null && this.canUseSkill(_entity, contSkill, _targetTile))
		{
			local roll = this.Math.rand(1, 100);
			if (roll <= ::Lewd.Const.AIContinuationChance)
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

		// 3. Surrender to Pleasure: prioritize penetration
		if (_target.getSkills().hasSkill("effects.surrender_to_pleasure"))
		{
			local pen = this.pickRandomPenetrate(_entity, _targetTile);
			if (pen != null) return pen;
		}

		// 4. If target is mounted: randomly pick oral or penetrate
		if (targetMounted)
		{
			local oralUsable = forceOral != null && this.canUseSkill(_entity, forceOral, _targetTile);
			local pen = this.pickRandomPenetrate(_entity, _targetTile);

			if (oralUsable && pen != null)
				return this.Math.rand(1, 100) <= 80 ? forceOral : pen;
			if (oralUsable) return forceOral;
			if (pen != null) return pen;
		}

		// 5. Penetrate to establish mount
		local pen = this.pickRandomPenetrate(_entity, _targetTile);
		if (pen != null) return pen;

		// 6. Fallback: grope
		if (grope != null && this.canUseSkill(_entity, grope, _targetTile))
			return grope;

		return null;
	}

	function getContinuationSkill( _entity, _target )
	{
		local flagKey = "lewdCont_" + _target.getID();
		local sexType = null;
		if (_entity.getFlags().has(flagKey))
			sexType = _entity.getFlags().get(flagKey);

		if (sexType == null)
		{
			local reverseKey = "lewdCont_" + _entity.getID();
			if (_target.getFlags().has(reverseKey))
				sexType = _target.getFlags().get(reverseKey);
		}

		if (sexType == null) return null;
		if (!(sexType in ::Lewd.Const.AIContinuationMap)) return null;

		return _entity.getSkills().getSkillByID(::Lewd.Const.AIContinuationMap[sexType]);
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

	function canUseSkill( _entity, _skill, _targetTile )
	{
		if (!_skill.isUsable()) return false;
		if (_entity.getActionPoints() < _skill.getActionPointCost()) return false;
		if (_entity.getFatigue() + _skill.getFatigueCost() > _entity.getFatigueMax()) return false;
		if (!_skill.onVerifyTarget(_entity.getTile(), _targetTile)) return false;
		return true;
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			this.m.IsFirstExecuted = false;
			if (this.m.TargetTile != null)
				this.getAgent().adjustCameraToTarget(this.m.TargetTile);
			return false;
		}

		local apBefore = _entity.getActionPoints();
		if (this.m.SelectedSkill != null && this.m.TargetTile != null && this.m.TargetTile.IsOccupiedByActor)
		{
			::logInfo("[ai_orc_horny] " + _entity.getName() + " EXECUTING " + this.m.SelectedSkill.getID() + " on " + this.m.TargetTile.getEntity().getName());
			this.m.SelectedSkill.use(this.m.TargetTile);

			if (_entity.isAlive())
			{
				this.getAgent().declareAction();

				if (this.m.SelectedSkill.getDelay() != 0)
					this.getAgent().declareEvaluationDelay(this.m.SelectedSkill.getDelay());
			}
		}

		if (_entity.isAlive() && _entity.getActionPoints() >= apBefore)
		{
			::logInfo("[ai_orc_horny] " + _entity.getName() + " skill did not consume AP, giving up");
			this.m.GaveUp = true;
		}

		this.m.TargetTile = null;
		this.m.SelectedSkill = null;
		return true;
	}
});
