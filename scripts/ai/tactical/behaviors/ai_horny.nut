// AI behavior for horny entities — evaluates and uses male sex skills
// Injected into enemy agents when they gain the Horny effect
// Behavior ID registered via Const.AI.Behavior.ID.COUNT in mod_lewd.nut
this.ai_horny <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		SelectedSkill = null,
		GaveUp = false
	},
	function create()
	{
		this.m.ID = ::Lewd.Const.AIBehaviorIDHorny;
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

		// Must have Horny effect
		if (!_entity.getSkills().hasSkill("effects.lewd_horny"))
			return 0;

		// Don't use sex skills while fleeing
		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
			return 0;

		// Must have enough AP for cheapest skill (grope = 3 AP)
		if (_entity.getActionPoints() < ::Lewd.Const.MaleGropeAP)
		{
			::logInfo("[ai_horny] " + _entity.getName() + " has insufficient AP (" + _entity.getActionPoints() + "), skipping");
			return 0;
		}

		::logInfo("[ai_horny] " + _entity.getName() + " evaluating (AP:" + _entity.getActionPoints() + " Fat:" + _entity.getFatigue() + "/" + _entity.getFatigueMax() + ")");

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

			// Willing Victim: target invites attention, high priority
			if (target.getSkills().hasSkill("perk.lewd_willing_victim"))
				targetScore += ::Lewd.Const.WillingVictimAIPriority;

			// Open Invitation: target is begging for it, massive priority
			if (target.getSkills().hasSkill("effects.open_invitation"))
				targetScore += ::Lewd.Const.OpenInvitationAIPriority;

			// Find best available skill for this target
			local skill = this.findBestSkill(_entity, target, tile);
			if (skill == null)
			{
				::logInfo("[ai_horny]   target " + target.getName() + " — no usable skill found");
				continue;
			}

			::logInfo("[ai_horny]   target " + target.getName() + " — score:" + targetScore + " skill:" + skill.getID());

			if (targetScore > bestScore)
			{
				bestScore = targetScore;
				bestTile = tile;
				bestSkill = skill;
			}
		}

		if (bestTile == null || bestSkill == null)
		{
			::logInfo("[ai_horny] " + _entity.getName() + " — no valid target found, giving up this turn");
			this.m.GaveUp = true;
			return 0;
		}

		local finalScore = ::Lewd.Const.HornyAIScore * bestScore * this.getProperties().BehaviorMult[this.m.ID];
		::logInfo("[ai_horny] " + _entity.getName() + " — SELECTED " + bestSkill.getID() + " on " + bestTile.getEntity().getName() + " (score:" + finalScore + ")");
		this.m.TargetTile = bestTile;
		this.m.SelectedSkill = bestSkill;
		return finalScore;
	}

	function getContinuationSkill( _entity, _target )
	{
		// Check what entity last did to target
		local flagKey = "lewdCont_" + _target.getID();
		local sexType = null;
		local source = "";
		if (_entity.getFlags().has(flagKey))
		{
			sexType = _entity.getFlags().get(flagKey);
			source = "entity->target";
		}

		// Also check what target last did to entity (respond in kind)
		if (sexType == null)
		{
			local reverseKey = "lewdCont_" + _entity.getID();
			if (_target.getFlags().has(reverseKey))
			{
				sexType = _target.getFlags().get(reverseKey);
				source = "target->entity";
			}
		}

		if (sexType == null) return null;

		if (!(sexType in ::Lewd.Const.AIContinuationMap))
		{
			::logInfo("[ai_horny]   continuation: sexType '" + sexType + "' has no mapping (" + source + ")");
			return null;
		}

		local skillID = ::Lewd.Const.AIContinuationMap[sexType];
		::logInfo("[ai_horny]   continuation: sexType '" + sexType + "' -> " + skillID + " (" + source + ")");
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
			local roll = this.Math.rand(1, 100);
			if (roll <= ::Lewd.Const.AIContinuationChance)
			{
				::logInfo("[ai_horny]   findBestSkill: continuation hit (roll:" + roll + " <= " + ::Lewd.Const.AIContinuationChance + ") -> " + contSkill.getID());
				return contSkill;
			}
			::logInfo("[ai_horny]   findBestSkill: continuation miss (roll:" + roll + " > " + ::Lewd.Const.AIContinuationChance + "), falling through");
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
				if (pen != null)
				{
					::logInfo("[ai_horny]   findBestSkill: mounting target, random penetrate -> " + pen.getID());
					return pen;
				}
			}
		}

		// 3. Surrender to Pleasure: target has given in — prioritize penetration for max self-pleasure
		local targetSurrendered = _target.getSkills().hasSkill("effects.surrender_to_pleasure");
		if (targetSurrendered)
		{
			local pen = this.pickRandomPenetrate(_entity, _targetTile);
			if (pen != null)
			{
				::logInfo("[ai_horny]   findBestSkill: target surrendered, prioritize penetrate -> " + pen.getID());
				return pen;
			}
		}

		// 4. If target is mounted (by anyone): randomly pick oral or penetrate
		if (targetMounted)
		{
			local oralUsable = forceOral != null && this.canUseSkill(_entity, forceOral, _targetTile);
			local pen = this.pickRandomPenetrate(_entity, _targetTile);

			if (oralUsable && pen != null)
			{
				local pick = this.Math.rand(1, 100) <= 80 ? forceOral : pen;
				::logInfo("[ai_horny]   findBestSkill: target mounted, random pick -> " + pick.getID());
				return pick;
			}
			if (oralUsable)
			{
				::logInfo("[ai_horny]   findBestSkill: target mounted -> force oral");
				return forceOral;
			}
			if (pen != null)
			{
				::logInfo("[ai_horny]   findBestSkill: target mounted -> penetrate");
				return pen;
			}
		}

		// 5. Penetrate to establish mount
		local pen = this.pickRandomPenetrate(_entity, _targetTile);
		if (pen != null)
		{
			::logInfo("[ai_horny]   findBestSkill: establish mount -> " + pen.getID());
			return pen;
		}

		// 6. Fallback: grope
		if (grope != null && this.canUseSkill(_entity, grope, _targetTile))
		{
			::logInfo("[ai_horny]   findBestSkill: fallback -> grope");
			return grope;
		}

		::logInfo("[ai_horny]   findBestSkill: no usable skill");
		return null;
	}

	function canUseSkill( _entity, _skill, _targetTile )
	{
		if (!_skill.isUsable())
			return false;
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
		local apBefore = _entity.getActionPoints();
		if (this.m.SelectedSkill != null && this.m.TargetTile != null && this.m.TargetTile.IsOccupiedByActor)
		{
			::logInfo("[ai_horny] " + _entity.getName() + " EXECUTING " + this.m.SelectedSkill.getID() + " on " + this.m.TargetTile.getEntity().getName());
			this.m.SelectedSkill.use(this.m.TargetTile);

			if (_entity.isAlive())
			{
				this.getAgent().declareAction();

				if (this.m.SelectedSkill.getDelay() != 0)
					this.getAgent().declareEvaluationDelay(this.m.SelectedSkill.getDelay());
			}
		}

		// If skill failed to consume AP, give up to prevent infinite re-evaluation
		if (_entity.isAlive() && _entity.getActionPoints() >= apBefore)
		{
			::logInfo("[ai_horny] " + _entity.getName() + " skill did not consume AP, giving up");
			this.m.GaveUp = true;
		}

		this.m.TargetTile = null;
		this.m.SelectedSkill = null;
		return true;
	}
});
