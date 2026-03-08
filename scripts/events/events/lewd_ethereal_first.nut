this.lewd_ethereal_first <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_ethereal_first";
		this.m.Title = "Strange Warmth";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/ethereal_1_1.png[/img]You wake before dawn, skin damp with sweat that carries a scent you don't recognize. Not the usual campfire smoke and leather, but something floral, almost intoxicating, like night-blooming jasmine crushed between warm fingers. Your body hums with a low, pleasant vibration that has nothing to do with dreams. You press a palm to your sternum and feel heat radiating outward, pulsing faintly in time with your heartbeat.\n\nSitting up in your bedroll, you notice a faint luminescence on the backs of your hands. It fades when you blink, like afterimages of lightning. You flex your fingers. The porcelain skin Qingde's rituals gave you looks... different. Smoother, if that were possible. The veins beneath have taken on a faintly rosy hue, as though something warmer than blood flows through them.\n\nYou step outside the tent. The pre-dawn air is cold, but you barely feel it. A sentry, %randombrother%, turns at your approach and stares for a beat too long before catching himself.%SPEECH_ON%Morning, captain. You look... rested.%SPEECH_OFF%He says it carefully, the way men speak when they mean something else entirely. You nod and walk past. Each step in your heels sends the familiar ache through your arches, but tonight even that pain feels different. Sharper, more alive, feeding something deep in your core rather than merely hurting.\n\nBy the fire, you catch your reflection in a water pail. Your eyes seem brighter, pupils dilated in a way that has nothing to do with the dim light. Your lips, still lacquered crimson, look fuller than yesterday. You touch them and a shiver runs through you, electric, originating from somewhere far south of your mouth.\n\nThe sensation fades as the sun crests the hills. By the time camp breaks, you feel normal again, or close enough. But somewhere beneath your ribs, that strange warmth lingers, patient and growing.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Something is changing inside you.",
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
			|| climaxes < ::Lewd.Const.EtherealFirstEventThreshold)
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
