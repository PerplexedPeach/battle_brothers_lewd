this.lewd_allure_gaze <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		Man = null
	},
	function create()
	{
		local S = ::Lewd.Strings.AllureGaze;
		this.m.ID = "event.lewd_allure_gaze";
		this.m.Title = "Lingering Gaze";
		this.m.Cooldown = ::Lewd.Const.AllureEventCooldownDays * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = S.Screen_A,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tell him to keep his eyes to himself.",
					function getResult( _event )
					{
						return "Reject";
					}
				},
				{
					Text = "Look away. Pretend you didn't notice.",
					function getResult( _event )
					{
						return "Sub";
					}
				},
				{
					Text = "Hold his gaze. Make him be the one to break.",
					function getResult( _event )
					{
						if (::Lewd.Mastery.rollDomCheck(_event.m.Woman))
							return "DomSuccess";
						else
							return "DomFail";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Man.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Reject",
			Text = S.Screen_Reject,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let him stew on that.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Man.getImagePath());
				this.List.push(::Legends.EventList.changeMood(_event.m.Man, -1.0, "Was told off by " + _event.m.Woman.getName()));
				this.World.Flags.set("lewdAllureEventLastDay", this.World.getTime().Days);
			}
		});
		this.m.Screens.push({
			ID = "Sub",
			Text = S.Screen_Sub,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Try to sleep.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Man.getImagePath());
				::Lewd.Mastery.addDomSub(_event.m.Woman, -::Lewd.Const.AllureGazeDomSubShift);
				::Lewd.Mastery.addDomSub(_event.m.Man, ::Lewd.Const.AllureGazeDomSubShift);
				local wMood = ::Lewd.Mastery.getAlignedMood(_event.m.Woman, false);
				if (wMood >= 0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Enjoyed his attention"));
				else if (wMood <= -0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Felt weak"));
				this.List.push(::Legends.EventList.changeMood(_event.m.Man, 1.0, "Emboldened by " + _event.m.Woman.getName() + "'s silence"));
				this.World.Flags.set("lewdAllureEventLastDay", this.World.getTime().Days);
			}
		});
		this.m.Screens.push({
			ID = "DomSuccess",
			Text = S.Screen_DomSuccess,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That's settled.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Man.getImagePath());
				::Lewd.Mastery.addDomSub(_event.m.Woman, ::Lewd.Const.AllureGazeDomSubShift);
				::Lewd.Mastery.addDomSub(_event.m.Man, -::Lewd.Const.AllureGazeDomSubShift);
				local wMood = ::Lewd.Mastery.getAlignedMood(_event.m.Woman, true);
				if (wMood >= 0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Felt powerful"));
				else if (wMood <= -0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Felt unnatural"));
				this.List.push(::Legends.EventList.changeMood(_event.m.Man, -1.0, "Put in his place by " + _event.m.Woman.getName()));
				this.World.Flags.set("lewdAllureEventLastDay", this.World.getTime().Days);
			}
		});
		this.m.Screens.push({
			ID = "DomFail",
			Text = S.Screen_DomFail,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Lie awake, replaying it.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Man.getImagePath());
				::Lewd.Mastery.addDomSub(_event.m.Woman, -::Lewd.Const.AllureGazeDomSubShift);
				::Lewd.Mastery.addDomSub(_event.m.Man, ::Lewd.Const.AllureGazeDomSubShift);
				local wMood = ::Lewd.Mastery.getAlignedMood(_event.m.Woman, false);
				if (wMood >= 0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Secretly thrilled"));
				else if (wMood <= -0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Embarrassed"));
				this.List.push(::Legends.EventList.changeMood(_event.m.Man, 1.0, "Feels bold around " + _event.m.Woman.getName()));
				this.World.Flags.set("lewdAllureEventLastDay", this.World.getTime().Days);
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

		local allure = this.m.Woman.getCurrentProperties().Allure;
		if (allure < ::Lewd.Const.AllureGazeMinAllure)
		{
			this.m.Score = 0;
			return;
		}

		// Shared cooldown across all allure events
		local daysSince = this.World.getTime().Days - this.World.Flags.getAsInt("lewdAllureEventLastDay");
		if (daysSince < ::Lewd.Const.AllureEventSharedCooldownDays)
		{
			this.m.Score = 0;
			return;
		}

		local candidates = ::Lewd.Mastery.findMaleCandidates();
		if (candidates.len() == 0)
		{
			this.m.Score = 0;
			return;
		}

		this.m.Man = ::Lewd.Mastery.pickWeightedBrother(candidates, { domScale = 0.1, debaucheryBonus = 2.0 });
		this.m.Score = ::Lewd.Const.AllureGazeBaseScore + allure * ::Lewd.Const.AllureGazeAllureScale;
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
		_vars.push([
			"man",
			this.m.Man.getName()
		]);
	}

	function onClear()
	{
		this.m.Woman = null;
		this.m.Man = null;
	}
});
