// AI behavior for horny entities that can't reach a target
// Only activates as a true last resort: when sex skills have no adjacent target
// AND engage can't find a reachable distant target. Returns a very high score
// to suppress normal combat AI (weapon attacks while horny).
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

		// Check if there's an adjacent female target -- sex skills would handle this
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
			// Adjacent valid target exists -- let sex skills handle it
			return 0;
		}

		// Check if engage would find a viable target (same allure-distance filter)
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

				// Same allure-distance check as ai_horny_engage
				local allure = t.Actor.allure();
				local adjustedAllure = allure - distance * ::Lewd.Const.HornyAIEngageAllurePerTile;
				if (adjustedAllure <= 0) continue;

				// Check if any tile adjacent to the target is empty
				local hasEmptyTile = false;
				for (local i = 0; i < 6; i++)
				{
					if (!targetTile.hasNextTile(i)) continue;
					local tile = targetTile.getNextTile(i);
					if (!tile.IsEmpty) continue;
					hasEmptyTile = true;
					break;
				}

				if (hasEmptyTile)
					return 0; // Engage should handle this
			}
		}

		// No adjacent target AND no reachable distant target -- chance to idle
		if (this.Math.rand(1, 100) > ::Lewd.Const.HornyIdleChance)
		{
			::logInfo("[ai_horny_idle] " + _entity.getName() + " shakes it off and fights (AP:" + _entity.getActionPoints() + ")");
			return 0;
		}

		::logInfo("[ai_horny_idle] " + _entity.getName() + " evaluating: no sex target reachable, will idle (AP:" + _entity.getActionPoints() + ")");
		return ::Lewd.Const.HornyIdleAIScore * this.getProperties().BehaviorMult[this.m.ID];
	}

	function onExecute( _entity )
	{
		::logInfo("[ai_horny_idle] " + _entity.getName() + " is too aroused to fight (AP:" + _entity.getActionPoints() + ")");
		_entity.setActionPoints(0);
		return true;
	}
});
