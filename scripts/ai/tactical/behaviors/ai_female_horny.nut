// AI behavior for female enemies using sex skills against male targets
// Targets adjacent males with PleasureMax > 0, uses hands_skill and oral_skill
this.ai_female_horny <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		SelectedSkill = null,
		GaveUp = false
	},
	function create()
	{
		this.m.ID = ::Lewd.Const.AIBehaviorIDFemaleHorny;
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

		// Must have at least one usable sex skill
		local hands = _entity.getSkills().getSkillByID("actives.lewd_hands");
		local oral = _entity.getSkills().getSkillByID("actives.lewd_oral");
		if (hands == null && oral == null)
			return 0;

		// Must have enough AP for cheapest skill
		if (_entity.getActionPoints() < 3)
			return 0;

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
			if (target.getGender() == 1) continue; // skip females
			if (target.getPleasureMax() <= 0) continue;

			local targetScore = 1.0;

			// Prefer targets close to climax
			targetScore += target.getPleasurePct() * 0.5;

			// Prefer horny targets
			if (target.getSkills().hasSkill("effects.lewd_horny"))
				targetScore += 0.3;

			// Willing Victim
			if (target.getSkills().hasSkill("perk.lewd_willing_victim"))
				targetScore += ::Lewd.Const.WillingVictimAIPriority;

			// Open Invitation
			if (target.getSkills().hasSkill("effects.open_invitation"))
				targetScore += ::Lewd.Const.OpenInvitationAIPriority;

			// Find best skill for this target
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

		local finalScore = ::Lewd.Const.HornyAIScore * bestScore * this.getProperties().BehaviorMult[this.m.ID];
		this.m.TargetTile = bestTile;
		this.m.SelectedSkill = bestSkill;
		return finalScore;
	}

	function findBestSkill( _entity, _target, _targetTile )
	{
		local hands = _entity.getSkills().getSkillByID("actives.lewd_hands");
		local oral = _entity.getSkills().getSkillByID("actives.lewd_oral");
		local vaginal = _entity.getSkills().getSkillByID("actives.lewd_vaginal");

		// If already mounting this target, prefer vaginal
		if (_entity.getSkills().hasSkill("effects.lewd_mounting"))
		{
			local mountingEffect = _entity.getSkills().getSkillByID("effects.lewd_mounting");
			if (mountingEffect.getTargetID() == _target.getID())
			{
				if (vaginal != null && this.canUseSkill(_entity, vaginal, _targetTile))
					return vaginal;
			}
		}

		// If target is mounted, prefer oral or vaginal
		if (_target.getSkills().hasSkill("effects.lewd_mounted"))
		{
			local mounted = [];
			if (oral != null && this.canUseSkill(_entity, oral, _targetTile))
				mounted.push(oral);
			if (vaginal != null && this.canUseSkill(_entity, vaginal, _targetTile))
				mounted.push(vaginal);
			if (mounted.len() > 0)
				return mounted[this.Math.rand(0, mounted.len() - 1)];
		}

		// Random pick between all available skills
		local usable = [];
		if (hands != null && this.canUseSkill(_entity, hands, _targetTile))
			usable.push(hands);
		if (oral != null && this.canUseSkill(_entity, oral, _targetTile))
			usable.push(oral);
		if (vaginal != null && this.canUseSkill(_entity, vaginal, _targetTile))
			usable.push(vaginal);

		if (usable.len() == 0) return null;
		return usable[this.Math.rand(0, usable.len() - 1)];
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
			this.m.SelectedSkill.use(this.m.TargetTile);

			if (_entity.isAlive())
			{
				this.getAgent().declareAction();

				if (this.m.SelectedSkill.getDelay() != 0)
					this.getAgent().declareEvaluationDelay(this.m.SelectedSkill.getDelay());
			}
		}

		if (_entity.isAlive() && _entity.getActionPoints() >= apBefore)
			this.m.GaveUp = true;

		this.m.TargetTile = null;
		this.m.SelectedSkill = null;
		return true;
	}
});
