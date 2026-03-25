this.lewd_courtesan_intro_event <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_courtesan_intro";
		this.m.Title = "The Jewel of the Night";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = ::Lewd.Strings.CourtesanIntro.Screen_A,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The foxes never escape.",
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
			Text = ::Lewd.Strings.CourtesanIntro.Screen_B,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Today, this fox runs.",
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
			ID = "C",
			Text = ::Lewd.Strings.CourtesanIntro.Screen_C,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Write your own story.",
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
		// Fired directly by scenario, no scoring needed
		local roster = this.World.getPlayerRoster().getAll();
		foreach (bro in roster)
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				this.m.Woman = bro;
				return;
			}
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.Woman != null)
		{
			_vars.push([
				"woman",
				this.m.Woman.getName()
			]);
		}
	}

	function onClear()
	{
		this.m.Woman = null;
	}
});
