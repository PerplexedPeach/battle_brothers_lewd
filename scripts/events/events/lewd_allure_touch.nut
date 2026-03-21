this.lewd_allure_touch <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		Man = null
	},
	function create()
	{
		local S = ::Lewd.Strings.AllureTouch;
		this.m.ID = "event.lewd_allure_touch";
		this.m.Title = "Uninvited Touch";
		this.m.Cooldown = ::Lewd.Const.AllureEventCooldownDays * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = S.Screen_A,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Keep walking. Let it happen.",
					function getResult( _event )
					{
						return "Sub";
					}
				},
				{
					Text = "Grab his wrist.",
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
			ID = "Sub",
			Text = S.Screen_Sub,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Say nothing. Again.",
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
				::Lewd.Mastery.addDomSub(_event.m.Woman, -::Lewd.Const.AllureTouchDomSubShift);
				::Lewd.Mastery.addDomSub(_event.m.Man, ::Lewd.Const.AllureTouchDomSubShift);
				local wMood = ::Lewd.Mastery.getAlignedMood(_event.m.Woman, false);
				if (wMood >= 0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Wanted his touch"));
				else if (wMood <= -0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Boundaries crossed"));
				this.List.push(::Legends.EventList.changeMood(_event.m.Man, 1.0, "Feels bold around " + _event.m.Woman.getName()));
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
					Text = "He won't try that again.",
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
				::Lewd.Mastery.addDomSub(_event.m.Woman, ::Lewd.Const.AllureTouchDomSubShift);
				::Lewd.Mastery.addDomSub(_event.m.Man, -::Lewd.Const.AllureTouchDomSubShift);
				local wMood = ::Lewd.Mastery.getAlignedMood(_event.m.Woman, true);
				if (wMood >= 0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Asserted herself"));
				else if (wMood <= -0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Felt forced"));
				this.List.push(::Legends.EventList.changeMood(_event.m.Man, -1.0, "Intimidated by " + _event.m.Woman.getName()));
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
					Text = "March on in silence.",
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
				::Lewd.Mastery.addDomSub(_event.m.Woman, -::Lewd.Const.AllureTouchDomSubShift);
				::Lewd.Mastery.addDomSub(_event.m.Man, ::Lewd.Const.AllureTouchDomSubShift);
				local wMood = ::Lewd.Mastery.getAlignedMood(_event.m.Woman, false);
				if (wMood >= 0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Melted into it"));
				else if (wMood <= -0.5)
					this.List.push(::Legends.EventList.changeMood(_event.m.Woman, wMood, "Humiliated"));
				this.List.push(::Legends.EventList.changeMood(_event.m.Man, 1.0, "Feels confident around " + _event.m.Woman.getName()));
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
		if (allure < ::Lewd.Const.AllureTouchMinAllure)
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
		this.m.Score = ::Lewd.Const.AllureTouchBaseScore + allure * ::Lewd.Const.AllureTouchAllureScale;
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
