// AI behavior for horny entities -- last resort when sex skills AND engage
// both can't act. Returns 0 when a viable target exists (engage handles
// movement, sex skills handle adjacent targets). Only fires when truly
// unreachable: no adjacent target and no distant target engage could reach.
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

		local myTile = _entity.getTile();

		// If adjacent to a valid female target, let sex skills handle it
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

		// If there's a distant target engage could reach, let engage handle it
		if (!_entity.getCurrentProperties().IsRooted)
		{
			local targets = this.getAgent().getKnownOpponents();
			foreach (t in targets)
			{
				if (t.Actor.isNull()) continue;
				if (!t.Actor.isAlive()) continue;
				if (t.Actor.getGender() != 1) continue;
				if (t.Actor.getPleasureMax() <= 0) continue;

				local targetTile = t.Actor.getTile();
				local distance = myTile.getDistanceTo(targetTile);
				if (distance <= 1) continue;

				local allure = t.Actor.allure();
				local adjustedAllure = allure - distance * ::Lewd.Const.HornyAIEngageAllurePerTile;
				if (adjustedAllure <= 0) continue;

				// Engage would find this target -- let it handle movement
				return 0;
			}
		}

		// Truly unreachable -- 70% chance to idle, 30% to fight normally
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
