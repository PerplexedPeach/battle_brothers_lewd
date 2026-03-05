this.lewd_ethereal_second <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_ethereal_second";
		this.m.Title = "The Hunger Beneath";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/ethereal_2_1.png[/img]It has been getting worse. Or better, depending on how you look at it.\n\nEvery battle now leaves you restless in ways that steel and victory never used to. The rush of combat mingles with something deeper: a thrumming heat that builds whenever you are close to men, whenever you feel their breath quicken, whenever you sense their desire cresting like a wave about to break. And when they break, when the enemies you've seduced on the battlefield shudder and lose themselves to climax, something inside you drinks deep.\n\nYou feel it now, sitting cross-legged in your tent as night falls. That warmth beneath your skin is no longer subtle. It pulses with its own rhythm, independent of your heartbeat, as though a second heart has kindled in your belly. Your skin shimmers faintly in the lamplight. Not the oily sheen of sweat, but something internal, a soft, rosy luminescence that outlines the contours of your collarbones, the curve of your breasts, the hollow of your throat.\n\nYou hold your hand before the lamp and watch the light pass through your fingers. The flesh is almost translucent at the edges, veins glowing faintly rose-gold. Beautiful. Alien.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Examine yourself further.",
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
			Text = "You strip and stand before the small camp mirror. The changes are undeniable now.\n\nYour body, already remade by Qingde's unguent and the seed of his servants, has continued its transformation without their help. Your waist has narrowed further. Your hips flare with a pronounced curve that makes your silhouette look less like a warrior and more like something painted on a temple wall. A fertility spirit. A fox demon from southern folklore. Your skin is flawless beyond what alchemy should allow: no pores, no blemishes, a seamless porcelain that radiates faint warmth to the touch.\n\nBut it is your eyes that arrest you. The irises have darkened, pupils now permanently dilated into wide, inviting pools that seem to swallow light. When you tilt your head, you catch a fleeting glint, something iridescent, like the sheen on a dragonfly's wing. It vanishes when you look straight on.\n\nYou press a finger to your lower lip. The crimson lacquer Qingde's servants painted there has not faded, but it no longer looks like lacquer. It looks natural, as though your lips simply are that color now. Wine-dark, perpetually flushed, perpetually inviting.\n\nA sound outside the tent flap. %randombrother% clears his throat.%SPEECH_ON%Captain? The lads are asking if you're... well. You've been in there a while. Some of them say they can smell something. Like... flowers. And something else.%SPEECH_OFF%He trails off, embarrassed. You know what the something else is. You can smell it too: your own arousal, amplified and sweetened into something that no longer smells human. It smells like a lure.\n\nYou dress and step out. Every man within ten paces turns. Not because you command attention, you do, you always have, but because something in their hindbrain screams at them to look, to want, to approach. Two brothers nearest the fire shift uncomfortably, and you feel it: the faint pull of their desire, like threads connecting their chests to yours. When one of them swallows hard, his throat bobbing, a tiny spark of warmth flares in your belly as though you've been fed.\n\nYou are feeding on them. Not their bodies. Their want.\n\nThe realization should frighten you. Instead, it sends a slow, liquid thrill down your spine. You smile, and watch three men lose their train of thought simultaneously.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You are becoming something more than human.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());

				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "You feel the warmth growing stronger with each partner you bring to climax."
				});
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		if (this.m.Woman == null
			|| ::Lewd.Mastery.getLewdTier(this.m.Woman) < 2
			|| this.m.Woman.getFlags().getAsInt("lewdPartnerClimaxes") < ::Lewd.Const.EtherealSecondEventThreshold)
		{
			this.m.Score = 0;
		} else {
			local climaxes = this.m.Woman.getFlags().getAsInt("lewdPartnerClimaxes");
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
