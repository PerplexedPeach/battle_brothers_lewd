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
}