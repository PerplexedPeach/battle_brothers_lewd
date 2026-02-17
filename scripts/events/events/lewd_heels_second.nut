this.lewd_heels_second <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_heels_second";
		this.m.Title = "Rebirth of Seed and Silk";
		// never fire this event again, as it is a one time thing
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/heels_2_1.png[/img]The palanquin appears unannounced on the road. Without waiting for invitation, you stride forward confidently in your short black heels, their subtle click marking your approach. The servants lower the stepped ramp in silent unison. Inside, the cool saltpeter air envelops you. Qingde's sharp eyes trace your entrance, lingering on the sway of your hips and the faint softness creeping into your skin. You settle onto a plush cushion opposite him, legs crossed, body far more relaxed than your first visit. You are curious now about the power of allure beyond battlefield fear. He smiles faintly, stroking his beard. %SPEECH_ON%My hopes were well placed, it seems. With every battle, you grow more dangerous... and more beautiful.%SPEECH_OFF% The stoic praise warms you unexpectedly. Flattered, you shift your pose, exploring this budding vein of sexuality. %SPEECH_ON%I bring further gifts,%SPEECH_OFF% he continues, gesturing to a hefty bag of gold, roughly twice the size of the last, and an ornate jade jar filled with viscous white unguent that shimmers in the gilded light. %SPEECH_ON%Some call our methods decadent, even unnatural. Yet their effectiveness is beyond doubt. This lotus unguent will remake you, shedding the crude warrior's husk for exquisite delicacy. Apply it nightly across your body, but it requires mingling with men's seed as the catalyst. Only then will it truly absorb, sloughing away your old self like dead skin.%SPEECH_OFF% A flush rises in your chest; the notion repels yet intrigues, your mind already drifting to camp nights and rough hands. The gold tempts as ever, but this gift demands a deeper, more intimate surrender."
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Reach for the jar and accept the offer.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Reject the offer.",
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
			ID = "B",
			Text = "You sit in the gilded quiet, the jade jar and doubled gold bag between you. Qingde watches without haste, letting the weight of his words settle. The ritual he described, seed as catalyst, flesh remade through mingling, stirs something deep and unfamiliar: not just curiosity, but a slow, warm pulse low in your belly. You exhale once, then nod. %SPEECH_ON%I accept.%SPEECH_OFF% Qingde gives the barest smile and claps twice. Four servants enter from behind the curtains, faces impassive, blue silk robes whispering. They move with practiced economy.\n\nOne kneels at your feet and begins unbuckling the straps of your heels with cool fingers. Another loosens the ties of your armor and tunic. You do not resist; the air feels charged, expectant. Piece by piece your clothes are drawn away until you kneel naked on the plush carpet, skin prickling in the cool saltpeter draft.\n\nThe servants do not leer. They work as if anointing a statue. One dips both hands into the jade jar, scooping thick white unguent that smells faintly of lotus and something muskier. They spread it methodically: across your shoulders, down your arms, over your breasts, along your stomach, between your thighs.\n\nThe lotion is cool at first, then warms where it touches, tingling as though waking nerves long buried under callous and scar. When every inch of you gleams faintly under the gilded light, the servants step back. Then, in unison, they untie their own sashes. Robes fall open and slide to the floor."
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let them do as they please.",
					function getResult( _event )
					{
						return "D";
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
			Text = "You sit across from Qingde, the jade jar and heavy bag of gold between you like an unspoken contract. His words linger in the cool, perfumed air—seed as catalyst, shedding the warrior for something delicate and pliant. The flush in your chest is real, the temptation sharper than any blade you've faced. But you feel the familiar weight of your sword at your side, the callouses still faint beneath the straps of your heels, the ache in your shoulders from recent battles. That life is yours. This one would not be. You meet his gaze steadily. %SPEECH_ON%Your gifts are generous, Qingde. The coin I've taken, I'll keep. The heels too—they serve well enough.%SPEECH_OFF% You rise slowly, careful on the elevated soles, and gesture toward the jar and the new bag. %SPEECH_ON%But this path—the unguent, the mingling, the remaking—ends here. I fight for my company, for coin earned in blood, not for silk and submission in some distant court. I decline.%SPEECH_OFF% Qingde's expression does not change. No anger, no pleading. Only the same merchant's calm, appraising eyes. %SPEECH_ON%The invitation is offered once.%SPEECH_OFF% He speaks softly. %SPEECH_ON%Those who refuse do not see this palanquin again. You understand this.%SPEECH_OFF% %SPEECH_ON%I do.%SPEECH_OFF% He inclines his head once, formal and final. %SPEECH_ON%Then go with fortune on the battlefield you choose.%SPEECH_OFF% You turn and descend the steps without looking back. The servants lift the palanquin smoothly; it retreats down the road until the gilded roof vanishes behind dust and distance. Back at camp, your men glance at your unchanged heels, the same black straps they've grown accustomed to. No new gold clinks in the coffers tonight, no strange jar waits by your bedroll. A few raise eyebrows but ask nothing. You flex your toes against the leather, feeling the now-familiar lift. They still work. The road ahead remains the one you've always walked—hard, bloody, and your own.\n[The palanquin will not appear again. No further progression events or body changes will trigger. The stage 1 heels remain equippable with their original minor effects, if any.]"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Stand your ground and reject the offer.",
					function getResult( _event )
					{
						return 0;
					}

				},
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});

		this.m.Screens.push({
			ID = "D",
			Text = "Four erect cocks spring free as the blue silk pools at their feet, thick, veined, already leaking at the tips, flushed darker than their impassive faces would ever suggest. You blink, breath catching. These men, who have borne the palanquin in perfect silence, have been hard for you all along. Every sway of your hips in the new heels, every softening curve they’ve glimpsed through armor gaps, every moment you’ve begun to move like something ornamental rather than lethal, they’ve watched, and they’ve wanted.\n\nBehind the mask of trained indifference, their eyes gleam with something colder, hungrier: not mere lust, but quiet malice, the pleasure of reducing a warrior to this. They know exactly what they’re doing.\n\nThe realization crashes through you like heat lightning. You are no longer just feared or respected; you are desired in a way that strips power rather than grants it. Your nipples pebble painfully tight; a shameful rush of wetness slicks your inner thighs, mingling with the unguent already there. You shift on your knees, pressing them together instinctively, but the motion only spreads the slick warmth higher, teasing your swollen clit against itself.\n\nThe servants close the circle tighter, cocks in hand. They stroke with that same deliberate economy, slow, firm pulls from root to glistening head, foreskins sliding back and forth in perfect rhythm. No grunts, no heavy breathing, only the wet sound of skin on skin and your own quickening breaths filling the gilded space. Their faces remain blank, but the slight curl at the corners of their mouths betrays them: they savor your wide-eyed stare, the way your lips part, the faint tremor in your shoulders.\n\nOne by one they cum. The first servant aims low, thick ropes splattering hot across your stomach and the tops of your thighs, painting pale streaks over the unguent. The second targets higher, across your breasts, heavy spurts landing on your hardened nipples, dripping down the undersides in slow trails. The third grunts once, almost inaudibly, and sends his load arcing to catch your cheek and the corner of your mouth; you taste salt on your tongue before you can stop yourself from licking it away. The last one steps closest, stroking furiously until he unloads directly onto your mound, warm pulses coating your folds, seeping between them, mixing with your own arousal until everything is slippery, obscene, claimed."
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Submit to their ministrations.",
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
			ID = "E",
			Text = "[img]gfx/ui/events/heels_2_3.png[/img]The unguent drinks greedily. Where each thick rope of cum lands, the white lotion flares hotter, almost burning, then sinks deep like molten wax into parched earth. A bright shimmer races beneath your skin, visible for a heartbeat like lightning under flesh.\n\nYou gasp as the change begins: muscles that once corded like steel soften just a fraction, yielding where they used to resist. Scars on your arms and ribs blur at the edges, roughness giving way to unnatural smoothness. Your body is already betraying you, reshaping itself under their seed and the Empire’s decadent alchemy. Qingde rises slowly, robes whispering. %SPEECH_ON%The first mingling is complete.%SPEECH_OFF% His voice remains calm, but now you hear the faint undercurrent of triumph, the pleasure of a man watching a wild thing be broken to harness. %SPEECH_ON%Apply the remainder nightly. Seek seed wherever it pleases you, your rough company brothers, passing mercenaries, whoever stirs that new heat between your legs. These shall replace the ones you have been wearing.%SPEECH_OFF% He gestures to a new pair of heels beside the gold: taller, sinister black leather interwoven with gold clasps glinting like manacles, the lift steep enough to force an arch that will make every step a reminder of submission. Two servants rush forward before you can protest. They kneel, unbuckle the familiar short heels with practiced speed, and slide the new ones onto your feet.\n\nThe leather grips tighter than before, straps biting into newly softened skin; the height pitches you forward, forcing your ass out and your back into a pronounced curve. You wobble for a heartbeat, then find balance, precarious, humiliating, intoxicating. The servants cinch the gold clasps shut with audible clicks, sealing them like tiny locks."
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Examine yourself.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				local w = _event.m.Woman;

				local items = w.getItems();
				// remove the previous low heels
				local previousHeels = items.getItemAtSlot(this.Const.ItemSlot.Accessory);
				if (previousHeels)
				{
					// items.unequip(previousHeels);
					previousHeels.removeSelf();
				}


				local item = this.new("scripts/items/heels_black");
				items.equip(item);
				this.List.push({
					id = 10,
					icon = "ui/items/accessory/black_heels.png",
					text = item.getName() + " snugly fits onto your feet, the straps biting into your softened skin."
				});

				local toAdd = ["scripts/skills/traits/dainty_trait"];
				local toRemove = ["trait.huge", "trait.strong", "trait.tough", "trait.legend_heavy"];
				local skills = w.getSkills();
				{
					local skill = this.new("scripts/skills/traits/dainty_trait");
					skills.add(skill);
					this.List.push({
						id = 11,
						icon = skill.getIcon(),
						text = w.getName() + " is now " + skill.getName()
					});
				}
				local idx = 13;
				foreach (removedSkill in toRemove)
				{
					if (skills.hasSkill(removedSkill))
					{
						local skill = skills.getSkillByID(removedSkill);
						skills.removeByID(removedSkill);
						this.List.push({
							id = idx,
							icon = skill.getIcon(),
							text = w.getName() + " is no longer " + skill.getName()
						});
						idx++;
					}
				}

				this.Characters.push(w.getImagePath());

				// ::Lewd.Transform.sexy_stage_1(w);

				// TODO animate transformation after some time

				this.Time.scheduleEvent(this.TimeUnit.Virtual, 5000, function() {
					// push image of transformed character
					this.Characters.push(w.getImagePath());
				}.bindenv(this) , null);


			}
		});

		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/heels_2_4.png[/img]Bringing one hand into view, it is almost unrecognizable: soft, slender, elegant, with no trace of blisters or sword callouses.\n\nThe other servants help you back into your armor, though it now hangs differently on your narrower frame, plates loose where muscle once filled them.\n\nOne servant lingers deliberately while buckling your belt, fingers sliding between your thighs to stroke once along your slick, swollen folds, pressing just enough to draw a stifled whimper from you before withdrawing with that same cold satisfaction. They guide you down the steps.\n\nOutside, the sun is blinding. Your company waits at a distance; several men stare openly, first in confusion, then in open hunger, at the transformed woman approaching them: fair skin glowing, body soft and curved, legs elongated and unsteady in the towering heels, every step clicking with deliberate eroticism. No one dares speak, but the air thickens with unspoken want.\n\nYou walk back to camp, heels forcing a swaying gait you cannot control, body humming with the aftershocks of ritual and the insistent throb between your legs."
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Return to camp.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());

				// this.List.push(::Legends.EventList.changeMood(w, 2.0, "Got new footwear"));
				local brothers = this.World.getPlayerRoster().getAll();

				// only if they are not you and is a man
				foreach( bro in brothers )
				{
					if ( bro == _event.m.Woman)
					{
						continue;
					}
					if ( bro.getGender() == 1)
					{
						// women in the company are offended by your debasement
						local entry = ::Legends.EventList.changeMood(bro, -0.5, "Disliked your new look");
						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push(entry);
						}
					} else
					{
						local entry = ::Legends.EventList.changeMood(bro, 1.5, "Pleased with your new look");
						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push(entry);
						}
					}
				}
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		// check if they have the sufficient heel skill and don't have this trait yet
		if (this.m.Woman == null || this.m.Woman.getFlags().getAsInt("heelSkill") < 1 || this.m.Woman.getSkills().hasSkill("trait.dainty") || this.m.Woman.getSkills().hasSkill("trait.delicate"))
		{
			this.m.Score = 0;
		} else {
			this.m.Score = ::Lewd.Const.HeelSecondEventBaseScore;
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

