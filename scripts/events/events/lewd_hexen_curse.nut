this.lewd_hexen_curse <- this.inherit("scripts/events/event", {
	m = {
		Man = null
	},
	function create()
	{
		this.m.ID = "event.lewd_hexen_curse";
		this.m.Title = "The Hexen's Whisper";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "The Hexen are dead, their twisted bodies crumpled in the underbrush. The brothers clean their blades and gather what loot they can, but you stand rooted to the spot, staring at the eldest Hexen's corpse. Something happened during that fight that you haven't told anyone about.\n\nShe singled you out. Not with claws or curses like the others. She looked at you across the battlefield, her milky eyes locking onto yours with an intelligence that went beyond animal cunning. The fighting seemed to slow around you, sounds growing distant, and she spoke. Not the guttural hissing the Hexen use to charm men into servitude, but words. Clear, deliberate words, spoken in a voice like cracking ice.\n\n%SPEECH_ON%Such wasted potential. Let me fix that.%SPEECH_OFF%\n\nThen she reached out, not physically, but something cold and sharp lanced through your chest, burrowed into your ribs, and settled there like a seed pressed into frozen soil. You gasped. She smiled. And then %randombrother% put a crossbow bolt through her throat and the moment shattered.\n\nBut the seed remains. You can feel it now, lodged beneath your sternum, a tiny point of cold that pulses faintly with each heartbeat. It doesn't hurt. That's what worries you.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What did she do to me?",
					function getResult( _event )
					{
						return "B";
					}
				}
			],
			function start( _event )
			{
				if (_event.m.Man != null)
					this.Characters.push(_event.m.Man.getImagePath());
			}
		});

		this.m.Screens.push({
			ID = "B",
			Text = "That night, you examine yourself by lamplight. No wound, no mark, no scar where the cold entered. You press your fingers to the spot and feel it pulse in response, almost playfully, like a cat batting at a hand. The cold spreads for a moment, threading through your veins in thin lines that you swear you can almost see beneath your skin, pale blue against the firelight. Then it retreats, coiling back into its resting place.\n\nYou consider telling the men. Seeking out a healer, an alchemist, someone who might know how to remove whatever the Hexen planted in you. But something stays your tongue. A whisper at the back of your mind, not words exactly, but a feeling. Patience. As though the seed is asking you to wait. To let it grow.\n\nYou flex your hands. Your fingers look the same as they always have. Calloused, scarred, a fighting man's hands. But when you close your eyes, you can feel the cold mapping your body from the inside, learning the architecture of your bones, the topology of your muscles, like a tailor taking measurements for a garment not yet sewn.\n\nWhatever the Hexen did, it isn't finished.\n\n%randombrother% calls from outside the tent.%SPEECH_ON%Captain? You coming to eat? You've been quiet since the fight.%SPEECH_OFF%\n\n%SPEECH_ON%In a minute.%SPEECH_OFF% Your voice sounds normal. For now.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Something is taking root inside you.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local man = _event.m.Man;
				if (man == null) return;
				man.getFlags().set("lewdHexenCursed", true);

				this.List.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "You have been cursed by the Hexen. Something is changing."
				});

				this.Characters.push(man.getImagePath());
			}
		});
	}

	function onUpdateScore()
	{
		// Only eligible after a hexen fight. The lewdFoughtHexen flag is set in
		// lewd_info_effect.onCombatStarted and cleared in the onCombatFinished hook
		// after this event fires. Without this check the event enters the random
		// pool and can fire after any battle.
		if (!this.World.Statistics.getFlags().get("lewdFoughtHexen"))
		{
			this.m.Score = 0;
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		::logInfo("[hexen_curse] onUpdateScore: roster size=" + brothers.len());
		foreach (bro in brothers)
		{
			local g = bro.getGender();
			local pc = bro.getFlags().get("IsPlayerCharacter");
			local cursed = bro.getFlags().has("lewdHexenCursed");
			local tier = ::Lewd.Mastery.getLewdTier(bro);
			::logInfo("[hexen_curse]   " + bro.getName() + " gender=" + g + " isPC=" + pc + " cursed=" + cursed + " tier=" + tier);
			if (g == 0 && pc && !cursed && tier == 0)
			{
				this.m.Man = bro;
				this.m.Score = 1;
				::logInfo("[hexen_curse]   -> MATCH, score=1");
				return;
			}
		}

		::logInfo("[hexen_curse]   -> no match, score=0");
		this.m.Score = 0;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.Man != null)
		{
			_vars.push([
				"man",
				this.m.Man.getName()
			]);
		}
	}

	function onClear()
	{
		this.m.Man = null;
	}
});
