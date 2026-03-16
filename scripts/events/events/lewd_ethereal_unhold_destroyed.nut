this.lewd_ethereal_unhold_destroyed <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		Gheist = null
	},
	function create()
	{
		this.m.ID = "event.lewd_ethereal_unhold_destroyed";
		this.m.Title = "The Beast Falls";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "The unhold lies in a spreading lake of its own blood, still twitching. It is enormous even in death, a mountain of muscle and hide that took everything your company had to bring down. Your men are catching their breath, some nursing wounds, others simply staring at the thing with the dull wonder of survivors.\n\nYou approach the corpse and feel something stir in your chest. Not revulsion. Not triumph. Something more complicated. Your hand reaches out and presses against the creature's flank. The hide is still warm. Beneath it, the last tremors of a heart that has beaten for centuries.\n\nYou feel her arrive like a change in pressure. The scent of jasmine cuts through the stink of blood and bowels.\n\nThe gheist materializes beside you, closer than she has ever been. Her translucent form hovers over the beast, and the expression on her face is difficult to read.%SPEECH_ON%I found it in the deep forest, long after I had grown tired of mortal men and their clumsy hands. This one had a tongue longer than your arm. Dexterous. Patient. It could find things no man ever bothered to look for.%SPEECH_OFF%She drifts along the unhold's flank, her spectral fingers tracing the contours of its jaw.%SPEECH_ON%It never feared me. Never worshipped me. It simply wanted, and took, and was satisfied. No games. No bargaining. No politics. After centuries of whispering the right words into the right ears, you cannot imagine how refreshing that was.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You loved a beast?",
					function getResult( _event )
					{
						return "B";
					}
				}
			],
			function start( _event )
			{
				if (_event.m.Woman != null)
					this.Characters.push(_event.m.Woman.getImagePath());
				if (_event.m.Gheist != null)
					this.Characters.push(_event.m.Gheist.getImagePath());
			}
		});

		this.m.Screens.push({
			ID = "B",
			Text = "The gheist turns to you. There is no defensiveness in her expression. No shame.%SPEECH_ON%It was simple. No manipulation, no careful positioning. It would pin me down and that tongue would work until I could not think straight. Just two creatures taking what they wanted from each other. I miss that simplicity more than anything else from my old life.%SPEECH_OFF%She is quiet for a long moment. Then something shifts in her expression. A loosening, like a fist slowly unclenching.%SPEECH_ON%But missing it was what kept me here. Tethered. You cannot ascend while you are still reaching backward. I see that now.%SPEECH_OFF%You feel it too, the borrowed emotion. Not grief exactly. More like the memory of a body that no longer aches, a phantom sensation of warmth letting go. You understand it. The exhaustion of always performing. Of being captain, being desired, being feared. The quiet wish to stop calculating and just act.\n\nThe feeling fades, but it leaves a residue. You look at your men and see them differently for a moment. Small. Brief. Candles guttering in a wind they cannot feel.%SPEECH_ON%One trial remains. The creature that killed me. It lurks in a cavern not far from here, feeding on my old body's magic. When I died, my flesh did not decay. It could not. There was too much power in it. The thing that killed me has been gorging on that power ever since, growing stronger with each passing year.%SPEECH_OFF%Her voice hardens.%SPEECH_ON%Kill it. Reclaim my body. And then we will finish what we started.%SPEECH_OFF%A new pull. Stronger than the last. A dark certainty, like the weight of a stone dropped into deep water.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "March toward the cavern.",
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
				if (_event.m.Gheist != null)
					this.Characters.push(_event.m.Gheist.getImagePath());

				// Advance quest stage
				this.World.Flags.set("lewdEtherealQuestStage", 4);

				// Spawn tentacle lair
				local playerTile = this.World.State.getPlayer().getTile();
				// Spawn in swamp terrain so the lair gets swamp combat tiles
				local tile = ::Lewd.Location.findNearbyTile(playerTile,
					::Lewd.Const.EtherealQuestSpawnMinDist,
					::Lewd.Const.EtherealQuestSpawnMaxDist,
					[],
					this.Const.World.TerrainType.Swamp);

				if (tile != null)
				{
					local loc = this.World.spawnLocation(
						"scripts/entity/world/locations/lewd_broodthing_lair_location",
						tile.Coords);
					loc.onSpawned();
					loc.setDiscovered(true);
					loc.getSprite("selection").Visible = true;
					this.World.uncoverFogOfWar(loc.getTile().Pos, 500.0);
					this.World.Flags.set("lewdEtherealQuestTargetID", loc.getID());

					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = "A foreboding cavern has been revealed on the map."
					});

					::logInfo("[mod_lewd] Ethereal quest: tentacle lair spawned");
				}
				else
				{
					::logWarning("[mod_lewd] Ethereal quest: failed to find tile for tentacle lair!");
				}
			}
		});
	}

	function onUpdateScore()
	{
		// Fired via location OnDestroyed, not via score system
	}

	function onPrepare()
	{
		::logInfo("[mod_lewd] Ethereal quest: unhold destroyed event preparing");
		this.m.Woman = ::Lewd.Transform.target();
		this.m.Gheist = this.World.getGuestRoster().create("scripts/entity/tactical/humans/succubus_gheist");
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
		if (this.m.Gheist != null)
		{
			this.World.getGuestRoster().remove(this.m.Gheist);
			this.m.Gheist = null;
		}
		this.m.Woman = null;
	}
});
