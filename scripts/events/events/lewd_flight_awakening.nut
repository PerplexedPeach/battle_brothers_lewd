this.lewd_flight_awakening <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_flight_awakening";
		this.m.Title = "Weightless";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "It happens while you are walking.\n\nNot in the heat of battle, not at the peak of passion, but on a quiet stretch of road between two unremarkable hills. One moment your boots are pressing into the packed earth, and the next they are not. You take another step and your foot finds nothing, just air, and you do not fall.\n\nYou stop. You are standing six inches above the ground.\n\nThe sensation is not dramatic. There is no rush of wind, no crackling of energy, no blinding light. It feels like the most natural thing in the world, like you have been carrying a weight your entire life and only now realized you could set it down. The ground is still there beneath you. You simply do not need it anymore.\n\nYou lift higher, experimentally. A foot. Two. The grass bends away from you in a soft circle, pushed by something you cannot see. The air tastes different up here, cleaner, charged with the faintest electric sweetness. You can feel the lattice of forces that holds you aloft: not wings, not wind, but something deeper. The same energy that remakes your flesh after every climax, the same warmth that pulses through you when desire fills the air around you. It has always been there, woven into your bones and blood since your transformation. You just did not know you could ask it to lift you.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You rise higher.",
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
			Text = "You drift above the treeline, turning slowly, and the landscape unfolds beneath you like a map drawn in living color. Fields, forests, the distant smudge of a town, the silver thread of a river. The company is a cluster of tiny figures on the road below, some of them pointing upward, but their voices are too far away to hear.\n\nYou are not afraid. That is the strange part. Heights have never bothered you particularly, but this is different. This is the absence of fear, the bone-deep certainty that you will not fall because falling is something that happens to bodies, and whatever you are becoming, you are less body and more something else with each passing day.\n\nYou hang there for a long time, feeling the wind pull at your hair, watching the shadow of a cloud drift across the patchwork below. You think about what you were before all of this. A woman with ambitions and a sword and a knack for staying alive. How far that feels from where you are now, suspended between the earth and the sky by nothing but your own desire to be here.\n\nThe descent is as easy as the ascent. You settle back onto the road as gently as a leaf, and the world resumes its normal weight.\n\nIn battle, this will change everything. The ability to move where you need to be, instantly, without regard for walls or shields or bodies in your way. You close your eyes and feel the lattice of force still humming inside you, patient, waiting to be called upon again.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Another boundary dissolved. You wonder how many remain.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local w = _event.m.Woman;

				// Grant flight
				w.getFlags().set("lewdFlightGranted", true);
				if (!w.getSkills().hasSkill("actives.lewd_flight"))
				{
					w.getSkills().add(this.new("scripts/skills/actives/lewd_flight_skill"));
				}

				this.List.push({
					id = 11,
					icon = "skills/lewd_flight.png",
					text = w.getName() + " has awakened the ability to fly"
				});

				this.Characters.push(w.getImagePath());
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

		// Must already have tail (flight comes after tail)
		if (!this.m.Woman.getFlags().has("lewdTailGranted"))
		{
			this.m.Score = 0;
			return;
		}

		// Must not already have flight
		if (this.m.Woman.getFlags().has("lewdFlightGranted"))
		{
			this.m.Score = 0;
			return;
		}

		// Check combined climax threshold
		local climaxes = this.m.Woman.getFlags().getAsInt("lewdPartnerClimaxes") + this.m.Woman.getFlags().getAsInt("lewdSelfClimaxes");
		if (climaxes < ::Lewd.Const.FlightEventThreshold)
		{
			this.m.Score = 0;
			return;
		}

		this.m.Score = ::Lewd.Const.FlightEventBaseScore + (climaxes - ::Lewd.Const.FlightEventThreshold) * ::Lewd.Const.FlightEventClimaxScale;
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
