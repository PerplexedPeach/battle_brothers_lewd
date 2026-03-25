this.lewd_silk_reflection <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_silk_reflection";
		this.m.Title = "Silk and Memory";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = ::Lewd.Strings.SilkReflection.Screen_A,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Buy the gossamer.",
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
			Text = ::Lewd.Strings.SilkReflection.Screen_B,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You know what you want. You have known for a while.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.World.Flags.set("lewdRecipeSheerBodysuit", true);
				this.World.Flags.set("lewdRecipeFishnets", true);

				this.Characters.push(_event.m.Woman.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "You know how to craft a Sheer Bodysuit (requires a tailor)"
				});
				this.List.push({
					id = 11,
					icon = "ui/icons/special.png",
					text = "You know how to craft Fishnets (requires a tailor)"
				});
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		if (this.m.Woman == null
			|| this.m.Woman.getFlags().getAsInt("heelHeight") <= 0
			|| this.m.Woman.getFlags().getAsInt("heelSkill") < 1
			|| this.World.Flags.has("lewdRecipeSheerBodysuit"))
		{
			this.m.Score = 0;
		} else {
			local allure = this.m.Woman.getCurrentProperties().getAllure();
			this.m.Score = ::Lewd.Const.SilkReflectionBaseScore + allure * ::Lewd.Const.SilkReflectionAllureScale;
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
