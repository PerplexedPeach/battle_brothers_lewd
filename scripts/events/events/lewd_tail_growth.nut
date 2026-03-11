this.lewd_tail_growth <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_tail_growth";
		this.m.Title = "The Tail";
		this.m.Cooldown = ::Lewd.Const.TailGrowthEventCooldownDays * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "You wake in the small hours, drenched in sweat, your skin pulsing with that familiar rose-gold light. But this time something is different. There is a pressure at the base of your spine, not painful exactly, but insistent. Like a limb you never knew you had is trying to stretch for the first time.\n\nYou reach behind you and your fingers find it: a ridge of new flesh, warm and smooth, extending from the base of your tailbone. It is barely a hand's length, tapering to a point, and it moves when you think about moving it. Not with the clumsy twitching of a phantom sensation, but with deliberate, fluid grace, as though this part of you has always existed and was simply waiting for the rest to catch up.\n\nYou bite your lip. The pressure builds. The ridge lengthens, vertebra by impossible vertebra, the skin stretching to accommodate it without tearing. There is a deep, bone-level ache that your transformed body converts into something dangerously close to pleasure. Your back arches, a gasp escaping before you can stifle it.\n\nBy the time the sun crests the horizon, it is done. You stand in the pale morning light, examining the new appendage with a mixture of fascination and wary acceptance. It is long, sinuous, and tapered to a point. Its surface is smooth and warm, the same luminous complexion as the rest of your skin. When you concentrate, it coils and strikes the air with a crack that startles a flock of crows from a nearby tree.\n\nIt is strong. Stronger than it has any right to be. You can feel the potential in it: a weapon as natural as your hands, as much a part of your body as the fox-gold eyes or the wine-dark lips.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Flex it experimentally. It feels... right.",
					function getResult( _event )
					{
						return "B";
					}
				},
				{
					Text = "Try to suppress it. You are changing too fast.",
					function getResult( _event )
					{
						return "Reject";
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
			Text = "You spend the morning testing its reach and speed in a clearing behind camp, away from prying eyes. It moves like an extension of your will, whip-fast and precise. A fallen branch, thick as a man's wrist, snaps cleanly when you strike it. When you drag the tapered tip across a stone, it leaves a shallow groove.\n\nBut the most curious thing happens when you brush it against your own arm. A shiver of warmth runs through you, and for a moment the world takes on that honey-gold tint you associate with desire. Supernatural force suffuses it, the same energy you draw from the climaxes of others. Anyone struck by it would feel not just the physical impact, but a whisper of that intoxicating warmth.\n\nYou coil it around your waist beneath your cloak and return to camp. %randombrother% gives you an odd look as you pass but says nothing. You suspect concealment will become increasingly difficult, but for now there are more pressing concerns.\n\nYou have a new weapon. One that no armorer forged, that no merchant can price, and that cannot be taken from you. It is as much a part of you as your ambition.\n\nYou flex it once more, feeling its strength, and allow yourself a small, sharp smile.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It is yours. You are yours.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local w = _event.m.Woman;

				// Grant the tail
				::Lewd.Transform.grantTail(w);
				w.getFlags().set("lewdTailGranted", true);

				this.List.push({
					id = 11,
					icon = "ui/items/weapons/tail_whip_icon.png",
					text = w.getName() + " has grown a spaded tail (natural weapon)"
				});

				this.Characters.push(w.getImagePath());
			}
		});

		// Reject path: delayed, re-fires
		this.m.Screens.push({
			ID = "Reject",
			Text = "You grit your teeth and will it to stop. The pressure at the base of your spine intensifies, pushing against your resistance like water against a dam. For a moment you think it will overwhelm you, that your body will simply do as it pleases regardless of what your mind commands.\n\nBut you are stubborn. You have always been stubborn.\n\nThe growth halts. The ridge of new flesh remains, barely visible beneath your clothing, but it does not lengthen further. The warmth recedes, sulking, and the pressure eases to a dull ache.\n\nYou know it is not gone. You can feel it there, patient and inevitable, like the tide. Your body is changing faster than your mind can accept, and each transformation you resist only delays the next.\n\nBut delay is enough. For now.\n\n[The tail will attempt to grow again as your power accumulates.]",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Not yet. Not today.",
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

		if (this.m.Woman == null)
		{
			this.m.Score = 0;
			return;
		}

		// Must be Ethereal
		if (::Lewd.Mastery.getLewdTier(this.m.Woman) < 3)
		{
			this.m.Score = 0;
			return;
		}

		// Must not already have tail
		if (this.m.Woman.getFlags().has("lewdTailGranted"))
		{
			this.m.Score = 0;
			return;
		}

		// Check combined climax threshold
		local climaxes = this.m.Woman.getFlags().getAsInt("lewdPartnerClimaxes") + this.m.Woman.getFlags().getAsInt("lewdSelfClimaxes");
		if (climaxes < ::Lewd.Const.TailGrowthEventThreshold)
		{
			this.m.Score = 0;
			return;
		}

		this.m.Score = ::Lewd.Const.TailGrowthEventBaseScore + (climaxes - ::Lewd.Const.TailGrowthEventThreshold) * ::Lewd.Const.TailGrowthEventClimaxScale;
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
