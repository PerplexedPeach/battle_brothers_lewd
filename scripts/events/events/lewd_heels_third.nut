this.lewd_heels_third <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_heels_third";
		this.m.Title = "Eternal Bonds";
		// never fire this event again, as it is a one time thing
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "The palanquin emerges from the twilight haze, its gilded frame catching the last rays of sun like a siren's call. You feel it before you see it, a restless pull in your softened body. The black heels now feel like an extension of your stride rather than a challenge. You've mastered them. Every sway is confident, every step a deliberate tease that draws eyes from your company. But mastery breeds craving. Your fair skin tingles with unfulfilled need. The delicate curves of your remade form ache for the next surrender.\n\nWithout hesitation, you approach. Heels click sharply on the road. The servants lower the ramp in silence. Their impassive faces hide the hunger you've come to recognize. You ascend and enter the cool, incense-laden interior where Qingde sits cross-legged. His sharp eyes appraise your charming poise.%SPEECH_ON%You have bloomed further, %woman%. You will become the jewel of the Emperor's rear court. One final step to eternal perfection.%SPEECH_OFF% His voice is smooth and his eyes gleam greedily, satisfied with your current progress but desiring more.\n\nThere is no bag of gold this time. Instead, a beautiful lacquered box sits with its lid closed. Faint gleams of metal and something darker emanate from within. The air thickens with expectation. Opening the box reveals a metal device that could either be a weapon or a piece of art. Gleaming beautiful curves are etched with swirling patterns in lacquered black and red.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Accept the gift and your fate.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Close the box and get out of here.",
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
			Text = "[img]gfx/ui/events/heels_3_2.png[/img]Instinctively, you know this to be some form of footwear, but you struggle to see where to put your feet. The heel seems reversed, a stiletto pointing upwards towards where the heel of your foot would be. Your body hums. The heat between your legs already builds. You know what this demands: not just acceptance, but willing degradation. Qingde watches you intently, the faintest smile playing at the corners of his mouth. %SPEECH_ON%These are the Emperor's eternal lotus bindings. No mere heels. They will hold you en pointe forever. Your arches will never rest again. Every step will be a reminder of your place: elevated, exposed, exquisite.%SPEECH_OFF%He gestures to the servants. Four blue-robed figures glide forward, faces as impassive as ever. But you know better now. You have seen the curl of their lips, the cold gleam in their eyes when they think you are not looking.\n\nYou do not wait for them to command you. Submission has become a reflex, a dark thrill that coils in your belly. You sink to your knees before Qingde, the plush carpet yielding beneath you. Your hands move to the hem of your tunic, drawing it up and over your head in one fluid motion. Armor follows, plates clattering softly as they are set aside. You are naked in moments, skin flushed and glowing in the lamplight, nipples already peaked, thighs slick with anticipation.\n\nQingde's smile deepens. He does not speak. He simply nods once.\n\nThe first servant steps forward, robes parting without ceremony. His cock is already hard, thick and flushed, the tip glistening. You lean in willingly, lips parting to take him deep. The act is deliberate, reverent in its degradation. Your tongue swirls, cheeks hollow as you suck, hands braced on his thighs. You feel the malice in the way he threads fingers through your hair, not guiding but controlling, holding you exactly where he wants you.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Submit to their needs.",
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
			Text = "You close the box with a soft click.%SPEECH_ON%No.%SPEECH_OFF% The word comes out quiet, final. %SPEECH_ON%Not this. Not yet.%SPEECH_OFF%Qingde's smile freezes. For the first time you see a flicker of genuine surprise in his eyes.\n\nYou turn before he can speak, descending the ramp in careful, deliberate steps. The servants make no move to stop you. Outside, the night air is sharp against your skin. Your company waits at a distance, torches raised, faces tense.\n\nYou walk toward them without looking back. Each heel strike echoes like a refusal. The craving still burns low in your belly, but tonight it does not win.\n\nThe palanquin remains behind you, silent and waiting.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Return to your company and leave the palanquin behind, for now.",
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
		this.m.Screens.push({
			ID = "D",
			Text = "As you service him, two other servants kneel at your feet. They lift one foot gently, then the other. The reversed stiletto slides beneath your arch. Metal cold against skin. Then the tip presses upward, sharp and unyielding, piercing the soft flesh just behind the ball of your foot. Pain blooms bright and exquisite, a white-hot line that shoots up your leg and settles throbbing between your thighs. You moan around the cock in your mouth. The vibration draws a low, satisfied sound from the servant.\n\nBlood beads where the metal bites. The servants do not flinch. They continue their work with practiced precision. Leather straps wrap around your ankle and instep. Gold clasps snap shut with soft, final clicks. Enchanted mechanisms engage; you feel a faint warmth as the bindings fuse lightly to skin and tendon. Removal would require tearing flesh. The pain is masochistic fire now, blending with pleasure until you cannot tell where one ends and the other begins.\n\nYou move to the second servant without pause, taking him into your mouth while the bindings on your other foot are secured. The same piercing, the same searing bloom of agony-laced ecstasy. Your body trembles, arousal dripping freely down your inner thighs.\n\nWhen the last clasp locks, the servants step back. You remain on your knees, lips swollen, chin wet, chest heaving. Qingde rises slowly.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Accept the permanent bond to the heels and their masters.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local w = _event.m.Woman;

				local items = w.getItems();

				local previousHeels = items.getItemAtSlot(this.Const.ItemSlot.Accessory);
				if (previousHeels)
				{
					previousHeels.removeSelf();
				}

				local item = this.new("scripts/items/heels_ballet");
				item.getFlags().set("cursed", true);
				items.equip(item);
				this.List.push({
					id = 10,
					icon = "ui/items/accessory/ballet_heels.png",
					text = "You permanently wear " + item.getName()
				});


				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "E",
			Text = "The ritual continues without pause. With the ballet bindings locked forever to your feet, pain and pleasure entwine so tightly that every shift of weight sends fresh sparks up your legs and into your core. You remain on your knees, body arched en pointe even while kneeling, the metal tips digging deeper with each subtle movement.\n\nThe servants have not finished with you. The one whose length you have just released from your mouth steps back slightly. His hand moves to his shaft, stroking with the same deliberate rhythm they always use. The others follow suit.\n\nThey form a tighter semicircle around your upturned face, cocks in hand, eyes fixed on you with that familiar cold gleam. No words pass between them. None are needed. You do not rise. You do not wipe your lips or chin. Instead you tilt your head back slightly, offering your face like a canvas. The voluntary gesture draws another soft, triumphant exhale from Qingde, who watches from his cushion with folded hands.\n\nOne by one they reach their peak.\n\nThe first servant aims carefully. Thick ropes arc across your cheeks and forehead, warm and heavy, landing in glistening streaks that catch the lamplight.\nThe second follows immediately, spurting over your closed eyelids and the bridge of your nose.\nThe third targets your parted lips, painting them white before the cum drips down your chin in slow trails.\nThe last one steps closest, stroking himself to completion until the final pulses coat your features entirely—forehead, cheeks, mouth, even catching in your lashes. You feel it everywhere: hot, sticky, staining. You do not flinch. You breathe through it, tasting salt on your tongue, feeling the weight of their release settle like a mask.\n\nThe unguent, still slick on your skin from earlier anointing, drinks the fresh seed greedily. Where cum touches the lotion, heat flares once more. This time the shimmer is brighter, racing across your face and then downward through your entire body like liquid starlight.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Embrace your transformation.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/heels_3_5.png[/img]Your features refine further into the eastern ideal of beauty. Cheeks become higher and softer, losing any lingering angularity from your mercenary days. Eyes lengthen subtly at the corners, acquiring an almond grace that makes your gaze more captivating, more inviting. Lips plump and reshape under the painted gloss and drying cum, becoming fuller, naturally crimson even before the final lacquer. Your skin pales to an almost luminous porcelain, flawless and unmarred, glowing with an inner luminescence that no battlefield sun could ever grant. Brows arch delicately. Lashes lengthen and darken. The overall effect is one of exquisite fragility: seductive, doll-like, utterly unsuited to war yet impossible to look away from.\n\nThe change is complete in moments. When the shimmer fades, you are no longer merely softened. You are remade as an eastern jewel: delicate, alluring, designed to kneel and entice rather than stand and fight.\n\nOnly then do the servants kneel once more. Two of them take up the crimson lacquer. They paint your nails first—fingers and toes—brushing the thick gloss over each one with ritual care. The lacquer bonds instantly, hardening into a permanent, mirror-like sheen that will never chip or fade. Next comes your lips. They apply the scarlet gloss in slow, deliberate strokes, layering it thickly until your mouth feels swollen with sensitivity. Every breath now brushes against the painted surface like a caress. Every word you speak will carry the faint taste of the gloss and the memory of what has just coated your lips.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take it all in.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{

				local w = _event.m.Woman;
				local toAdd = ["scripts/skills/traits/delicate_trait"];
				local toRemove = ["trait.dainty", "trait.huge", "trait.strong", "trait.tough", "trait.legend_heavy"];
				local skills = w.getSkills();
				{
					local skill = this.new("scripts/skills/traits/delicate_trait");
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

				// ::Lewd.Transform.sexy_stage_2(w);

				// push image of transformed character
				this.Characters.push(w.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "G",
			Text = "Qingde rises as the servants step away.%SPEECH_ON%Behold the final form. No trace of the sellsword remains. Only beauty. Only submission. Only the Emperor's desire made flesh.%SPEECH_OFF%He extends a hand, palm up.%SPEECH_ON%Rise, jewel. Step forward in your eternal bindings. Then choose: the palanquin carries you east tonight, or you return to your company and let this new hunger devour you slowly until you crawl back begging.%SPEECH_OFF%You push yourself upright. The ballet heels force you onto the extreme points of your toes. Pain lances through your feet and calves, sharp and unrelenting, yet it only heightens the throbbing ache between your legs. You stand en pointe, swaying, body displayed in perfect arch. Ass lifted, breasts forward, face a glistening masterpiece of cum and lacquer.\n\nThe servants watch in silence. Qingde waits.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Accept your new life as a pet in the emperor's harem [TODO].",
					function getResult( _event )
					{
						return "H";
					}
				},
				{
					Text = "Muster up the last of your resolve and return to your company.",
					function getResult( _event )
					{
						return "H";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "H",
			Text = "You stand en pointe in the palanquin's doorway for a long heartbeat, the metal tips of the ballet bindings grinding into the soft flesh beneath your arches with every micro-adjustment of weight. Pain radiates upward in hot, rhythmic waves, yet it only sharpens the insistent throb between your thighs, the slickness already gathering anew despite everything that has just been done to you. Your face is still warm and sticky with drying cum and fresh lacquer; your lips feel swollen and hypersensitive beneath the scarlet gloss; your nails gleam like fresh blood. The transformed eastern beauty staring back from the small gilded mirror one servant held up moments ago is unrecognizable as the sellsword who once led charges into orc lines.\n\nQingde waits, hand still extended, palm up in formal invitation.\n\nYou meet his gaze. The craving is a living thing inside you now—coiling, insistent, promising endless nights of silk and submission if you step forward. But beneath it, something stubborn flickers: the memory of campfires, shared ale, the rough camaraderie of men who followed you through blood and mud because you were strong, not beautiful.\n\nYou lower your eyes in determined contemplation.%SPEECH_ON%Not tonight.%SPEECH_OFF%Your voice is softer than it used to be, breathier, the painted lips shaping the words with unintended sensuality. %SPEECH_ON%I still have debts to settle on this side of the world.%SPEECH_OFF%Qingde's smile does not falter. If anything, it grows fractionally wider, as though he anticipated this answer and finds it amusing.%SPEECH_ON%The craving will not wait forever, jewel. It will gnaw. It will whisper. It will make every battlefield step agony and every quiet night torment until you return to us.%SPEECH_OFF% He lowers his hand. %SPEECH_ON%Go. We will be waiting.%SPEECH_OFF%He inclines his head once. The servants part. No one tries to stop you.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Return to your company.",
					function getResult( _event )
					{
						return "I";
					}
				},
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "I",
			Text = "You turn carefully, the extreme en pointe position forcing tiny, mincing steps down the ramp. Each placement of your foot sends fresh stabs through your heels and calves; the pain is exquisite, almost sexual in its intensity. You bite your painted lower lip to stifle a sound that is half whimper, half moan. The servants watch in silence, their cold satisfaction palpable.\n\nOutside, the night air hits your bare skin like a slap. Your company has drawn closer during your absence—torches raised, faces tense. When you emerge fully into the firelight, a collective breath catches.\n\nYou are no longer their captain in any conventional sense.\n\nThe woman who descends the palanquin steps is delicate, porcelain-skinned, curved in ways that make armor hang awkwardly on a frame built for display rather than war. Your legs are impossibly long and slender, forced into permanent arch by the locked ballet bindings. Every movement is a swaying, erotic mincing gait; the metal tips click faintly against the ramp with each careful placement. Your face—high cheekbones, almond eyes, full crimson lips still glistening faintly—is the epitome of eastern court beauty, framed by the drying evidence of what was done inside. Cum streaks have mostly been absorbed by the unguent, but the scent lingers, musky and unmistakable.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Address your company.",
					function getResult( _event )
					{
						return "J";
					}
				},
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "J",
			Text = "The brothers stare. Some mouths drop open. Others shift uncomfortably, trousers suddenly too tight.\n\n%randombrother% finally breaks the silence, voice rough.%SPEECH_ON%Gods above, Captain... what the fuck did they do to you? You look like... like some painted doll from a whorehouse in the Jade Cities.%SPEECH_OFF%Another brother—a younger one, usually quick with a jest—swallows hard.%SPEECH_ON%You... you can't fight like that. Those shoes—those things on your feet—they're not meant for battle. You'll break your legs.%SPEECH_OFF%You force yourself to take another step forward, the pain lancing bright and hot. Your voice, when it comes, is low but steady despite the tremor.%SPEECH_ON%I can still lead. I can still think. The rest... we'll adapt.%SPEECH_OFF%You pause, letting them take in the full sight: the way your body now sways with every breath, the way the crimson lacquer on your nails catches torchlight, the way your painted lips part slightly as you speak. Several men look away, flushing. Others do not.%randombrother2% speaks:%SPEECH_ON%Company's yours to command, always has been. But we're sellswords, not courtiers. If you stay, we fight with what we've got. And right now... we've got a captain who looks ready to seduce an army instead of kill one.%SPEECH_OFF%A low, uneasy laugh ripples through the group. Not mocking—nervous, uncertain, but still loyal.\n\nYou nod once, the motion making your full lips brush together with a slick sound that draws more than one sharp intake of breath.%SPEECH_ON%Then we fight. Same as always.%SPEECH_OFF%You turn and slowly continue walking. You reach the edge of camp and pause beneath the familiar banner. Pain throbs through your feet. Need throbs lower. The east still whispers in the back of your mind, patient and inevitable.\n\nBut for tonight, you are still theirs.\n\nThe company is still yours.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I am still your captain. Let's move out.",
					function getResult( _event )
					{
						return 0;
					}
				},
			],
			function start( _event )
			{
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
						// women in the company are even more offended by your debasement
						local entry = ::Legends.EventList.changeMood(bro, -1.5, "Lost all respect for you");
						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push(entry);
						}
					} else
					{
						local entry = ::Legends.EventList.changeMood(bro, -0.5, "Lost respect for you");
						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push(entry);
						}
					}
				}

				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		if (this.m.Woman == null || this.m.Woman.getFlags().getAsInt("heelSkill") < 3 || !this.m.Woman.getSkills().hasSkill("trait.dainty") || this.m.Woman.getSkills().hasSkill("trait.delicate"))
		{
			this.m.Score = 0;
		} else {
			this.m.Score = ::Lewd.Const.HeelThirdEventBaseScore;
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

