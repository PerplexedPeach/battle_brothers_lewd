this.lewd_ethereal_second <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_ethereal_second";
		this.m.Title = "The Presence";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/ethereal_2_1.png[/img]It has been getting worse. Or better, depending on how you look at it.\n\nThe presence you first sensed weeks ago has grown bolder. You feel it most strongly after battle, in the trembling aftermath when the blood is still hot and the men around you are slick with sweat and adrenaline. It watches you then with an intensity that borders on hunger. Not threatening. Covetous.\n\nTonight, sitting cross-legged in your tent as night falls, the sensation is stronger than ever. You feel it behind you like a warm breath on your neck. When you turn, there is nothing. But the air where nothing stands carries a scent: something floral and musky, night-blooming jasmine mixed with something older, wilder. A woman's perfume from centuries past.\n\nYou hold your hand before the lamp and watch the light play across your skin. For a moment, just a heartbeat, your shadow on the tent wall does not match your posture. It is taller, with longer hair, and the silhouette of something trailing behind it. A tail, or a trick of the flickering light.\n\nYou blink, and it is your shadow again.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Who are you?",
					function getResult( _event )
					{
						return "B";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});

		this.m.Screens.push({
			ID = "B",
			Text = "You whisper the question into the empty tent. The lamp flame bends sideways, as though someone breathed on it. The scent of jasmine intensifies.\n\nNo answer comes. But something shifts in the quality of the silence. It feels, for lack of a better word, pleased. As though whatever haunts your peripheral vision is delighted that you have finally acknowledged it.\n\nA sound outside the tent flap. %randombrother% clears his throat.%SPEECH_ON%Captain? The lads are asking if you're... well. You've been in there a while. Some of them say they can smell something. Like... flowers. And something else.%SPEECH_OFF%He trails off, embarrassed. You know what the something else is. The musky sweetness that has been growing stronger with every battle, every climax drawn from willing and unwilling partners on the field.\n\nYou dress and step out. Every man within ten paces turns. Not because you command attention, though you do, but because something in the air around you has changed. There is a weight to your presence now, a gravity that pulls the eye and quickens the pulse.\n\nYou feel the watcher's approval like a warm hand on your shoulder. Whatever it is, wherever it came from, it has chosen you. And it is waiting for something.\n\nAs you settle by the fire, you catch a whisper at the edge of hearing. Not words, exactly. More like the memory of a voice, ancient and feminine, carried on the scent of dead flowers.%SPEECH_ON%Soon.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Something ancient has found you.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				_event.m.Woman.getFlags().set("lewdEtherealSecondFired", true);
				this.Characters.push(_event.m.Woman.getImagePath());

				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "You feel watched by something that is not human. It grows stronger after every battle."
				});
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		local climaxes = this.m.Woman == null ? 0
			: this.m.Woman.getFlags().getAsInt("lewdPartnerClimaxes") + this.m.Woman.getFlags().getAsInt("lewdSelfClimaxes");

		if (this.m.Woman == null
			|| this.m.Woman.getFlags().has("lewdEtherealSecondFired")
			|| ::Lewd.Mastery.getLewdTier(this.m.Woman) < 2
			|| !this.m.Woman.getFlags().has("lewdEtherealFirstFired")
			|| climaxes < ::Lewd.Const.EtherealSecondEventThreshold
			|| this.World.Flags.getAsInt("lewdEtherealQuestStage") >= 1)
		{
			this.m.Score = 0;
		} else {
			this.m.Score = ::Lewd.Const.EtherealSecondEventBaseScore + climaxes * 10;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"woman",
			this.m.Woman.getName()
		]);
	}

	function onClear()
	{
		this.m.Woman = null;
	}
});
