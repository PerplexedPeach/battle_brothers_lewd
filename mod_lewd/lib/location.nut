::Lewd.Location <- {
	function closeToSouthernTown()
	{
		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();
		local closeToSouthernTown = false;

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= ::Lewd.Const.MasochismSouthernDistanceRequirement)
			{
				closeToSouthernTown = true;
				break;
			}
		}

		return closeToSouthernTown;
	}

	function inTheSouth()
	{
		// 0 is the bottom of the map
        local currentTile = this.World.State.getPlayer().getTile();
		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.3)
		{
			return true;
		}
		// for handling when the entire south is water
		return currentTile.Type == this.Const.World.TerrainType.Desert || currentTile.Type == this.Const.World.TerrainType.Oasis ||
		(currentTile.Type == this.Const.World.TerrainType.Hills && currentTile.Subregion == this.Const.World.TerrainType.Desert);
	}

	function inTheNorth()
	{
		// 0 is the bottom of the map
		local currentTile = this.World.State.getPlayer().getTile();
		return currentTile.SquareCoords.Y > this.World.getMapSize().Y * this.Const.World.Settings.Snowline;
	}

	// Find a valid tile to spawn a location near a pivot point.
	// Replicates core logic from contract.getTileToSpawnLocation().
	function findNearbyTile( _pivotTile, _minDist, _maxDist, _excludedTerrains = [], _requiredTerrain = null )
	{
		local mapSize = this.World.getMapSize();
		local tries = 0;
		local minDistToLocations = _minDist == 0 ? 0 : this.Math.min(4, _minDist - 1);
		local used = [];
		local origMinDist = _minDist;
		local origMaxDist = _maxDist;

		while (true)
		{
			tries++;

			if (tries == 500)
			{
				_maxDist = origMaxDist * 2;
				_minDist = origMinDist / 2;
			}

			if (tries == 3000 && _requiredTerrain != null)
			{
				::logWarning("[mod_lewd] findNearbyTile: expanding to full map search for required terrain");
				_minDist = 0;
				_maxDist = this.Math.max(mapSize.X, mapSize.Y);
				minDistToLocations = 2;
				used = [];
			}

			if (tries >= 6000)
			{
				::logWarning("[mod_lewd] findNearbyTile: failed after 6000 tries (3000 local + 3000 full map)");
				return null;
			}

			local x = this.Math.rand(_pivotTile.SquareCoords.X - _maxDist, _pivotTile.SquareCoords.X + _maxDist);
			local y = this.Math.rand(_pivotTile.SquareCoords.Y - _maxDist, _pivotTile.SquareCoords.Y + _maxDist);

			if (x <= 3 || x >= mapSize.X - 3 || y <= 3 || y >= mapSize.Y - 3)
				continue;

			if (!this.World.isValidTileSquare(x, y))
				continue;

			local tile = this.World.getTileSquare(x, y);

			if (used.find(tile.ID) != null)
				continue;

			used.push(tile.ID);

			if (tile.Type == this.Const.World.TerrainType.Ocean)
				continue;

			if (tile.IsOccupied)
				continue;

			if (tile.getDistanceTo(_pivotTile) < _minDist)
				continue;

			if (_requiredTerrain != null && tile.Type != _requiredTerrain)
				continue;

			local abort = false;
			foreach (t in _excludedTerrains)
			{
				if (t == tile.Type)
				{
					abort = true;
					break;
				}
			}
			if (abort) continue;

			// Not too close to settlements
			local settlements = this.World.EntityManager.getSettlements();
			foreach (s in settlements)
			{
				if (s.getTile().getDistanceTo(tile) < this.Math.max(_minDist, 4))
				{
					abort = true;
					break;
				}
			}
			if (abort) continue;

			// Not too close to other locations
			if (minDistToLocations > 0)
			{
				local locations = this.World.EntityManager.getLocations();
				foreach (v in locations)
				{
					if (tile.getDistanceTo(v.getTile()) < minDistToLocations)
					{
						abort = true;
						break;
					}
				}
				if (abort) continue;
			}

			// Verify land connection to player
			local navSettings = this.World.getNavigator().createSettings();
			navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
			local path = this.World.getNavigator().findPath(this.World.State.getPlayer().getTile(), tile, navSettings, 0);

			if (path.isEmpty())
				continue;

			return tile;
		}

		return null;
	}
}