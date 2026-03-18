// AI behavior for horny entities that can't use sex skills on an adjacent target.
// Scores very high to suppress normal combat AI (weapon attacks / footwork).
// Engage (Order=EngageMelee) runs in an earlier phase and gets first shot at
// moving the entity. By the time idle evaluates (Order=AttackDefault), engage
// already either moved us adjacent (sex skills handle it) or failed.
// Shared by all species (not goblin-specific)
this.ai_horny_idle <- this.inherit("scripts/ai/tactical/behavior", {
	m = {},
	function create()
	{
		this.m.ID = ::Lewd.Const.AIBehaviorIDHornyIdle;
		this.m.Order = this.Const.AI.Behavior.Order.AttackDefault;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		if (!_entity.getSkills().hasSkill("effects.lewd_horny"))
			return 0;

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
			return 0;

		if (_entity.getActionPoints() < 2)
			return 0;

		// If adjacent to a valid female target, let sex skills handle it
		local myTile = _entity.getTile();
		for (local i = 0; i < 6; i++)
		{
			if (!myTile.hasNextTile(i)) continue;
			local tile = myTile.getNextTile(i);
			if (!tile.IsOccupiedByActor) continue;
			local adj = tile.getEntity();
			if (adj == null || !adj.isAlive()) continue;
			if (_entity.isAlliedWith(adj)) continue;
			if (adj.getGender() != 1) continue;
			if (adj.getPleasureMax() <= 0) continue;
			return 0;
		}

		// Not adjacent to any sex target -- 70% chance to idle, 30% to fight
		if (this.Math.rand(1, 100) > ::Lewd.Const.HornyIdleChance)
		{
			::logInfo("[ai_horny_idle] " + _entity.getName() + " shakes it off and fights (AP:" + _entity.getActionPoints() + ")");
			return 0;
		}

		::logInfo("[ai_horny_idle] " + _entity.getName() + " too aroused to fight, idling (AP:" + _entity.getActionPoints() + ")");
		return ::Lewd.Const.HornyIdleAIScore * this.getProperties().BehaviorMult[this.m.ID];
	}

	function onExecute( _entity )
	{
		::logInfo("[ai_horny_idle] " + _entity.getName() + " is too aroused to fight (AP:" + _entity.getActionPoints() + ")");
		_entity.setActionPoints(0);
		return true;
	}
});
