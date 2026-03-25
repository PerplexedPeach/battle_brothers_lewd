this.lewd_daji_harness <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		IsDom = false
	},
	function create()
	{
		this.m.ID = "event.lewd_daji_harness";
		this.m.Title = "Daji's Hunger";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = ::Lewd.Strings.DajiHarness.Screen_A,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "For them?",
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
			Text = ::Lewd.Strings.DajiHarness.Screen_Dom,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wake with the scent of alp-leather lingering.",
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
			Text = ::Lewd.Strings.DajiHarness.Screen_Sub,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wake with the scent of alp-leather lingering.",
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
			Text = ::Lewd.Strings.DajiHarness.Screen_Wake,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "She wants to be felt again. You will be her hands.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.World.Flags.set("lewdRecipeLatexHarness", true);

				this.Characters.push(_event.m.Woman.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "You know how to craft a Latex Harness (requires a tailor)"
				});
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		if (this.m.Woman == null
			|| ::Lewd.Mastery.getLewdTier(this.m.Woman) < 3
			|| !this.World.Flags.has("lewdRecipeCorset")
			|| this.World.Flags.has("lewdRecipeLatexHarness"))
		{
			this.m.Score = 0;
		} else {
			local allure = this.m.Woman.getCurrentProperties().getAllure();
			local domScore = ::Lewd.Mastery.getDomScore(this.m.Woman);
			this.m.Score = ::Lewd.Const.DajiHarnessBaseScore
				+ allure * ::Lewd.Const.DajiHarnessAllureScale
				+ domScore * ::Lewd.Const.DajiHarnessDomScale;
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
