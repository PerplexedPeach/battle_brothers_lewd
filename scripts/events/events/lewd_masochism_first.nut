this.lewd_masochism_first <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		Male = null,
		Hazeem = null,
		Slaver = null,
	},
	function create()
	{
		this.m.ID = "event.lewd_masochism_first";
		this.m.Title = "Bonds of Pain";
		// never fire this event again, as it is a one time thing
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/masochism_1_1.png[/img]The clamor of chains and shouts pulls your company from the road's monotony. Up ahead, a cluster of ragged figures, dark-skinned southerners in tattered rags, surround a lone man sprawled in the dust. Surrounding him are the bodies of his presumable guards. He fights back with a curved dagger, but they are too many. Fists and improvised clubs rain down. Your brothers tense, hands on hilts, but you raise a hand. The man wears fine silks and gold rings that suggests he has more wealth than sense. It would be a shame to leave his wealth to leave the vultures, and he is not bad looking either...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rush to the man's aid.",
					function getResult( _event )
					{
						// TODO after testing followup events remove this and go through the combat
						return "Victory";

						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.OrientalBanditTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Slaves, 60, this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());

						_event.registerToShowAfterCombat("Victory", "null");
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}
				},
				{
					Text = "Don't get involved in such things.",
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
			ID = "Victory",
			Text = "Your company charges. The slaves scatter like rats under steel. A few fall to well-placed thrusts before the rest flee into the scrub. The man rises, brushing dust from his embroidered robes. His broad frame bears fresh bruises but remains unbroken. His skin gleams like polished ebony under the sun. His eyes are sharp and calculating beneath a turban of crimson silk.\n\nHe bows low, hand to heart, then straightens and addresses %male%, the tallest and most commanding of your brothers, assuming him to be the leader. %SPEECH_ON%By the dunes' grace, you have my life. I am Hazeem, trader of rarities from the sun-scorched south. Sometimes the merchandise becomes... Unruly. You have caught me at my low point. Please, name your reward.%SPEECH_OFF% His voice rolls like distant thunder, polite and warm, laced with an accent that curls around each word. %male% grunts and jerks his head toward you. %SPEECH_ON%Ask the captain. She's the one who called the charge.%SPEECH_OFF%Hazeem's gaze follows the gesture. His eyes widen slightly as they land on you, tracing the sway of your hips forced by the ballet heels, the delicate porcelain of your skin, and the crimson lacquer on your full lips. For a long moment he simply stares, then his mouth curves into a slow, appreciative smile. %SPEECH_ON%Ah. The jewel among the dogs of war.%SPEECH_OFF% He steps closer, ignoring the bristling of your company, his attention fixed entirely on you. %SPEECH_ON%I mistook you for one of my own stock, exotic beauty chained to serve rough men. In my lands, a creature so finely wrought would never hold steel. She would kneel in silk, adorned for pleasure, her every breath bought and paid for.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let him take a good look at you.",
					function getResult( _event )
					{
						return "B";
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
			ID = "B",
			Text = "He circles you once, openly appraising the mincing arch of your steps, the way the heels force your body into perpetual display.%SPEECH_ON%Such rarity does not lead. It is led. Tell me your price, Captain. I would buy you from these brutes and give you the life your form was made for.%SPEECH_OFF%The words land like a lash, casual and certain. Several brothers growl low, hands tightening on hilts. %male% spits into the dust. %SPEECH_ON%Watch your tongue, southerner.%SPEECH_OFF%Hazeem laughs, rich and unconcerned.%SPEECH_ON%Forgive me. Customs differ across sands. But beauty like yours begs to be cherished and adorned!%SPEECH_OFF%His eyes flick to the ballet heels, then back to your face.%SPEECH_ON%I have more to offer than coin. Jewels that could match your beauty! Please, accept my gifts.%SPEECH_OFF%He reaches into a pouch at his belt and produces a small velvet pouch. His fingers linger on something else, something metallic that glints briefly in the sun.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Invite him to your tent to take a closer look.",
					function getResult( _event )
					{
						return "C";
					}
				},
				// {
				// 	Text = "Decline his offer and tell him to leave.",
				// 	function getResult( _event )
				// 	{
				// 		return 0;
				// 	}
				// }
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Hazeem.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "C",
			Text = "You feel the familiar hum from your heels, that deep, throbbing pull in your arches that has long since stopped being mere pain. It has become a constant companion, a low fire that keeps you slick and restless by the end of every march. Curiosity, and perhaps something darker, stirs.%SPEECH_ON%Come to my tent,%SPEECH_OFF% you say, voice low and steady. %SPEECH_ON%Show me these gifts properly.%SPEECH_OFF%Hazeem's smile widens, a flash of teeth against dark skin. He follows without hesitation, his long strides easy where yours are forced into delicate, swaying steps. Your brothers watch him go with narrowed eyes, but none follow. Inside the tent the air is close, lit by a single lantern. He sets the pouch on the low table and opens it with deliberate care.\n\nA slender golden ring rests inside, etched with fine serpentine vines. He lifts it between thumb and forefinger, letting the light catch its gleam. %SPEECH_ON%This, would suit you perfectly. In my homeland we pierce the right nostril for women who carry hidden fire. It is a mark of elegance.%SPEECH_OFF%His tone is almost reverent, but the way he says 'hidden fire' carries an edge. His easy confidence and towering presence promises his dominance, and you feel heat rise in your cheeks, in your core.",
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
				{
					Text = "Thank him, but decline the gift.",
					function getResult( _event )
					{
						return 0;
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
			Text = "[img]gfx/ui/events/masochism_1_3.png[/img]%SPEECH_ON%Put it on me.%SPEECH_OFF%The words come out softer than you intend, almost a plea.\n\nHazeem steps close. His scent is sandalwood and sun-baked leather, masculine and overwhelming. He lifts your chin with two fingers, tilting your face upward. The touch is firm, possessive. You feel small beneath it, delicate, exactly as he sees you. Your breath catches. Wetness gathers between your thighs, unbidden and insistent.\n\nHe heats a thin needle over the lantern flame. The metal glows briefly. %SPEECH_ON%Hold still.%SPEECH_OFF% His voice drops lower, almost commanding. %SPEECH_ON%Pain is only the door. What comes after is sweeter.%SPEECH_OFF%The needle pierces the soft cartilage of your right nostril in one clean motion. A bright, stinging bloom of pain flares through you, sharp and clean. It echoes the deep bite of your heels, but higher, more intimate. You gasp, lips parting. The sting settles into a throbbing warmth that pulses in time with your heartbeat, sending fresh slickness down your inner thighs.\n\nYou imagine yourself kneeling in his caravan, gold chains linking your new ring to others, your body marked and claimed, no longer captain but prize. The fantasy floods you with heat. Your core clenches around nothing. Hazeem threads the ring through with steady hands and twists it shut. The weight settles immediately, a small, constant tug with every breath.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Accept the nose ring.",
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
			Text = "%SPEECH_ON%There, now you wear the south's mark. It suits you. Perhaps one day you will wear more.%SPEECH_OFF% He steps back, eyes dark with satisfaction. You sit there, ring glinting, body humming with pain-turned-pleasure, the fantasy of chains and ownership still vivid in your mind.\n\nYou thank him for the gift. Your voice is breathier than before. He smiles, certain you will meet again.\n\nOutside the tent, the sun is lower. Your brothers wait, eyes flicking to the new golden glint in your nostril. None ask. They do not need to. The air between you has changed.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get used to the new weight on your face.",
					function getResult( _event )
					{
						return 0;
					}
				},
			],
			function start( _event )
			{
				local w = _event.m.Woman;
				local skills = w.getSkills();
				{
					local skill = this.new("scripts/skills/traits/masochism_first");
					skills.add(skill);
					this.List.push({
						id = 11,
						icon = skill.getIcon(),
						text = w.getName() + " now " + skill.getName()
					});
				}

				// reset for next event
				w.getFlags().set("totalDamageTaken", 0);

				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Hazeem.getImagePath());
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		// only fire for those that have the delicate trait / gotten the heels
		if (this.m.Woman == null || !this.m.Woman.getSkills().hasSkill("trait.delicate") || !::Lewd.Location.inTheSouth())
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
		foreach( bro in brothers )
		{
			if (bro.getGender() == 0)
			{
				this.m.Male = bro;
				break;
			}
		}
		this.m.Hazeem = this.World.getGuestRoster().create("scripts/entity/tactical/humans/hazeem");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"woman",
			this.m.Woman.getName()
		]);
		_vars.push([
			"male",
			this.m.Male.getName()
		]);
	}

	function onClear()
	{
		this.m.Woman = null;
		this.m.Male = null;
	}

});

