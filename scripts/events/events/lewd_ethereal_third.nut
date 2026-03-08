this.lewd_ethereal_third <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_ethereal_third";
		this.m.Title = "Reincarnation of Daji";
		// Shorter cooldown so it can re-trigger if rejected
		this.m.Cooldown = 7 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "It happens without warning.\n\nYou are sitting by the fire, cleaning your blade, when the warmth that has been building for weeks suddenly ignites. Not painfully. The opposite. A wave of liquid heat rolls outward from your core, cascading through your limbs like molten honey. Your fingers go slack; the blade clatters to the ground. Your back arches involuntarily and a soft, breathy moan escapes your parted lips before you can catch it.\n\nEvery man in camp freezes. The fire seems to dim, or perhaps your skin has begun to glow brighter than its flames.\n\nYou stagger to your feet, the ballet heels driving their familiar spikes of pain through your arches, but even that sensation transforms instantly into something exquisite, something that feeds the growing conflagration rather than competing with it. Your hands tremble as you raise them before your face. The luminescence you first noticed weeks ago is now unmistakable: a soft, rose-gold radiance emanating from beneath your skin, pulsing with each heartbeat, tracing the architecture of your veins like rivers of light.\n\n%randombrother% drops his bowl, stew splashing unheeded. His mouth works, but no words come.\n\nThe heat intensifies. You feel every climax you have drawn from others, dozens upon dozens, crystallizing inside you like facets of a jewel being cut. Each one a spark of stolen essence, of desire consumed and transmuted. They have been accumulating in silence, patient seeds waiting for this moment to bloom.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Surrender to the transformation.",
					function getResult( _event )
					{
						return "B";
					}
				},
				{
					Text = "Fight it. Hold on to what you are.",
					function getResult( _event )
					{
						return "E";
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
			Text = "You stop resisting.\n\nThe moment you let go, the warmth becomes a torrent. It pours through you with the force of a river breaching a dam, rewriting everything it touches. You sink to your knees on the packed earth, head thrown back, mouth open in a silent cry that is equal parts agony and ecstasy.\n\nYour skin blazes with light. The porcelain complexion Qingde's rituals gave you refines itself further, no longer just flawless but luminous, as though moonlight has been woven into the cells themselves. It takes on a faint pearlescent quality, shifting between ivory and the palest rose depending on the angle, the way silk catches different hues. Your features sharpen and soften simultaneously: cheekbones higher, jawline more delicate, lips darkening from crimson to a deep, wine-stained burgundy that seems to promise sin with every curve.\n\nYour eyes undergo the most dramatic change. The irises lighten, darkened pupils contracting as the surrounding color shifts to a luminous amber-gold ringed with violet. Fox eyes, the southerners would call them, the mark of spirits that seduce mortals in their sleep. They catch the firelight and throw it back with an unnatural gleam, as though lit from within.\n\nYour hair moves of its own accord, rippling in a wind that doesn't exist, settling into a silken curtain that frames your transformed face. Where it catches the light, deep indigo highlights shimmer through the black.\n\nThe brothers cannot look away. Cannot speak. Cannot think. Three nearest the fire have risen to their feet without realizing it, drawn forward by something older than reason.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rise, transformed.",
					function getResult( _event )
					{
						return "C";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});

		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/ethereal_3_2.png[/img]You rise. The motion is effortless, impossibly graceful, your body moving with a fluidity that belongs to water, not flesh. Even the ballet heels, those instruments of permanent torment, feel different now. The pain is still there, sharp and real, but your body processes it as fuel rather than suffering, converting every spike of agony into a subtle pulse of radiance.\n\nYou stand before the fire, and the flames lean toward you. Not metaphorically. The actual flames bend in your direction, as though drawn by gravity. One of the brothers takes a step back, hand fumbling for a ward sign he half-remembers from childhood.\n\nYou exhale slowly. With the breath, something releases from your skin. Not quite scent, not quite light, but a presence that fills the air like incense. You feel each man's awareness of you as a physical thing: threads of desire connecting their bodies to yours, each one a tiny tributary feeding the river of warmth that now flows perpetually through your core.\n\nYou are no longer merely beautiful. You are a gravitational force. A lure made flesh. Something that the old stories warned about in hushed tones: fox spirits that could topple dynasties with a smile, temple demons that fed on mortal desire until they transcended mortality entirely.\n\nYou understand now what has happened. The unguent was the seed. The rituals were the soil. But the true catalyst was the desire you have drawn from others, every shuddering climax, every broken moan, every moment a man lost himself inside pleasure you orchestrated. Each one fed something growing inside you, and now it has blossomed into something that is no longer entirely human.\n\n%randombrother% finally finds his voice, cracked and awed.%SPEECH_ON%Captain... what in the gods' names are you?%SPEECH_OFF%\n\nYou turn to him. Your fox-gold eyes meet his, and you feel his knees weaken from across the camp. A smile curves your wine-dark lips. Slow, knowing, ancient in a way that doesn't match the young woman who first buckled on those heels.\n\n%SPEECH_ON%Still your captain.%SPEECH_OFF% Your voice has changed too. Deeper, smoother, carrying harmonics that vibrate in the chest rather than the ears. %SPEECH_ON%Still yours. For now.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Embrace your new nature.",
					function getResult( _event )
					{
						return "D";
					}
				}
			],
			function start( _event )
			{
				local w = _event.m.Woman;
				local skills = w.getSkills();

				// Remove Delicate, add Ethereal
				if (skills.hasSkill("trait.delicate"))
				{
					local oldSkill = skills.getSkillByID("trait.delicate");
					skills.removeByID("trait.delicate");
					this.List.push({
						id = 12,
						icon = oldSkill.getIcon(),
						text = w.getName() + " is no longer " + oldSkill.getName()
					});
				}

				local skill = this.new("scripts/skills/traits/ethereal_trait");
				skills.add(skill);
				this.List.push({
					id = 11,
					icon = skill.getIcon(),
					text = w.getName() + " is now " + skill.getName()
				});

				this.Characters.push(w.getImagePath());
			}
		});

		this.m.Screens.push({
			ID = "D",
			Text = "The rest of the night is a blur of stares and whispered conversations that stop when you approach. Men invent reasons to walk past your tent, then forget what errand brought them once they catch a breath of the intoxicating presence you now exude. Two brothers get into a fistfight over who sits nearest to you at the morning meal, and neither can explain why afterward.\n\nYou let it wash over you. The warmth is constant now, not overwhelming, but present, like a hearth fire that never goes out. You can feel the camp's collective desire as a gentle current, feeding you without effort. It makes you feel powerful in a way that no victory in battle ever has. Not the power of a sword arm, but the power of something that draws swords toward it and makes them fall at its feet.\n\nYour reflection in the morning water confirms what you already know. The woman looking back is not the mercenary who accepted Qingde's first pair of heels. She is something else entirely. Ethereal, luminous, dangerous in the way that deep water is dangerous. Beautiful enough to start wars. Intoxicating enough to end them.\n\nThe company still follows you. The brothers are loyal, if newly terrified and hopelessly besotted. But you sense the shift in the balance: they no longer follow because you lead. They follow because they cannot bear to look away.\n\nSomewhere in the east, in a gilded palanquin, you imagine Qingde would smile. But this transformation was not his doing. It was yours, earned in sweat, seed, and stolen ecstasy on a hundred battlefields. The Emperor's jewel has outgrown its setting.\n\nYou stand, feeling the familiar bite of the heels that are now as much a part of you as bone, and address the company. Today, as every day, there is work to be done.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "March out. You have battles to win and men to break.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro == _event.m.Woman)
						continue;

					if (bro.getGender() == 0)
					{
						// Men are awed and besotted
						local entry = ::Legends.EventList.changeMood(bro, 2.0, "Captivated by your transformation");
						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
							this.List.push(entry);
					}
					else
					{
						// Women are unsettled
						local entry = ::Legends.EventList.changeMood(bro, -1.0, "Unsettled by your transformation");
						if (bro.getMoodState() < this.Const.MoodState.Neutral)
							this.List.push(entry);
					}
				}

				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});

		// Reject path: transformation delayed, not permanent
		this.m.Screens.push({
			ID = "E",
			Text = "You grit your teeth and clench your fists. The warmth surges, demanding release, demanding surrender, but you have spent a lifetime refusing to yield. To blades, to pain, to the expectations of men who see a woman and think prey.\n\nYou will not yield to this.\n\nThe effort is monumental. Sweat breaks across your brow, hot and stinging. Your skin blazes brighter for a heartbeat, the rose-gold light flaring to white, and then, with a shuddering exhale, it dims. The heat retreats, coiling back into your core like a serpent denied its strike. It does not leave. It merely waits.\n\nYou stagger, catching yourself on a supply crate. Your hands shake. Between your thighs, you are drenched, the physical echo of the transformation your body tried to undergo. Your breath comes in ragged gasps that sound uncomfortably like the moans you stifled.\n\n%randombrother% approaches cautiously, hand extended but not quite touching.%SPEECH_ON%Captain? You alright? You were... glowing.%SPEECH_OFF%\n\n%SPEECH_ON%I'm fine.%SPEECH_OFF% Your voice is steady, if breathless. %SPEECH_ON%Bad dream. Go back to your post.%SPEECH_OFF%\n\nHe nods, unconvinced, and retreats. You straighten slowly, smoothing your tunic with trembling fingers. The warmth pulses once, petulant, then settles.\n\nYou have held it at bay. But you know, with the certainty of someone who has felt the tide, that it will come again. Stronger each time. The essence of every partner you have brought to climax still accumulates, still crystallizes, still pushes toward a critical mass that your will alone may not be able to contain forever.\n\nFor now, though, you are still you. Mostly.\n\n[The transformation has been delayed. It will attempt again as you continue to bring partners to climax on the battlefield.]",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Steel yourself. You are still in control.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
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
			|| ::Lewd.Mastery.getLewdTier(this.m.Woman) != 2
			|| climaxes < ::Lewd.Const.EtherealThirdEventThreshold)
		{
			this.m.Score = 0;
		} else {
			this.m.Score = ::Lewd.Const.EtherealThirdEventBaseScore + climaxes * 10;
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
