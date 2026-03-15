this.lewd_ethereal_gheist <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		Gheist = null
	},
	function create()
	{
		this.m.ID = "event.lewd_ethereal_gheist";
		this.m.Title = "The Lingering Spirit";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "The battle is over. The ghosts have been broken, scattered back to whatever forgotten graves spawned them. Your men are catching their breath, wiping ectoplasm from their blades, muttering prayers to gods they only remember when the dead walk.\n\nBut one remains.\n\nA single gheist hovers at the edge of the battlefield, translucent and still. It does not attack. It does not wail. It simply watches you with empty eyes that somehow convey more intelligence than any spirit you have ever encountered.\n\nThe men do not seem to notice it. When you glance at %randombrother%, he is busy cleaning his weapon, oblivious. But you see it clearly: a woman's form, pale and ancient, her spectral hair drifting as though submerged in invisible water. She is beautiful in the way that drowning is beautiful. Terrible and compelling.\n\nShe opens her mouth, and instead of the expected shriek, you hear a voice. Not with your ears. Inside your skull, intimate as a whisper pressed against your thoughts.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Listen.",
					function getResult( _event )
					{
						return "B";
					}
				},
				{
					Text = "Ignore it and walk away.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Gheist.getImagePath());
			}
		});

		this.m.Screens.push({
			ID = "B",
			Text = "%SPEECH_ON%Finally. I have been watching you for so long, little mortal. Waiting to see if you were worth the effort.%SPEECH_OFF%The gheist drifts closer. The scent of jasmine floods your senses. This is what has been watching you. This is the presence you felt in camp, the shadow that did not match your own, the whispered 'soon' on the edge of sleep.%SPEECH_ON%I am... was... what your people would call a fox spirit. A seductress. A devourer of desire. I lived for centuries, feeding on the passion of mortals, growing stronger with each one I consumed. I was magnificent.%SPEECH_OFF%Her spectral form flickers, and for a moment you glimpse her as she must have been in life: devastating beauty, fox-gold eyes, a smile that could make kings abandon their thrones.%SPEECH_ON%But I was killed. Betrayed and destroyed by creatures that had no understanding of what I was. My body persists, preserved by its own magic, but my spirit wanders. Until now. Until you.%SPEECH_OFF%She circles you slowly, her ghostly fingers trailing inches from your skin. Goosebumps rise in their wake.%SPEECH_ON%You have something rare. I can taste it on you. The warmth you carry, the way men turn when you pass, the hunger that stirs in them without your even trying. You are a seed that has not yet learned what kind of flower it will become.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What do you want?",
					function getResult( _event )
					{
						return "C";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Gheist.getImagePath());
			}
		});

		this.m.Screens.push({
			ID = "C",
			Text = "The gheist's empty eyes blaze with sudden intensity.%SPEECH_ON%I offer you a pact. My essence merged with yours. My centuries of knowledge, of power, of mastery over desire, poured into your vessel. You would become something the world has not seen in an age. Not a mere woman who turns heads. A force of nature. Ethereal.%SPEECH_OFF%She pauses, her spectral form solidifying slightly, as though the very force of her desire gives her substance.\n\nYou think of the men. The way their obedience has curdled into something conditional. The whispered conversations that stop when you approach. You are still captain, but for how much longer? If what she offers is real, you would never need to wonder again. No man would hesitate at your command. No man would dare.%SPEECH_ON%But I will not give myself to someone unworthy. You must prove that you are strong enough to contain what I am. Three trials. Three enemies from my past, still walking this world. Destroy them, and I will know you are ready.%SPEECH_OFF%The gheist extends a translucent hand toward you.%SPEECH_ON%The first is a man. A bandit lord who shelters in a camp not far from here. In life, he spurned me. Rejected my gift and tried to sell me to slavers. He has grown old and cruel, but he still breathes, and that offends me. Kill him, and we will speak again.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Accept the pact. You will prove yourself.",
					function getResult( _event )
					{
						return "D";
					}
				},
				{
					Text = "Refuse. You will find your own path.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Gheist.getImagePath());
			}
		});

		this.m.Screens.push({
			ID = "D",
			Text = "You reach out and your fingers pass through her spectral hand. But you feel it: a jolt of warmth, of connection, of something ancient and powerful acknowledging your existence. The gheist smiles, and for a moment she is radiant.%SPEECH_ON%Good. I will guide you. Listen for my voice. I will show you where to find the faithless one.%SPEECH_OFF%She begins to fade, her form dissolving into the morning mist. But her voice lingers, a warm echo behind your thoughts.%SPEECH_ON%Do not disappoint me, little one. I have waited too long for this.%SPEECH_OFF%A location burns itself into your awareness. Not coordinates or a map. A pull, a magnetic certainty of direction, the way migratory birds know which way is south. You know where the bandit camp is. You can feel it.\n\nThe men are packing up, oblivious to the conversation that just reshaped your destiny. %randombrother% glances at you and does a double-take.%SPEECH_ON%Captain? You've got the strangest look on your face. You alright?%SPEECH_OFF%You smile. The expression feels different on your lips now. Sharper. More knowing. He holds your gaze for a moment, then looks away first. A small thing. But you notice it.%SPEECH_ON%Better than alright. Break camp. We have somewhere to be.%SPEECH_OFF%He goes. Whether out of habit or something else, you cannot say. But for the first time in a while, the uncertainty does not bother you. You have a direction now. The rest will follow, or it won't.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "March toward the bandit camp.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Gheist.getImagePath());

				// Set quest stage
				this.World.Flags.set("lewdEtherealQuestStage", 2);

				// Spawn bandit camp location
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = ::Lewd.Location.findNearbyTile(playerTile,
					::Lewd.Const.EtherealQuestSpawnMinDist,
					::Lewd.Const.EtherealQuestSpawnMaxDist);

				if (tile != null)
				{
					local loc = this.World.spawnLocation(
						"scripts/entity/world/locations/lewd_bandit_camp_location",
						tile.Coords);
					loc.onSpawned();
					loc.setDiscovered(true);
					loc.getSprite("selection").Visible = true;
					this.World.uncoverFogOfWar(loc.getTile().Pos, 500.0);
					this.World.Flags.set("lewdEtherealQuestTargetID", loc.getID());

					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = "A bandit camp has been revealed on the map."
					});

					::logInfo("[mod_lewd] Ethereal quest: bandit camp spawned at tile " + tile.SquareCoords.X + "," + tile.SquareCoords.Y);
				}
				else
				{
					::logWarning("[mod_lewd] Ethereal quest: failed to find tile for bandit camp!");
				}
			}
		});
	}

	function onUpdateScore()
	{
		// This event is fired directly from onCombatFinished, not via score system
	}

	function onPrepare()
	{
		this.m.Woman = ::Lewd.Transform.target();
		this.m.Gheist = this.World.getGuestRoster().create("scripts/entity/tactical/humans/succubus_gheist");
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.Woman != null)
		{
			_vars.push([
				"woman",
				this.m.Woman.getName()
			]);
		}
	}

	function onClear()
	{
		this.m.Woman = null;
		this.m.Gheist = null;
	}
});
