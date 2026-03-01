// AI movement behavior for horny entities — seeks out alluring female targets
// Scores targets by: allure - (distance * AllurePerTile)
// Each tile of distance costs ~10 allure, creating emergent behavior of
// preferring attractive targets further away over less attractive ones nearby
// Skips adjacent targets (handled by ai_horny which uses sex skills)
this.ai_horny_engage <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		TargetActor = null,
		GaveUp = false
	},
	function create()
	{
		this.m.ID = ::Lewd.Const.AIBehaviorIDHornyEngage;
		this.m.Order = this.Const.AI.Behavior.Order.EngageMelee;
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

		// Must have AP to move
		if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
			return 0;

		// Can't move if rooted
		if (_entity.getCurrentProperties().IsRooted)
			return 0;

		// Don't move if fleeing
		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
			return 0;

		// Skip if already adjacent to a valid female target (ai_horny handles that)
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
			// Already adjacent to a valid target — let ai_horny handle it
			return 0;
		}

		// Find known opponents, score by allure - distance * penalty
		local targets = this.getAgent().getKnownOpponents();
		local bestAdjustedAllure = 0.0;
		local bestTarget = null;
		local bestTargetTile = null;

		foreach (t in targets)
		{
			if (t.Actor.isNull()) continue;
			if (!t.Actor.isAlive()) continue;
			if (t.Actor.getGender() != 1) continue;
			if (t.Actor.getPleasureMax() <= 0) continue;

			local targetTile = t.Actor.getTile();
			local distance = myTile.getDistanceTo(targetTile);

			// Skip adjacent targets (handled by ai_horny)
			if (distance <= 1) continue;

			local allure = t.Actor.allure();
			local adjustedAllure = allure - distance * ::Lewd.Const.HornyAIEngageAllurePerTile;
			if (adjustedAllure <= 0) continue;

			if (adjustedAllure > bestAdjustedAllure)
			{
				bestAdjustedAllure = adjustedAllure;
				bestTarget = t.Actor;
				bestTargetTile = targetTile;
			}
		}

		if (bestTarget == null)
		{
			this.m.GaveUp = true;
			return 0;
		}

		// Find an empty tile adjacent to the target to move toward
		local destinationTile = null;
		local bestDestScore = -999;

		for (local i = 0; i < 6; i++)
		{
			if (!bestTargetTile.hasNextTile(i)) continue;
			local tile = bestTargetTile.getNextTile(i);
			if (!tile.IsEmpty) continue;
			if (this.Math.abs(tile.Level - bestTargetTile.Level) > 1) continue;

			// Prefer tiles closer to us (less movement needed)
			local destScore = -tile.getDistanceTo(myTile);
			if (destScore > bestDestScore)
			{
				bestDestScore = destScore;
				destinationTile = tile;
			}
		}

		if (destinationTile == null)
		{
			this.m.GaveUp = true;
			return 0;
		}

		this.m.TargetTile = destinationTile;
		this.m.TargetActor = bestTarget;

		// Score: base engage score * normalized allure factor
		local normalizedAllure = bestAdjustedAllure / ::Lewd.Const.HornyAIEngageAllureNorm;
		return ::Lewd.Const.HornyAIEngageScore * this.Math.maxf(0.1, normalizedAllure);
	}

	function onExecute( _entity )
	{
		if (this.m.TargetTile == null)
			return true;

		local navigator = this.Tactical.getNavigator();

		if (this.m.IsFirstExecuted)
		{
			this.m.IsFirstExecuted = false;

			local settings = navigator.createSettings();
			settings.ActionPointCosts = _entity.getActionPointCosts();
			settings.FatigueCosts = _entity.getFatigueCosts();
			settings.FatigueCostFactor = 0.0;
			settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
			settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
			settings.MaxLevelDifference = _entity.getMaxTraversibleLevels();
			settings.AllowZoneOfControlPassing = _entity.getCurrentProperties().IsImmuneToZoneOfControl;
			settings.ZoneOfControlCost = this.Const.AI.Behavior.ZoneOfControlAPPenalty;
			settings.AlliedFactions = _entity.getAlliedFactions();
			settings.Faction = _entity.getFaction();

			if (!navigator.findPath(_entity.getTile(), this.m.TargetTile, settings, 0))
			{
				this.m.TargetTile = null;
				this.m.TargetActor = null;
				return true;
			}

			local movement = navigator.getCostForPath(_entity, settings, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
			this.getAgent().adjustCameraToDestination(movement.End);
			return false;
		}

		// Continue travelling
		if (!navigator.travel(_entity, _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue()))
		{
			// Movement complete
			this.m.TargetTile = null;
			this.m.TargetActor = null;
			return true;
		}

		// Still moving
		return false;
	}
});
