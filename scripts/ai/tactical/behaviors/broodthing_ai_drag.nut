// Custom drag behavior for broodthing ensnare. Replaces base game ai_drag
// which uses pathfinding (unnecessary since kraken_move_ensnared teleports)
// and falls back to entityWaitTurn during evaluation (causes C++ crash).
// This version directly searches for the best empty tile within teleport range.
this.broodthing_ai_drag <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		PossibleSkills = [
			"actives.kraken_move_ensnared"
		],
		Skill = null
	},
	function create()
	{
		this.m.ID = this.Const.AI.Behavior.ID.Drag;
		this.m.Order = this.Const.AI.Behavior.Order.Drag;
		this.m.IsThreaded = false;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		this.m.Skill = null;
		this.m.TargetTile = null;
		local scoreMult = this.getProperties().BehaviorMult[this.m.ID];

		foreach (skillID in this.m.PossibleSkills)
		{
			local skill = _entity.getSkills().getSkillByID(skillID);

			if (skill != null && skill.isUsable() && skill.isAffordable())
			{
				this.m.Skill = skill;
				break;
			}
		}

		if (this.m.Skill == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		// Find the body (Kraken type entity)
		local body;
		local instances = this.Tactical.Entities.getAllInstances();

		for (local f = this.Const.Faction.PlayerAnimals + 1; f != instances.len(); f = ++f)
		{
			for (local p = 0; p != instances[f].len(); p = ++p)
			{
				if (instances[f][p].getType() == this.Const.EntityType.Kraken)
				{
					body = instances[f][p];
					break;
				}
			}
		}

		if (body == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		// Find the best empty tile within teleport range that's closest to the body
		local entityTile = _entity.getTile();
		local bodyTile = body.getTile();
		local maxRange = this.m.Skill.getMaxRange();
		local bestTile = null;
		local bestDist = entityTile.getDistanceTo(bodyTile);
		local mapSize = this.Tactical.getMapSize();
		local ex = entityTile.SquareCoords.X;
		local ey = entityTile.SquareCoords.Y;

		for (local dx = -maxRange; dx <= maxRange; dx = ++dx)
		{
			local sx = ex + dx;

			if (sx < 0 || sx >= mapSize.X)
			{
				continue;
			}

			for (local dy = -maxRange; dy <= maxRange; dy = ++dy)
			{
				local sy = ey + dy;

				if (sy < 0 || sy >= mapSize.Y)
				{
					continue;
				}

				local tile = this.Tactical.getTileSquare(sx, sy);

				if (!tile.IsEmpty)
				{
					continue;
				}

				if (entityTile.getDistanceTo(tile) > maxRange)
				{
					continue;
				}

				local dist = tile.getDistanceTo(bodyTile);

				if (dist < bestDist)
				{
					bestDist = dist;
					bestTile = tile;
				}
			}
		}

		if (bestTile == null)
		{
			return this.Const.AI.Behavior.Score.Zero;
		}

		this.m.TargetTile = bestTile;
		return this.Const.AI.Behavior.Score.Drag * scoreMult;
	}

	function onExecute( _entity )
	{
		this.getAgent().adjustCameraToDestination(this.m.TargetTile);

		if (this.m.Skill.use(this.m.TargetTile))
		{
			local delay = 0;

			if (!_entity.isHiddenToPlayer())
			{
				delay = delay + 800;
			}

			if (this.m.TargetTile.IsVisibleForPlayer)
			{
				delay = delay + 1250;
			}

			this.getAgent().declareEvaluationDelay(delay);
		}

		return true;
	}

});
