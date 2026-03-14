this.lewd_flight_awakening <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_flight_awakening";
		this.m.Title = "The Stumble";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "You have worn the heels for so long now that you have forgotten what flat ground feels like against a bare sole. They are part of you, as natural as breathing, as unconscious as blinking. You do not think about balance anymore. You have not stumbled in months.\n\nSo when it happens, it catches you completely off guard.\n\nA loose stone, hidden beneath a layer of dried leaves. Your heel catches its edge at precisely the wrong angle and the world tilts sideways. Your ankle folds. Your arms fly out. For one lurching, graceless moment you are falling, truly falling, and the packed earth is rushing up to meet your face.\n\nYou do not hit the ground.\n\nThere is a sensation like being pulled through warm water, a heartbeat of weightlessness where your body is neither here nor there, and then you are standing. Upright. Steady. Six paces from where you were, on the other side of a shallow ditch you definitely did not jump across. Your heels are planted firmly on solid ground. Your heart is hammering.\n\n%randombrother% saw the whole thing. His mouth is hanging open, the waterskin in his hand forgotten and dribbling onto his boots.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What just happened?",
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
			Text = "You try it again that evening, away from the camp, standing at the edge of a clearing with the last grey light filtering through the branches. You stare at a spot ten paces away. You think about being there. You will yourself toward it.\n\nNothing happens. You stand there like a fool, fists clenched, jaw tight, straining toward something you cannot name. The spot remains exactly ten paces away.\n\nYou try again. And again. Each time, nothing. The magic that caught you mid-fall is silent now, indifferent to your commands. Whatever it was, it does not answer to will.\n\nFrustration builds. You are about to give up when a branch snaps somewhere behind you and your body floods with the sudden need to be elsewhere. Not a thought. A need. Primal, wordless, immediate.\n\nThe warm water feeling again. A blink of displacement. You are standing behind the tree you were staring at, pulse racing, the taste of something sweet and electric on your tongue.\n\nYou understand now. It does not respond to desire. It responds to need. The body you inhabit has become something that bends the space around it, but only when that space becomes unbearable. A cage it must escape. A distance it must close. A place it cannot bear to remain.\n\nSo you learn to lie to yourself. You stand in the clearing and you tell yourself that you must be there, that every fiber of your being aches to be in that exact spot three paces to the left. You manufacture the craving. You conjure the urgency from nothing, the way you might summon a blush or force tears. Your body does not know the difference between genuine need and a need you have convinced yourself is real.\n\nThe world folds. You are there.\n\nIt is exhausting. You cannot sustain it for more than an instant, cannot cross great distances, and each blink leaves you slightly breathless, as though you ran the distance your body skipped. But it is enough. More than enough.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mortals walk. You simply come.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local w = _event.m.Woman;

				// Grant blink
				w.getFlags().set("lewdFlightGranted", true);
				if (!w.getSkills().hasSkill("actives.lewd_flight"))
				{
					w.getSkills().add(this.new("scripts/skills/actives/lewd_flight_skill"));
				}

				this.List.push({
					id = 11,
					icon = "skills/lewd_flight.png",
					text = w.getName() + " has awakened the ability to Blink"
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

		// Must already have tail (blink comes after tail)
		if (!this.m.Woman.getFlags().has("lewdTailGranted"))
		{
			this.m.Score = 0;
			return;
		}

		// Must not already have blink
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
