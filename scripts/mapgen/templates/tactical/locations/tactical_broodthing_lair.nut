this.tactical_broodthing_lair <- this.inherit("scripts/mapgen/tactical_template", {
	m = {
		Details = [
			"lewd_tentacle_slime_01",
			"lewd_tentacle_slime_02",
			"lewd_tentacle_veins_01",
			"lewd_tentacle_flesh_01",
			"lewd_tentacle_slime_01",
			"lewd_tentacle_slime_02",
			"lewd_tentacle_veins_01"
		]
	},
	function init()
	{
		this.m.Name = "tactical.broodthing_lair";
		this.m.MinX = 28;
		this.m.MinY = 28;
	}

	function fill( _rect, _properties, _pass = 1 )
	{
		// Calculate center of the location area
		local centerX = _rect.X + _rect.W / 2 + ("ShiftX" in _properties ? _properties.ShiftX : 0);
		local centerY = _rect.Y + _rect.H / 2 + ("ShiftY" in _properties ? _properties.ShiftY : 0);
		local centerTile = this.Tactical.getTileSquare(centerX, centerY);

		for (local x = _rect.X; x < _rect.X + _rect.W; x = ++x)
		{
			for (local y = _rect.Y; y < _rect.Y + _rect.H; y = ++y)
			{
				local tile = this.Tactical.getTileSquare(x, y);

				if (tile == null)
					continue;

				local dist = centerTile != null ? centerTile.getDistanceTo(tile) : 99;

				// Inner ring (0-3): heavy corruption - details + mounds
				if (dist <= 3)
				{
					// Clear existing objects sometimes to make room
					if (this.Math.rand(1, 100) <= 60)
						tile.removeObject();

					// Spawn corruption details on most inner tiles
					if (this.Math.rand(1, 100) <= 70)
						tile.spawnDetail(this.m.Details[this.Math.rand(0, this.m.Details.len() - 1)]);

					// Spawn corruption mounds occasionally (not on center, leave room for boss)
					if (dist >= 2 && tile.IsEmpty && this.Math.rand(1, 100) <= 15)
						tile.spawnObject("entity/tactical/objects/lewd_tentacle_mound");
				}
				// Middle ring (4-6): scattered corruption + tentacle pillars on edges
				else if (dist <= 6)
				{
					// Details less frequent
					if (this.Math.rand(1, 100) <= 35)
						tile.spawnDetail(this.m.Details[this.Math.rand(0, this.m.Details.len() - 1)]);

					// Tentacle pillars as obstacles
					if (tile.IsEmpty && this.Math.rand(1, 100) <= 12)
						tile.spawnObject("entity/tactical/objects/lewd_tentacle_pillar");
				}
				// Outer ring (7-9): sparse corruption, tentacle pillars as arena border
				else if (dist <= 9)
				{
					// Occasional detail
					if (this.Math.rand(1, 100) <= 15)
						tile.spawnDetail(this.m.Details[this.Math.rand(0, this.m.Details.len() - 1)]);

					// More pillars on the outer edge to create arena walls
					if (dist >= 8 && tile.IsEmpty && this.Math.rand(1, 100) <= 25)
					{
						local o = tile.spawnObject("entity/tactical/objects/lewd_tentacle_pillar");
						if (o != null && centerTile != null)
						{
							// Face pillars toward center
							o.setFlipped(tile.Coords.X > centerX);
						}
					}
				}
			}
		}
	}
});
