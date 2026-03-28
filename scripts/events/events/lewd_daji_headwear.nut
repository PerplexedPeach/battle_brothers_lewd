this.lewd_daji_headwear <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		IsDom = false
	},
	function create()
	{
		this.m.ID = "event.lewd_daji_headwear";
		this.m.Title = "Daji's Design";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = ::Lewd.Strings.DajiHeadwear.Screen_A,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Show me.",
					function getResult( _event )
					{
						if (_event.m.IsDom)
							return "Dom";
						return "Sub";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Dom",
			Text = ::Lewd.Strings.DajiHeadwear.Screen_Dom,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wake with the designs burning in your mind.",
					function getResult( _event )
					{
						return "Wake";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Sub",
			Text = ::Lewd.Strings.DajiHeadwear.Screen_Sub,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wake with the designs burning in your mind.",
					function getResult( _event )
					{
						return "Wake";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Wake",
			Text = ::Lewd.Strings.DajiHeadwear.Screen_Wake,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Time to visit the blacksmith.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.World.Flags.set("lewdRecipeHeadwear", true);

				this.Characters.push(_event.m.Woman.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "You know how to craft an O-Ring Gag (requires a blacksmith)"
				});
				this.List.push({
					id = 11,
					icon = "ui/icons/special.png",
					text = "You know how to craft a Lace Mask (requires a blacksmith)"
				});
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		if (this.m.Woman == null
			|| ::Lewd.Mastery.getLewdTier(this.m.Woman) < 3
			|| this.World.Flags.has("lewdRecipeHeadwear")
			|| (!this.World.Flags.has("lewdRecipeCorset") && !this.World.Flags.has("lewdRecipeLatexHarness")))
		{
			this.m.Score = 0;
		} else {
			local allure = this.m.Woman.getCurrentProperties().getAllure();
			this.m.Score = ::Lewd.Const.DajiHeadwearBaseScore + allure * ::Lewd.Const.DajiHeadwearAllureScale;
			this.m.IsDom = ::Lewd.Mastery.getDomSub(this.m.Woman) >= 0;
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
