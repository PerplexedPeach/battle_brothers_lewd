// Stub event for Session 3 implementation
this.lewd_ethereal_unhold_destroyed <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_ethereal_unhold_destroyed";
		this.m.Title = "The Beast Falls";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "TODO: Session 3 narrative. The unhold is dead. The spirit acknowledges your strength and directs you to the final trial.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Onward.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				if (_event.m.Woman != null)
					this.Characters.push(_event.m.Woman.getImagePath());

				// Advance quest stage
				this.World.Flags.set("lewdEtherealQuestStage", 4);

				// Spawn tentacle lair
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = ::Lewd.Location.findNearbyTile(playerTile,
					::Lewd.Const.EtherealQuestSpawnMinDist,
					::Lewd.Const.EtherealQuestSpawnMaxDist);

				if (tile != null)
				{
					local loc = this.World.spawnLocation(
						"scripts/entity/world/locations/lewd_tentacle_lair_location",
						tile.Coords);
					loc.onSpawned();
					loc.setDiscovered(true);
					loc.getSprite("selection").Visible = true;
					this.World.uncoverFogOfWar(loc.getTile().Pos, 500.0);
					this.World.Flags.set("lewdEtherealQuestTargetID", loc.getID());

					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = "A strange cavern has been revealed on the map."
					});
				}
			}
		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		this.m.Woman = ::Lewd.Transform.target();
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.Woman != null)
			_vars.push(["woman", this.m.Woman.getName()]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Woman = null;
	}
});
