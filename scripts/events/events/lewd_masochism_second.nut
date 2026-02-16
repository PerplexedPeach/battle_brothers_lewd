this.lewd_masochism_second <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		Hazeem = null,
	},
	function create()
	{
		this.m.ID = "event.lewd_masochism_second";
		this.m.Title = "Seal of the Lips";
		// never fire this event again, as it is a one time thing
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/masochism_2_1.png[/img]The company lodges in the outskirts of the southern city. Recently you\'ve waded into battle and your procelain skin has been marked with fresh bruises. The pain has long since stopped being punishment. Now it is a constant, low fire that keeps you wet and restless, sharpening your senses even as it weakens your stance. You have come to welcome the ache.\n\nWord spreads quickly of your arrival; it seems you have developed a reputation of sorts. A tall ebony-skinned man in crimson silk approaches your camp at dusk, flanked by two silent bodyguards. Hazeem. He carries himself with the easy arrogance of a man who owns the ground he walks on.\n\nHe bows once, shallow, then straightens and addresses you directly. His eyes linger on the golden nose ring, then drop to the sway of your hips forced by the heels.%SPEECH_ON%Captain, I heard you passed through my city. After our last meeting I could not rest easy. You saved my life on the road. Now that I am home, allow me to thank you properly. My pavilion is not far. Come. I have prepared a gift worthy of your unique grace.%SPEECH_OFF% ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Accept his invitation.",
					function getResult( _event )
					{
						return "B";
					}
				},
				{
					Text = "Decline his invitation.",
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
			Text = "Seeing no reason to refuse this invitation, the party follows the magnate to his estate. It sits on a hill, overlooking much of the city. Tall gates separate it from the world outside it, with a rare oasis-garden hidden in its confines. Slaves tend to the garden, filled with lush flowers and rare fruits. You follow Hazeem, his imposing back dominating your view, to the steps of his house, your heels clacking along the paved road. You enter behind him, but guards at the door bar the rest of your company from entering.%SPEECH_ON%It\'s fine, just enjoy the garden out here.%SPEECH_OFF%The inside of his house is well decorated by slave dancers and performers of all kinds in addition to furniture. Some have angry red markings on their back, perhaps a hint of why Hazeem had trouble with his slaves earlier.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Enter the pavilion.",
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
			Text = "The pavilion is opulent: heavy silk drapes, low cushions, incense thick with musk and myrrh. Hazeem dismisses his guards with a flick of his wrist. The two of you are alone.\n\nHe gestures to a velvet tray. A single golden ring rests there, wider than the one in your nostril, thicker, heavier. The metal gleams with the same serpentine etchings. He lifts it between thumb and forefinger.%SPEECH_ON%This one is for the lower lip. In my lands it marks a woman who understands her mouth’s true purpose. No more barking orders. Only soft words, soft service. It will suit you perfectly.%SPEECH_OFF%You feel heat flood your cheeks. The nose ring and ballet heels have already trained you to crave the sting, the weight, the visible proof of surrender. The thought of another mark, one that tugs every time you speak or swallow, makes your thighs slick. You open your lips as if proffering it up as an offering.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Accept his gift.",
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
			Text = "[img]gfx/ui/events/masochism_2_3.png[/img]Hazeem’s smile is slow and victorious. He steps close and grips your chin firmly, tilting your head back so you must look up at him. The position forces your lips to part slightly. He heats the needle over a small brazier. The metal glows. He command.%SPEECH_ON%Open wider.%SPEECH_OFF%You obey. The needle pierces the soft flesh of your lower lip in one clean thrust. Pain blooms sharp and bright, a white-hot echo of the heels’ constant bite. You gasp, the sound muffled, your body clenching involuntarily. Wetness gathers between your legs, immediate and shameless. The sting settles into a throbbing warmth that pulses in time with your heartbeat.\n\nHazeem threads the thicker gold ring through and twists it shut. The weight is noticeable, heavier than the nose ring, pulling downward with every breath. He admires his work for a moment, then releases your chin.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Feel the new weight on your lip.",
					function getResult( _event )
					{
						return "E";
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
			ID = "E",
			Text = "%SPEECH_ON%Now, let me see how well it suits you.%SPEECH_OFF%Without another word he unfastens his robes. His cock springs free, thick and dark, already hard. You had heard rumors about men of his ethnicity and they seem to have some weight. He does not ask. He simply rests one hand on the back of your head and guides you down. \n\nYou sink to your knees without resistance. You open your painted lips. The new ring tugs as your mouth stretches around him. You take him deep, tongue swirling, cheeks hollowing. He groans once, fingers tightening in your hair, controlling the rhythm.\n\nYou work him eagerly, the ring catches on his shaft with every bob of your head, sending fresh sparks through your lip and straight to your clit. You imagine yourself in his caravan, both rings chained, mouth kept busy, heels locked, body marked and used. The fantasy pushes you closer to the edge.\n\nHazeem’s breath quickens. He pulls out at the last moment, stroking himself once, twice. Thick ropes of cum splash across your painted lips, coating the new gold ring, dripping down your chin. The heat of it mingles with the lingering sting of the piercing. You feel obscene, claimed, perfect.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let his seed seep into your skin.",
					function getResult( _event )
					{
						return "F";
					}
				},
			],
			function start( _event )
			{
				local w = _event.m.Woman;
				local skills = w.getSkills();
				skills.removeByID("trait.masochism_first");
				{
					local skill = this.new("scripts/skills/traits/masochism_second");
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
			ID = "F",
			Text = "He steps back, tucking himself away, breathing steady again.%SPEECH_ON%There, now your mouth matches the promise of your stride. The next gift will be deeper.%SPEECH_OFF% You rise slowly with the help of your arms, the lip ring heavy and slick with his release. Every swallow tugs it. Every breath reminds you of what you have allowed. You leave the pavilion without a word. Your brothers are waiting outside. They stare at the fresh gold glint on your lower lip, at the faint sheen still clinging to it. No one speaks. The craving has grown teeth.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lick the rest of his seed from your lips.",
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
					local entry = ::Legends.EventList.changeMood(bro, -0.5, "Captain has sunk to new lows");
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
		if (this.m.Woman == null || !this.m.Woman.getSkills().hasSkill("trait.masochism_first") || !::Lewd.Location.closeToSouthernTown())
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

