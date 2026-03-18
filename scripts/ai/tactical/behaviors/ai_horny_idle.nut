// AI behavior for horny entities that can't reach a target
// On first evaluation each turn, defers to engage if a distant target exists.
// On subsequent evaluations (after engage had its chance), fires to suppress
// normal combat AI (weapon attacks / footwork while horny).
// Shared by all species (not goblin-specific)
this.ai_horny_idle <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		HasDeferred = false
	},
	function create()
	{
		this.m.ID = ::Lewd.Const.AIBehaviorIDHornyIdle;
		this.m.Order = this.Const.AI.Behavior.Order.AttackDefault;
		this.behavior.create();
	}

	function onTurnStarted()
	{
		this.m.HasDeferred = false;
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
			return 0;
		}

		// First evaluation this turn: defer to engage if a distant target exists
		if (!this.m.HasDeferred)
		{
			this.m.HasDeferred = true;

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
					{
						::logInfo("[ai_horny_idle] " + _entity.getName() + " deferring to engage (first eval)");
						return 0;
					}
				}
			}
		}

		// Subsequent evaluation OR no viable engage target -- chance to idle
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
