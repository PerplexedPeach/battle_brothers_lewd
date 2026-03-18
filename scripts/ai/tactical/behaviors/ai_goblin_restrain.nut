// AI behavior for goblins — restrain climaxing targets
// Always active (not gated by horny), highest priority goblin behavior
// Uses goblin_restrain_skill which costs all AP
this.ai_goblin_restrain <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		SelectedSkill = null,
		GaveUp = false
	},
	function create()
	{
		this.m.ID = ::Lewd.Const.AIBehaviorIDGoblinRestrain;
		this.m.Order = this.Const.AI.Behavior.Order.AttackDefault;
		this.behavior.create();
	}

	function onTurnStarted()
	{
		this.m.GaveUp = false;
	}

	function onEvaluate( _entity )
	{
		// Log that we're being evaluated at all (catches BehaviorMult silent skip)
		::logInfo("[ai_goblin_restrain] " + _entity.getName() + " evaluating (AP:" + _entity.getActionPoints() + " GaveUp:" + this.m.GaveUp + ")");

		if (this.m.GaveUp)
			return 0;

		// Must have the goblin restrain skill
		local restrainSkill = _entity.getSkills().getSkillByID("actives.goblin_restrain");
		if (restrainSkill == null)
		{
			::logInfo("[ai_goblin_restrain] " + _entity.getName() + " has no restrain skill");
			this.m.GaveUp = true;
			return 0;
		}

		if (!restrainSkill.isUsable())
		{
			::logInfo("[ai_goblin_restrain] " + _entity.getName() + " restrain not usable");
			return 0;
		}

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
			return 0;

		// Find adjacent climaxing, non-restrained target
		local myTile = _entity.getTile();
		local bestTile = null;

		for (local i = 0; i < 6; i++)
		{
			if (!myTile.hasNextTile(i)) continue;
			local tile = myTile.getNextTile(i);
			if (!tile.IsOccupiedByActor) continue;
			local target = tile.getEntity();
			if (target == null || !target.isAlive()) continue;
			if (_entity.isAlliedWith(target)) continue;

			local hasClimax = target.getSkills().hasSkill("effects.climax");
			local hasRestrained = target.getSkills().hasSkill("effects.lewd_restrained");
			::logInfo("[ai_goblin_restrain]   adj: " + target.getName() + " climax:" + hasClimax + " restrained:" + hasRestrained);

			if (!restrainSkill.onVerifyTarget(myTile, tile))
				continue;

			bestTile = tile;
			break;
		}

		if (bestTile == null)
			return 0;

		this.m.TargetTile = bestTile;
		this.m.SelectedSkill = restrainSkill;

		local score = ::Lewd.Const.GoblinRestrainAIScore * this.getProperties().BehaviorMult[this.m.ID];
		::logInfo("[ai_goblin_restrain] " + _entity.getName() + " will restrain " + bestTile.getEntity().getName() + " (score:" + score + ")");
		return score;
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
			::logInfo("[ai_goblin_restrain] " + _entity.getName() + " EXECUTING restrain on " + this.m.TargetTile.getEntity().getName());
			this.m.SelectedSkill.use(this.m.TargetTile);

			if (_entity.isAlive())
				this.getAgent().declareAction();
		}

		if (_entity.isAlive() && _entity.getActionPoints() >= apBefore)
		{
			::logInfo("[ai_goblin_restrain] " + _entity.getName() + " skill did not consume AP, giving up");
			this.m.GaveUp = true;
		}

		this.m.TargetTile = null;
		this.m.SelectedSkill = null;
		return true;
	}
});
