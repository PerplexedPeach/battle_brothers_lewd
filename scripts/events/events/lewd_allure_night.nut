this.lewd_allure_night <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		Man = null
	},
	function create()
	{
		local S = ::Lewd.Strings.AllureNight;
		this.m.ID = "event.lewd_allure_night";
		this.m.Title = "Night Visitor";
		this.m.Cooldown = ::Lewd.Const.AllureEventCooldownDays * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = S.Screen_A,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "\"Out. Now.\"",
					function getResult( _event )
					{
						return "Reject";
					}
				},
				{
					Text = "Make room for him.",
					function getResult( _event )
					{
						return "Sub";
					}
				},
				{
					Text = "Push him onto his back.",
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
					Text = "Get up. Move on.",
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
				this.List.push(::Legends.EventList.changeMood(_event.m.Woman, -1.0, "Restless night"));
				this.List.push(::Legends.EventList.changeMood(_event.m.Man, -2.0, "Rejected by " + _event.m.Woman.getName()));
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
					Text = "Close your eyes. Don't think about what this means.",
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
				::Lewd.Mastery.addDomSub(_event.m.Woman, -::Lewd.Const.AllureNightDomSubShift);
				::Lewd.Mastery.addDomSub(_event.m.Man, ::Lewd.Const.AllureNightDomSubShift);
				local wMood = ::Lewd.Mastery.getAlignedMood(_event.m.Woman, false);
				if (wMood >= 0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Gave herself willingly"));
				else if (wMood <= -0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Used"));
				this.List.push(::Legends.EventList.changeMood(_event.m.Man, 2.0, "Spent the night with " + _event.m.Woman.getName()));
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
					Text = "Sleep well.",
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
				::Lewd.Mastery.addDomSub(_event.m.Woman, ::Lewd.Const.AllureNightDomSubShift);
				::Lewd.Mastery.addDomSub(_event.m.Man, -::Lewd.Const.AllureNightDomSubShift);
				local wMood = ::Lewd.Mastery.getAlignedMood(_event.m.Woman, true);
				if (wMood >= 0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "In control"));
				else if (wMood <= -0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Hollow victory"));
				this.List.push(::Legends.EventList.changeMood(_event.m.Man, 1.0, "Spent the night with " + _event.m.Woman.getName()));
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
					Text = "Lie still. Don't give him anything else.",
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
				::Lewd.Mastery.addDomSub(_event.m.Woman, -::Lewd.Const.AllureNightDomSubShift);
				::Lewd.Mastery.addDomSub(_event.m.Man, ::Lewd.Const.AllureNightDomSubShift);
				local wMood = ::Lewd.Mastery.getAlignedMood(_event.m.Woman, false);
				if (wMood >= 0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Surrendered gladly"));
				else if (wMood <= -0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Overpowered"));
				this.List.push(::Legends.EventList.changeMood(_event.m.Man, 2.0, "Spent the night with " + _event.m.Woman.getName()));
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
		if (allure < ::Lewd.Const.AllureNightMinAllure)
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
		this.m.Score = ::Lewd.Const.AllureNightBaseScore + allure * ::Lewd.Const.AllureNightAllureScale;
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
