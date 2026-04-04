// Spider egg hatching event -- fires programmatically from spider_eggs_effect
// when DaysLeft reaches 0. Uses a queue so multiple characters hatching on the
// same day are shown in sequence within a single event invocation.
this.lewd_spider_eggs_hatch <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		EggCount = 0,
		Queue = []
	},
	function create()
	{
		this.m.ID = "event.lewd_spider_eggs_hatch";
		this.m.Title = "The Brood";
		this.m.Cooldown = 1 * this.World.getTime().SecondsPerDay;

		// Screen A: Universal onset (first character only)
		this.m.Screens.push({
			ID = "A",
			Text = "It begins in the gray hours before dawn, a deep stirring beneath your navel that drags you out of sleep. You lie rigid in your bedroll, one hand pressed flat against your stomach, and feel them move. The spider eggs. They have grown heavier with each passing day, a constant pressure lodged in muscles never meant to bear such weight, and now something has changed. The stirring is rhythmic, purposeful, and your body has begun to answer it with a warmth that catches you off guard.\n\nYou clench your jaw, rise on unsteady legs, and slip past the banked campfire into the undergrowth beyond the tents. Your skin is flushed despite the cold air. Whatever is about to happen, you would rather face it alone.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Brace yourself.",
					function getResult( _event )
					{
						if (_event.m.EggCount >= 11)
							return "Swarm";
						else if (_event.m.EggCount >= 5)
							return "Many";
						return "Few";
					}
				}
			],
			function start( _event )
			{
				if (_event.m.Queue.len() > 0)
				{
					local entry = _event.m.Queue[0];
					_event.m.Woman = entry.actor;
					_event.m.EggCount = entry.eggCount;
				}
				if (_event.m.Woman != null)
					this.Characters.push(_event.m.Woman.getImagePath());
			}
		});

		// Screen Continue: Subsequent characters
		this.m.Screens.push({
			ID = "Continue",
			Text = "You barely have time to compose yourself before you notice %woman% slipping past the campfire toward the same stretch of undergrowth, one arm wrapped tight around her middle. The same hunted look you wore minutes ago. The eggs inside her have chosen the same hour to stir.\n\nShe does not notice you at first. When she does, neither of you speaks. There is nothing to say that the body is not already saying for you both.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Brace yourself.",
					function getResult( _event )
					{
						if (_event.m.EggCount >= 11)
							return "Swarm";
						else if (_event.m.EggCount >= 5)
							return "Many";
						return "Few";
					}
				}
			],
			function start( _event )
			{
				if (_event.m.Queue.len() > 0)
				{
					local entry = _event.m.Queue[0];
					_event.m.Woman = entry.actor;
					_event.m.EggCount = entry.eggCount;
				}
				if (_event.m.Woman != null)
					this.Characters.push(_event.m.Woman.getImagePath());
			}
		});

		// Screen Few: <5 eggs
		this.m.Screens.push({
			ID = "Few",
			Text = "The first sac passes with a shudder that drops you to your knees. It is smaller than you feared, wrapped in pale gossamer and warm against the cold grass, and the sensation of its passage is not what you expected. The cramping crests and breaks into something else entirely, a slow rolling heat that blooms outward from your core and leaves you gasping for reasons that have nothing to do with pain.\n\nA second follows within minutes, then a third, each one drawing that same bewildering response from your body. Your fingers dig into the earth, your back arches, and by the time the last sac slides free you are trembling from head to toe, breath ragged, skin damp with sweat and something warmer. The climax takes you by surprise, wringing a strangled sound from your throat that you muffle against your forearm.\n\nYou kneel in the predawn cold for a long time afterward, pulse hammering, a small clutch of silk-wrapped sacs glowing faintly at your feet. You gather them with unsteady hands and tuck them into your pack.\n\nWhen you return to camp your legs are still shaking. You blame it on the cold.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You are not entirely sure what just happened.",
					function getResult( _event )
					{
						_event.m.Queue.remove(0);
						if (_event.m.Queue.len() > 0)
							return "Continue";
						return 0;
					}
				}
			],
			function start( _event )
			{
				local w = _event.m.Woman;
				if (w == null) return;

				this.Characters.push(w.getImagePath());
				this.List.push(::Legends.EventList.changeMood(w, 1.0, "Unexpected release"));
				this.List.push({
					id = 10,
					icon = "skills/lewd_spider_eggs.png",
					text = "Received spider egg sac containing " + _event.m.EggCount + " egg" + (_event.m.EggCount != 1 ? "s" : "")
				});

				if (_event.m.Queue.len() > 1)
					this.Options[0].Text = "Before you can steady yourself, another stirs.";
			}
		});

		// Screen Many: 5-10 eggs
		this.m.Screens.push({
			ID = "Many",
			Text = "The first sac draws a gasp from your throat before you can stifle it. You brace yourself against the base of a tree and wait for pain that does not come. Instead there is pressure, intense and rhythmic, and beneath it a mounting heat that spreads from your pelvis in slow waves. Another sac follows, then a third, each one stoking the warmth higher, and you realize with a flush of alarm that your body is not suffering through this. It is responding to it.\n\nYou lose count somewhere past the fifth. The process blurs into a rhythm that your conscious mind can only observe, not control. Pressure builds, crests, breaks into shuddering release, then builds again. Your thighs tremble. Your breath comes in hitches that you cannot keep quiet. The silk-wrapped sacs accumulate between your knees, faintly glowing, but you have stopped watching them. Your eyes are closed, your forehead pressed to the rough bark, and every nerve you possess is occupied elsewhere.\n\nThe climax, when it arrives, is not singular. It rolls through you in waves that match the cadence of the sacs, each peak sharper than the last, until you are left shaking and spent against the tree with your nails gouged into the bark and no clear sense of how long it lasted.\n\nBy the time you limp back to camp, %randombrother% is already awake, feeding sticks to the fire.%SPEECH_ON%You're flushed. Fever?%SPEECH_OFF%You shake your head and lower yourself carefully onto a log. Your legs are still trembling and you do not trust your voice to sound normal.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Your legs are still shaking.",
					function getResult( _event )
					{
						_event.m.Queue.remove(0);
						if (_event.m.Queue.len() > 0)
							return "Continue";
						return 0;
					}
				}
			],
			function start( _event )
			{
				local w = _event.m.Woman;
				if (w == null) return;

				this.Characters.push(w.getImagePath());
				this.List.push(::Legends.EventList.changeMood(w, 1.5, "Overwhelmed with sensation"));
				this.List.push({
					id = 10,
					icon = "skills/lewd_spider_eggs.png",
					text = "Received spider egg sac containing " + _event.m.EggCount + " eggs"
				});

				if (_event.m.Queue.len() > 1)
					this.Options[0].Text = "Before you can steady yourself, another stirs.";
			}
		});

		// Screen Swarm: 11+ eggs
		this.m.Screens.push({
			ID = "Swarm",
			Text = "The first wave rolls through you and your knees buckle. Before you can catch your breath another follows, then another, each one deeper and more insistent, and with each wave comes a heat so intense it blurs the line between agony and something far more dangerous. You try to keep quiet. A sound escapes your throat anyway, low and helpless, and you bury your face in your arms.\n\nThe process consumes the better part of the night. Wave after wave, your body working through contractions that seem to originate from somewhere beyond conscious reach. Each sac that passes stokes the fire higher, each passage wringing sensation from nerve endings you did not know you had. You stop counting the sacs. You stop counting the climaxes. The two become indistinguishable, cresting and breaking in an endless tide that leaves you boneless and gasping in the crushed grass.\n\nA hand touches your shoulder. %randombrother% kneels beside you, their face drawn with concern, and you lack the strength or the coherence to wave them off.%SPEECH_ON%Crowns alive. Are you alright? How long have you been out here?%SPEECH_OFF%You cannot form a reply. Another wave crests and your back arches involuntarily, your fingers clawing at the earth. They fall silent, one hand braced on your back, waiting it out alongside you.\n\nWhen it is finally over you lie curled on your side, wrapped in the blanket they brought, spent in every sense of the word. The pile of silk-wrapped sacs your body has produced is staggering, more than you can carry in both arms. You are trembling, dazed, and despite everything, suffused with a warm, ringing calm that feels entirely inappropriate for what just happened.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Close your eyes and let the stillness take you.",
					function getResult( _event )
					{
						_event.m.Queue.remove(0);
						if (_event.m.Queue.len() > 0)
							return "Continue";
						return 0;
					}
				}
			],
			function start( _event )
			{
				local w = _event.m.Woman;
				if (w == null) return;

				this.Characters.push(w.getImagePath());
				this.List.push(::Legends.EventList.changeMood(w, 2.0, "Lost in pleasure"));
				this.List.push({
					id = 10,
					icon = "skills/lewd_spider_eggs.png",
					text = "Received spider egg sac containing " + _event.m.EggCount + " eggs"
				});

				if (_event.m.Queue.len() > 1)
					this.Options[0].Text = "Before you can steady yourself, another stirs.";
			}
		});
	}

	function onUpdateScore()
	{
		// Programmatic only -- never fires from score system
		this.m.Score = 0;
	}

	function onPrepare()
	{
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
		this.m.EggCount = 0;
		this.m.Queue = [];
	}
});
