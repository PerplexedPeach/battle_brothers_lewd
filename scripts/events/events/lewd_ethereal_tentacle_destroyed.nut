// Post-broodthing destruction event: body reveal, consumption, fusion, Ethereal transformation.
// Fired via OnDestroyed on lewd_broodthing_lair_location.
this.lewd_ethereal_tentacle_destroyed <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		Gheist = null
	},
	function create()
	{
		this.m.ID = "event.lewd_ethereal_tentacle_destroyed";
		this.m.Title = "The Killer Falls";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;

		// Screen A: The broodthing is dead, the body is revealed
		this.m.Screens.push({
			ID = "A",
			Text = "The last tentacle goes slack and drops into the shallow water with a heavy splash. The lair falls quiet, and in the sudden absence of thrashing and screaming you become aware of how thick the air is here. Warm, humid, clinging to your skin like a second layer of sweat. The swamp water around your ankles is pink with blood and something else, a luminous fluid leaking from the broodthing's split carcass that gives off its own faint glow.\n\nThe smell is overwhelming. The creature's magic had shaped this place to its liking, and the result is an atmosphere that sits heavy in the lungs. Rank and fertile, like a corpse flower in full bloom, the concentrated musk of something that should repulse but instead pulls at something deeper. Several of your men have their sleeves pressed to their faces. Others have stopped bothering.\n\nYou wade toward the carcass. The broodthing's central mass has come apart where your company's blades found purchase, the flesh falling away with an almost deliberate neatness, as though the creature was a vessel built around a cargo and the vessel has simply broken open.\n\nA woman's body lies cradled in the ruin. Perfectly preserved, skin unmarked, dark hair fanned across the glistening meat of the thing that consumed her. She could have been laid to rest an hour ago. The luminous fluid pools around her in the shallow water like a votive offering.\n\nYou feel the gheist before you see her. A sudden pressure behind your eyes, a scent of jasmine cutting through the broodthing's musk.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Look closer.",
					function getResult( _event )
					{
						return "B";
					}
				}
			],
			function start( _event )
			{
				if (_event.m.Woman != null)
					this.Characters.push(_event.m.Woman.getImagePath());
				if (_event.m.Gheist != null)
					this.Characters.push(_event.m.Gheist.getImagePath());
			}
		});

		// Screen B: The gheist explains
		this.m.Screens.push({
			ID = "B",
			Text = "The gheist materializes over her own corpse. For the first time since you met her, she is perfectly still. No drifting, no casual prowling through the air. She hovers above the body and stares down at the face that was once hers, and the expression she wears is one you have never seen from her: a quiet, fragile wonder threaded with something that might be grief.%SPEECH_ON%There I am.%SPEECH_OFF%Her voice is barely more than a whisper.%SPEECH_ON%This was a forest when it killed me. Old growth, thick canopy, the kind of place where the light comes through green and soft. I had made a den in the roots of a great oak and I was sleeping when the thing found me. Its tentacles wrapped around me before I could wake, and squeezed until the light went out.%SPEECH_OFF%She reaches down, spectral fingers hovering just above the preserved face. They pass through without touching.%SPEECH_ON%But it could not digest me. My flesh was too saturated with power. Instead of rotting, the body preserved itself and became a font of energy that the creature fed from endlessly. Centuries of my essence, leaking out drop by drop, poisoning the soil, killing the trees, turning this whole place into the fetid swamp you waded through. Everything you see here is what happens when something like me rots slowly for a very long time.%SPEECH_OFF%She turns to you, and the softness is gone. Her golden eyes burn with an intensity you have not seen before.%SPEECH_ON%You have killed the thing that killed me. Freed my body from its prison. Now there is one step left.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What do you need me to do?",
					function getResult( _event )
					{
						return "C";
					}
				}
			],
			function start( _event )
			{
				if (_event.m.Woman != null)
					this.Characters.push(_event.m.Woman.getImagePath());
				if (_event.m.Gheist != null)
					this.Characters.push(_event.m.Gheist.getImagePath());
			}
		});

		// Screen C: The gheist merges with you
		this.m.Screens.push({
			ID = "C",
			Text = "The gheist's expression shifts. The grief falls away and what replaces it is something harder and hungrier, a resolve that has been sharpening itself for centuries.%SPEECH_ON%My body will not accept a stranger. It was mine, and even in death it knows the difference. But if I go first, if I am already inside you when you reach for it, the flesh will recognize me and open.%SPEECH_OFF%She drifts closer. The scent of jasmine intensifies until it drowns the lair's heavy musk entirely. Her spectral form brightens, the translucent edges hardening with purpose.%SPEECH_ON%I need you to let me in. Willingly. Not as a haunting, not as a possession. A joining. I will become part of you and you will become part of me, and neither of us will be quite what we were before.%SPEECH_OFF%She holds your gaze, and for the first time you see vulnerability in those golden eyes. She is asking, not commanding. This is the one thing she cannot take by force.%SPEECH_ON%We both get a second life out of this. I have been dead for a very long time, and I am tired of watching the world from the outside.%SPEECH_OFF%You feel the weight of the choice. Behind you, the company is silent. The lair's musk pulses with each heartbeat, thick and expectant.\n\nYou nod.\n\nThe gheist smiles, and it is the first genuine smile you have seen from her. She reaches out, spectral hands pressing against your temples, and the world floods with light.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Continue.",
					function getResult( _event )
					{
						return "D";
					}
				}
			],
			function start( _event )
			{
				if (_event.m.Woman != null)
					this.Characters.push(_event.m.Woman.getImagePath());
				if (_event.m.Gheist != null)
					this.Characters.push(_event.m.Gheist.getImagePath());
			}
		});

		// Screen D: The body accepts, the fusion completes
		this.m.Screens.push({
			ID = "D",
			Text = "The merging is not gentle. Memories that are not yours crash through your mind like waves against a cliff: a gilded palace, an emperor's bedchamber, a forest at dawn, the taste of a man's desire on your tongue, the weight of centuries spent perfecting the art of want. She was old, older than the northern kingdoms, older than the southern empire, and she had lived through the rise and fall of civilizations. All of that knowledge pours into you and settles heavy and permanent, like sediment at the bottom of a river.\n\nWhen the light fades, you are on your knees in the shallow water, gasping. The gheist is gone from the air. She is inside you now, a warmth curled at the base of your skull, a second pulse beating just behind your own.\n\nAnd the body knows.\n\nYou look down at the preserved corpse and something has changed. The skin is glowing brighter, the luminous fluid rising from it in thin tendrils that reach toward you through the humid air. You stretch out a hand, and the moment your fingers brush against the body's shoulder the flesh softens and dissolves into light. It flows up your arm like water finding its level, warm and golden, soaking through your skin and into the spaces the gheist's merging has opened.\n\nThe body comes apart willingly, gratefully, the way ice melts toward the sun. Centuries of preserved power drawn up through your pores while the shallow water around you glows brighter and brighter. Where the corpse lay there is only an impression in the mud, already filling in, and within you a furnace of accumulated essence that burns without pain.\n\nYou feel whole in a way that defies description. Two lives layered over each other, hers providing depth and yours providing warmth. She is not riding inside you. She has become part of the architecture, load-bearing, inseparable. You gave her a body and she gave you centuries.\n\nA second life for both of you.\n\nYou raise your hands before your face. Still yours, still scarred from years of mercenary work, but the skin has taken on a luminous quality, a faint pearlescent sheen that catches the dim light of the lair and throws it back. Somewhere deep inside, you feel her settle, content for the first time in centuries, and you have the distinct impression that if you called to her, truly called, she would answer.\n\nBut that is a door for another day.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Stand up.",
					function getResult( _event )
					{
						return "E";
					}
				}
			],
			function start( _event )
			{
				if (_event.m.Woman != null)
					this.Characters.push(_event.m.Woman.getImagePath());
			}
		});

		// Screen E: The aftermath, mechanical effects
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/ethereal_3_2.png[/img]You rise from the water. The motion is effortless, fluid, your body moving with a grace that belongs to something other than a woman who has spent her life swinging steel. Your men are gathered at the edge of the lair, watching you with expressions that range from awe to open terror.\n\nYou can feel them. Their desire, their fear, their loyalty, each one a thread of warmth connecting their bodies to yours. You could tug on any of those threads and make a man cross the distance and fall at your feet with nothing more than a look. The knowledge arrives without horror or shame, the way a hawk knows it can dive, the way deep water knows it can drown. A capacity. A tool. Whether you use it is your choice.\n\nYou step out of the lair and into the daylight, and the sun feels different on your skin, warmer, more intimate, as though it recognizes something kindred in the glow you carry. Your men part before you like water around a stone.\n\nYou are still their captain. Still the woman who led them through beast and bandit and the ruin of a creature that should have been beyond any company's reach. But she has been absorbed into the architecture of your being, her centuries folded into your years, and what walks out of this swamp is something the world has not seen before.\n\nSomething with very sharp teeth, a very long memory, and a hunger that the world is not prepared for.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "March out. The world has no idea what is coming.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				if (_event.m.Woman != null)
				{
					this.Characters.push(_event.m.Woman.getImagePath());

					// Apply Ethereal transformation
					local w = _event.m.Woman;
					local skills = w.getSkills();
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

					// Update world map figure immediately
					local player = this.World.State.m.Player;
					if (player != null)
					{
						player.getSprite("body").setBrush("figure_player_ethereal");
						player.getSprite("body").setHorizontalFlipping(false);
					}

					// Company mood effects
					local brothers = this.World.getPlayerRoster().getAll();
					foreach (bro in brothers)
					{
						if (bro == w)
							continue;

						if (bro.getGender() == 0)
						{
							local entry = ::Legends.EventList.changeMood(bro, 2.0, "Captivated by your transformation");
							if (bro.getMoodState() >= this.Const.MoodState.Neutral)
								this.List.push(entry);
						}
						else
						{
							local entry = ::Legends.EventList.changeMood(bro, -1.0, "Unsettled by your transformation");
							if (bro.getMoodState() < this.Const.MoodState.Neutral)
								this.List.push(entry);
						}
					}
				}

				// Complete quest
				this.World.Flags.set("lewdEtherealQuestStage", 6);
			}
		});
	}

	function onUpdateScore()
	{
		// Fired via location OnDestroyed, not via score system
	}

	function onPrepare()
	{
		::logInfo("[mod_lewd] Ethereal quest: tentacle destroyed event preparing");
		this.m.Woman = ::Lewd.Transform.target();
		this.m.Gheist = this.World.getGuestRoster().create("scripts/entity/tactical/humans/succubus_gheist");
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.Woman != null)
			_vars.push(["woman", this.m.Woman.getName()]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		if (this.m.Gheist != null)
		{
			this.World.getGuestRoster().remove(this.m.Gheist);
			this.m.Gheist = null;
		}
		this.m.Woman = null;
	}
});
