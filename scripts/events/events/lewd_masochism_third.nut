this.lewd_masochism_third <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		Hazeem = null,
	},
	function create()
	{
		this.m.ID = "event.lewd_masochism_third";
		this.m.Title = "Yielding of the Jewel";
		// never fire this event again, as it is a one time thing
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/masochism_3_1.png[/img]A pair of Hazeem’s silent servants appear at the edge of your camp at dusk. They bow low and speak in unison, their voices flat and rehearsed. %SPEECH_ON%The master has an estate within the city walls. He bids his jewel come alone tonight. He has prepared additional gifts that will complete her.%SPEECH_OFF% You do not hesitate. You rise, the familiar weight of the nose and lip rings tugging with every breath, and follow them through the darkening streets. This estate is even more lavish than the last. High walls, torch-lit gardens, and slaves who keep their eyes on the ground.\n\nYou are led through marble halls until the servants open a heavy door and step aside. Hazeem waits inside, reclining on a low couch, crimson silk robes open at the chest. The room is lit by dozens of candles. Mirrors line the walls so you see yourself from every angle: porcelain skin, painted lips, the two gold rings already branding your face.\n\nHe smiles when he sees you. It is not the polite smile of the road. It is the smile of a man who knows his property has returned on its own. %SPEECH_ON%My jewel, you came. Good. Strip and kneel. I want to see what I have made of you.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Obey.",
					function getResult( _event )
					{
						// after testing followup events remove this and go through the combat
						return "B";
					}
				},
				{
					Text = "Run away, scared of your own desires.",
					function getResult( _event )
					{
						return 0;
					}
				}
			]
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Hazeem.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "You obey without a word. Armor and clothing fall away until you are naked. You sink to your knees on the thick carpet, then bend forward at the waist, forearms resting on the floor, ass raised, back arched. The position is humiliating and perfect. Your breasts hang heavy, nipples already stiff with anticipation.\n\nHazeem rises and circles you slowly. He runs a hand down your spine, then cups one breast and squeezes. %SPEECH_ON%These were once the breasts of a warrior. Now they are mine. Tonight I finish what I started.%SPEECH_OFF% He brings a small golden tray. Two heavy gold vaguely phallic looking ornaments rest on it, each set with a dangling sapphire. The shafts are thick, the tips flared. Next to them are needles yet again, but these ones are much thicker than the ones before and flare taper out gradually.%SPEECH_ON%Tonight I claim your breasts. You surely have pleasured yourself, yes? I have plenty of women to experiment on. And your nipples? They will feel like they are constantly getting fucked. You will never forget who owns you after this.%SPEECH_OFF%He brandishes one thick needle, more a wedge than a piercing instrument. With his other hand, he tweaks one of your already-hard nipples, bringing his face towards them to suckle on them. His treatment is cruel and callous, mixing in bites with his invading tongue.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Surrender.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Hazeem.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/masochism_3_3.png[/img]While harassing your nipple, he slides the tip of the needle around, feeling for a divot near the apex of your nipple. If you were to become a mother, this would be where your milk would spring from. Finding it, he twists the middle, spinning it and applying pressure so it slides in a little at a time, wedging itself inside you. This goes beyond getting fucked - a new hole, which he fills immediately, is being created in your body. Vulnerability at this level mixes with the intense pain from being penetrated by a steel rod, and you find yourself... Enjoying it. The complete desecration of your body and dignity, the remodeling of your breasts as meat. You enjoy being humiliated, owned, and abused.\n\nAfter what seems like an eternity, he retracts the rod, with your nipple now feeling the bite of a light breeze and the sensation of emptiness. He brings one of the phallic objects forward. %SPEECH_ON%Like jewels need to be cut and polished, the piercings and these plugs will do that for you.%SPEECH_OFF%He slowly but inexorably inserts the plug inside you. Pain explodes, bright and deep. You moan openly, hips twitching. Your core clenches, wetness dripping down your thighs. He slides it all the way in, so that the flat end on the other side rests against your breast like a cap. The weight settles instantly, pulling your nipples downward. You shudder through a small orgasm, forehead pressed to the carpet.\n\n Hazeem chuckles, low and satisfied. %SPEECH_ON%Look at you. My other slaves fear the whip. They cry and beg when I hurt them. But you? You seek it. You come running for it. You are more enslaved to my cruelty than any of them ever were.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let go.",
					function getResult( _event )
					{
						return "D";
					}
				},
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Hazeem.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "D",
			Text = "He repeats his minstrations on your other nipple, ensuring you are thoroughly filled. He then moves behind you. You hear the rustle of silk, then feel the blunt head of his cock press against your soaked entrance. He grips your hips and thrusts in deep, burying himself in one stroke. You cry out, the new plugs swaying heavily with the impact.\n\nHe fucks you hard and steady, one hand tangled in your hair, the other cracking across your ass in sharp, rhythmic spanks. Each slap sends fresh fire through your skin and straight to your clit. The plugs tug and bounce with every thrust, the flared heads biting deeper inside your nipples. %SPEECH_ON%That’s it, take it. Feel how thoroughly I\'ve conquered you. You are my bitch. They fight the pain. You beg for it. You live for it.%SPEECH_OFF%He spanks you harder, the slaps echoing off the mirrored walls. Your moans turn into broken whimpers. The pain from your nipples, the sting on your ass, the relentless stretch of his cock, all of it coils tight inside you until you shatter, clenching around him in a long, shuddering climax.\n\nHazeem pulls out at the last moment. He strokes himself twice and unloads onto your still-twitching slits.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Become his.",
					function getResult( _event )
					{
						return "E";
					}
				},
			],
			function start( _event )
			{
				local w = _event.m.Woman;
				local skills = w.getSkills();
				skills.removeByID("trait.masochism_second");
				{
					local skill = this.new("scripts/skills/traits/masochism_third");
					skills.add(skill);
					this.List.push({
						id = 11,
						icon = skill.getIcon(),
						text = w.getName() + " now a " + skill.getName()
					});
				}

				// reset for next event
				w.getFlags().set("totalDamageTaken", 0);


				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Hazeem.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "E",
			Text = "%SPEECH_ON%Wear them proudly, my jewel. Every tug, every sway, every time they catch on your armor, you will remember who owns you now.%SPEECH_OFF% You rise on shaky legs. The plugs are heavy and sensitive, every breath pulling at them. Your ass burns from the spanking. Your face and body are flushed and marked.\n\nYou leave the estate without looking back. The walk to camp is slow and deliberate. Every step makes the plugs sway and tug. Every breath reminds you of what you have given him.\n\nYour brothers see you return. They notice the new weight beneath your tunic, the way you move, the fresh flush on your skin. No one speaks, but from their eyes you can tell you has lost what respect they had remaining for you.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Return to your camp.",
					function getResult( _event )
					{
						return 0;
					}
				},
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if ( bro == _event.m.Woman)
					{
						continue;
					}
					local entry = ::Legends.EventList.changeMood(bro, -1.0, "Captain has been claimed by Hazeem");
					if (bro.getMoodState() < this.Const.MoodState.Neutral)
					{
						this.List.push(entry);
					}
				}

				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		// only fire for those that have the delicate trait / gotten the heels
		if (this.m.Woman == null || !this.m.Woman.getSkills().hasSkill("trait.masochism_second") || !::Lewd.Location.closeToSouthernTown())
		{
			this.m.Score = 0;
		} else {

			// bonus if you're in the south (more slaves / slavers / dark skinned people)
			// track how much HP you've lost in total
			this.m.Score = this.m.Woman.getFlags().getAsInt("totalDamageTaken") * ::Lewd.Const.MasochismDamageTakenMultScore;
		}
	}

	function onPrepare()
	{
		// find a male character to be the one that Hazeem talks to
		local brothers = this.World.getPlayerRoster().getAll();
		this.m.Hazeem = this.World.getGuestRoster().create("scripts/entity/tactical/humans/hazeem");
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
		this.m.Hazeem = null;
		this.World.getGuestRoster().clear();
	}

});

