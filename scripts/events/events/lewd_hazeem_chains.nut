this.lewd_hazeem_chains <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		MasoTier = 0
	},
	function create()
	{
		this.m.ID = "event.lewd_hazeem_chains";
		this.m.Title = "The Jeweler's Letter";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = ::Lewd.Strings.HazeemChains.Screen_A,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Read on.",
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
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "He is right about all of it.",
					function getResult( _event )
					{
						return "C";
					}
				}
			],
			function start( _event )
			{
				if (_event.m.MasoTier >= 3)
					this.Text = ::Lewd.Strings.HazeemChains.Screen_B_T3;
				else
					this.Text = ::Lewd.Strings.HazeemChains.Screen_B_T2;

				this.Characters.push(_event.m.Woman.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "C",
			Text = ::Lewd.Strings.HazeemChains.Screen_C,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Find the gold. Find the gems. Build what he described.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.World.Flags.set("lewdRecipePiercingChains", true);

				this.Characters.push(_event.m.Woman.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "You know how to craft Piercing Chains (requires a tailor)"
				});
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		if (this.m.Woman == null
			|| this.World.Flags.has("lewdRecipePiercingChains"))
		{
			this.m.Score = 0;
			return;
		}

		// Requires sub tier 2+ (subScore >= 10)
		local subScore = ::Lewd.Mastery.getSubScore(this.m.Woman);
		if (subScore < ::Lewd.Const.DomSubTier2)
		{
			this.m.Score = 0;
			return;
		}

		// Requires masochism tier 2+
		local skills = this.m.Woman.getSkills();
		local masoTier = 0;
		if (skills.hasSkill("trait.masochism_third")) masoTier = 3;
		else if (skills.hasSkill("trait.masochism_second")) masoTier = 2;
		else if (skills.hasSkill("trait.masochism_first")) masoTier = 1;

		if (masoTier < 2)
		{
			this.m.Score = 0;
			return;
		}

		this.m.MasoTier = masoTier;
		this.m.Score = ::Lewd.Const.HazeemChainsBaseScore
			+ subScore * ::Lewd.Const.HazeemChainsSubScale
			+ masoTier * ::Lewd.Const.HazeemChainsMasochismTierScale;
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
		this.m.MasoTier = 0;
	}
});
