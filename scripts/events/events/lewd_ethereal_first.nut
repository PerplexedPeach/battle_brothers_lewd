this.lewd_ethereal_first <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_ethereal_first";
		this.m.Title = "Watching Eyes";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/ethereal_1_1.png[/img]You wake before dawn, skin damp with sweat. Something pulled you out of sleep. Not a sound. Not a dream. A feeling. The certainty that you were being observed.\n\nYou sit up in your bedroll and scan the tent. Nothing. The camp is quiet, the sentry's footsteps crunching a slow patrol outside. But the sensation lingers: a prickling awareness at the back of your skull, the kind of animal instinct that kept your ancestors alive in dark forests.\n\nYou step outside. The pre-dawn air is cold, but the feeling persists. It is not hostile. That is the strangest part. Whatever watches you does so with an attention that feels almost... appreciative. Like a connoisseur examining a vintage before deciding whether to drink.\n\n%randombrother% turns at your approach and stares for a beat too long before catching himself.%SPEECH_ON%Morning, captain. You look... rested.%SPEECH_OFF%He says it carefully, the way men speak when they mean something else entirely. You catch the way his eyes flick downward before he corrects himself. It is a look you have seen more and more often from the men. Less respect, more... appetite. Your authority as captain sits on thinner ice with each passing week, and everyone in the company can feel it.\n\nYou nod and walk past.\n\nBy the fire, you catch your reflection in a water pail. Your eyes seem brighter than usual. For a moment, just a flicker, you thought you saw a second reflection behind yours. Something pale and translucent, watching from just over your shoulder.\n\nYou turn. Nothing there. Only the fading stars and the cold breath of morning.\n\nThe sensation fades as the sun crests the hills. By the time camp breaks, you feel normal again. But somewhere beneath your ribs, a faint warmth lingers. Patient. Waiting. As though something ancient has taken notice of you and has not yet decided what to do about it.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Something is watching you.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				_event.m.Woman.getFlags().set("lewdEtherealFirstFired", true);
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		local climaxes = this.m.Woman == null ? 0
			: this.m.Woman.getFlags().getAsInt("lewdPartnerClimaxes") + this.m.Woman.getFlags().getAsInt("lewdSelfClimaxes");

		if (this.m.Woman == null
			|| this.m.Woman.getFlags().has("lewdEtherealFirstFired")
			|| ::Lewd.Mastery.getLewdTier(this.m.Woman) < 2
			|| climaxes < ::Lewd.Const.EtherealFirstEventThreshold
			|| this.World.Flags.getAsInt("lewdEtherealQuestStage") >= 1)
		{
			this.m.Score = 0;
		} else {
			this.m.Score = ::Lewd.Const.EtherealFirstEventBaseScore + climaxes * 10;
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
