this.lewd_hexen_transform_second <- this.inherit("scripts/events/event", {
	m = {
		Man = null
	},
	function create()
	{
		this.m.ID = "event.lewd_hexen_transform_second";
		this.m.Title = "The Hexen's Gift";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "You wake to silence and know immediately that it is finished.\n\nThe cold beneath your sternum is gone. Not retreated, not dormant, but truly gone, dissolved into your flesh like salt into water. In its place is a warmth that suffuses your entire body, a gentle heat that feels like the afterglow of a fever finally broken.\n\nYou lie still for a moment, taking inventory. Your chest rises and falls differently. The weight distribution is wrong, or rather, it is new. There is fullness where there was none, a softness at your chest that shifts as you breathe. Your hips press against the bedroll at a wider angle. Your hands, when you raise them before your face in the grey pre-dawn light, are slender, the knuckles less pronounced, the fingers tapered.\n\nYou sit up. Hair falls across your face, longer than it was yesterday, and when you push it back you feel it cascade past your shoulders. Your jaw is smooth without shaving. Your voice, when you experimentally clear your throat, comes out higher, softer, a woman's voice escaping a throat that was a man's less than a week ago.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Look at yourself.",
					function getResult( _event )
					{
						return "B";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Man.getImagePath());
			}
		});

		this.m.Screens.push({
			ID = "B",
			Text = "You find the camp mirror and hold it up with trembling hands.\n\nThe face staring back is yours, unmistakably, undeniably. The same eyes, the same set of the brow, the same expression you wear when confronting something you don't understand. But every feature has been recast. Your jaw has narrowed to a delicate point. Your cheekbones sit high and sharp. Your lips are fuller, your nose refined, your skin porcelain-smooth and unmarked by the years of wind and blade that carved the old face.\n\nYou are beautiful. Not handsome. Beautiful, in the way that makes men's hands go slack on their weapons and their thoughts scatter like startled birds.\n\nThe body matches the face. Narrow shoulders, a waist that curves inward, hips that flare with a geometry that your old frame never possessed. Your armor will need to be entirely refitted. Your old clothes hang wrong in every direction. Even your stance has changed, your center of gravity shifted lower, your balance recalibrated around a frame built for grace rather than brute force.\n\nYou set the mirror down. Your hands have stopped shaking. The face in the mirror is not the one you were born with, but it feels right in a way that frightens you more than the transformation itself.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Face the company.",
					function getResult( _event )
					{
						return "C";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Man.getImagePath());
			}
		});

		this.m.Screens.push({
			ID = "C",
			Text = "You step out of the tent and the camp falls silent.\n\nEvery head turns. Every conversation dies. %randombrother% is the first to react, his jaw dropping open, the bread in his hand forgotten halfway to his mouth. Another brother reaches for his sword before he recognizes your eyes and freezes, hand on the pommel, caught between instinct and disbelief.\n\nYou stand before them and let them look. There is nothing else to do.\n\n%SPEECH_ON%Captain?%SPEECH_OFF% %randombrother% finally manages, his voice cracking on the word. %SPEECH_ON%Is that... are you...%SPEECH_OFF%\n\n%SPEECH_ON%It's me.%SPEECH_OFF% Your new voice carries across the silent camp, clear and steady. Feminine, but commanding. The tone of someone who has led men through worse than this. %SPEECH_ON%The Hexen did something to me in that fight. This is the result. I'm still your captain. I still know how to kill. Nothing important has changed.%SPEECH_OFF%\n\nA long silence. Then %randombrother% lets out a shaky breath and picks up his bread again.%SPEECH_ON%Well. Suppose you'll be needing new armor then, captain.%SPEECH_OFF%\n\nThe tension breaks. Not entirely, the stares don't stop, and you catch whispered conversations throughout the day, but the company holds. They have followed you through worse. A change of flesh is nothing compared to the things you have survived together.\n\nStill, as you begin the work of adjusting to your new body, you can feel that the Hexen's magic has left more than just a physical mark. There is a potential humming beneath your new skin, a sensitivity to the world around you that your old body never possessed. The way men look at you now is different, and you are beginning to understand that this difference is a weapon sharper than any blade you have ever carried.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A new chapter begins.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local man = _event.m.Man;

				// Gender swap: male -> female
				man.setGender(1);

				// Switch to female sprites
				::Lewd.Transform.sexy_stage_0(man);
				::Lewd.Transform.adaptROTUAppearance(man);

				// Mark transformation complete
				man.getFlags().set("lewdHexenTransformStage", 2);

				this.List.push({
					id = 11,
					icon = "ui/icons/special.png",
					text = man.getName() + " has been transformed into a woman by the Hexen's curse."
				});

				// Company reactions
				local brothers = this.World.getPlayerRoster().getAll();
				foreach (bro in brothers)
				{
					if (bro == man)
						continue;

					local entry = ::Legends.EventList.changeMood(bro, 1.0, "Bewildered by your transformation");
					this.List.push(entry);
				}

				this.Characters.push(man.getImagePath());
			}
		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		this.m.Man = null;

		foreach (bro in brothers)
		{
			if (bro.getFlags().getAsInt("lewdHexenTransformStage") == 1)
			{
				this.m.Man = bro;
				break;
			}
		}

		if (this.m.Man == null)
		{
			this.m.Score = 0;
			return;
		}

		this.m.Score = ::Lewd.Const.HexenTransformSecondBaseScore;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"man",
			this.m.Man.getName()
		]);
	}

	function onClear()
	{
		this.m.Man = null;
	}
});
