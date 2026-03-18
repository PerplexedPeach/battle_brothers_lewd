// AI behavior for horny goblins — goblin-specific sex skill selection
// Differs from generic ai_horny:
// - Prioritizes restrained targets above all others
// - Among non-restrained targets, prefers those surrounded by more goblins
// - Rooted/restrained targets: weighted random penetrate (vaginal 50%, anal 30%, oral 20%)
// - Non-restrained targets: grope only
// - Fallback: grope if AP too low for penetration
this.ai_goblin_horny <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		SelectedSkill = null,
		GaveUp = false
	},
	function create()
	{
		this.m.ID = ::Lewd.Const.AIBehaviorIDGoblinHorny;
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

		::logInfo("[ai_goblin_horny] " + _entity.getName() + " evaluating (AP:" + _entity.getActionPoints() + ")");

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
			if (_entity.isAlliedWith(target))
			{
				::logInfo("[ai_goblin_horny]   adj: " + target.getName() + " -- ALLIED, skip");
				continue;
			}
			if (target.getGender() != 1)
			{
				::logInfo("[ai_goblin_horny]   adj: " + target.getName() + " -- gender:" + target.getGender() + ", skip");
				continue;
			}
			if (target.getPleasureMax() <= 0)
			{
				::logInfo("[ai_goblin_horny]   adj: " + target.getName() + " -- pleasureMax:" + target.getPleasureMax() + ", skip");
				continue;
			}

			local targetScore = 1.0;
			local isRooted = target.getCurrentProperties().IsRooted;

			// Highest priority: restrained targets
			if (target.getSkills().hasSkill("effects.lewd_restrained"))
				targetScore += 5.0;
			else if (isRooted)
				targetScore += 3.0;

			// Count adjacent goblins (excluding self) -- prefer swarmed targets
			local adjGoblins = this.countAdjacentGoblins(_entity, target);
			targetScore += adjGoblins * 0.5;

			// Prefer targets close to climax
			targetScore += target.getPleasurePct() * 0.5;

			// Willing Victim / Open Invitation bonuses
			if (target.getSkills().hasSkill("perk.lewd_willing_victim"))
				targetScore += ::Lewd.Const.WillingVictimAIPriority;
			if (target.getSkills().hasSkill("effects.open_invitation"))
				targetScore += ::Lewd.Const.OpenInvitationAIPriority;

			// Find best skill for this target
			local skill = this.findBestSkill(_entity, target, tile);
			if (skill == null)
			{
				::logInfo("[ai_goblin_horny]   target " + target.getName() + " -- no usable skill");
				continue;
			}

			::logInfo("[ai_goblin_horny]   target " + target.getName() + " -- score:" + targetScore + " rooted:" + isRooted + " adjGoblins:" + adjGoblins + " skill:" + skill.getID());

			if (targetScore > bestScore)
			{
				bestScore = targetScore;
				bestTile = tile;
				bestSkill = skill;
			}
		}

		if (bestTile == null || bestSkill == null)
		{
			::logInfo("[ai_goblin_horny] " + _entity.getName() + " -- no valid target, giving up");
			this.m.GaveUp = true;
			return 0;
		}

		local finalScore = ::Lewd.Const.GoblinHornyAIScore * bestScore * this.getProperties().BehaviorMult[this.m.ID];
		::logInfo("[ai_goblin_horny] " + _entity.getName() + " -- SELECTED " + bestSkill.getID() + " on " + bestTile.getEntity().getName() + " (score:" + finalScore + ")");
		this.m.TargetTile = bestTile;
		this.m.SelectedSkill = bestSkill;
		return finalScore;
	}

	function countAdjacentGoblins( _self, _target )
	{
		local targetTile = _target.getTile();
		local count = 0;
		for (local i = 0; i < 6; i++)
		{
			if (!targetTile.hasNextTile(i)) continue;
			local tile = targetTile.getNextTile(i);
			if (!tile.IsOccupiedByActor) continue;
			local adj = tile.getEntity();
			if (adj == null || !adj.isAlive()) continue;
			if (adj.getID() == _self.getID()) continue;
			if (!::Lewd.Mastery.isGoblin(adj)) continue;
			count++;
		}
		return count;
	}

	function findBestSkill( _entity, _target, _targetTile )
	{
		local isRooted = _target.getCurrentProperties().IsRooted;

		if (isRooted)
		{
			// Rooted/restrained: weighted random among penetrate vaginal, anal, force oral
			local skill = this.pickWeightedPenetrate(_entity, _targetTile);
			if (skill != null) return skill;
		}

		// Non-rooted or fallback: grope
		local grope = _entity.getSkills().getSkillByID("actives.male_grope");
		if (grope != null && this.canUseSkill(_entity, grope, _targetTile))
			return grope;

		return null;
	}

	function pickWeightedPenetrate( _entity, _targetTile )
	{
		// Build weighted list of usable penetration skills
		local candidates = [];
		local totalWeight = 0;

		local penVag = _entity.getSkills().getSkillByID("actives.male_penetrate_vaginal");
		if (penVag != null && this.canUseSkill(_entity, penVag, _targetTile))
		{
			candidates.push({ skill = penVag, weight = ::Lewd.Const.GoblinPenetrateWeightVaginal });
			totalWeight += ::Lewd.Const.GoblinPenetrateWeightVaginal;
		}

		local penAnal = _entity.getSkills().getSkillByID("actives.male_penetrate_anal");
		if (penAnal != null && this.canUseSkill(_entity, penAnal, _targetTile))
		{
			candidates.push({ skill = penAnal, weight = ::Lewd.Const.GoblinPenetrateWeightAnal });
			totalWeight += ::Lewd.Const.GoblinPenetrateWeightAnal;
		}

		local forceOral = _entity.getSkills().getSkillByID("actives.male_force_oral");
		if (forceOral != null && this.canUseSkill(_entity, forceOral, _targetTile))
		{
			candidates.push({ skill = forceOral, weight = ::Lewd.Const.GoblinPenetrateWeightOral });
			totalWeight += ::Lewd.Const.GoblinPenetrateWeightOral;
		}

		if (candidates.len() == 0) return null;

		local roll = this.Math.rand(1, totalWeight);
		local cumulative = 0;
		foreach (c in candidates)
		{
			cumulative += c.weight;
			if (roll <= cumulative)
				return c.skill;
		}

		return candidates.top().skill;
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
			// Ensure gang-up effect is on target before dealing pleasure
			local target = this.m.TargetTile.getEntity();
			if (target != null && !target.getSkills().hasSkill("effects.goblin_gang_up"))
				target.getSkills().add(this.new("scripts/skills/effects/goblin_gang_up_effect"));

			::logInfo("[ai_goblin_horny] " + _entity.getName() + " EXECUTING " + this.m.SelectedSkill.getID() + " on " + target.getName());
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
			::logInfo("[ai_goblin_horny] " + _entity.getName() + " skill did not consume AP, giving up");
			this.m.GaveUp = true;
		}

		this.m.TargetTile = null;
		this.m.SelectedSkill = null;
		return true;
	}
});
