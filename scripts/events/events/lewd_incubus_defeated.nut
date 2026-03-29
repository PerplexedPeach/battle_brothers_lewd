this.lewd_incubus_defeated <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		IsSealComplete = false
	},
	function create()
	{
		this.m.ID = "event.lewd_incubus_defeated";
		this.m.Title = "The Incubus Falls";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;

		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take the crown.",
					function getResult( _event )
					{
						return "Wake";
					}
				}
			],
			function start( _event )
			{
				_event.m.Woman = ::Lewd.Transform.target();
				if (_event.m.Woman != null)
				{
					local seal = _event.m.Woman.getSkills().getSkillByID("effects.lewd_seal");
					if (seal != null && seal.getStage() >= 4)
					{
						_event.m.IsSealComplete = true;
						this.Text = ::Lewd.Strings.IncubusDefeated.Screen_Win_Sealed;
					}
					else
					{
						_event.m.IsSealComplete = false;
						this.Text = ::Lewd.Strings.IncubusDefeated.Screen_Win_Clean;

						if (seal != null)
							_event.m.Woman.getSkills().removeByID("effects.lewd_seal");
					}

					this.Characters.push(_event.m.Woman.getImagePath());
				}
				else
				{
					this.Text = ::Lewd.Strings.IncubusDefeated.Screen_Win_Clean;
				}
			}
		});

		this.m.Screens.push({
			ID = "Wake",
			Text = ::Lewd.Strings.IncubusDefeated.Screen_Wake,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The crown is mine.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.World.Flags.set("lewdRecipeGoldHeadpiece", true);
				this.World.Flags.set("lewdIncubusDefeated", true);

				if (_event.m.Woman != null)
					this.Characters.push(_event.m.Woman.getImagePath());

				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "You know how to craft a Gold Headpiece (requires a blacksmith)"
				});

				if (_event.m.IsSealComplete)
				{
					this.List.push({
						id = 11,
						icon = "ui/icons/warning.png",
						text = "The Lewd Seal has burned into your very being (permanent)"
					});
				}
				else
				{
					this.List.push({
						id = 11,
						icon = "ui/icons/special.png",
						text = "The incubus's mark fades from your skin"
					});
				}
			}
		});
	}

	function onUpdateScore()
	{
		// Fired directly via location OnDestroyed, not via score system
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
		this.m.IsSealComplete = false;
	}
});
