this.lewd_ethereal_ready <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_ethereal_ready";
		this.m.Title = "The Threshold";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = ::Lewd.Strings.EtherealReady.Screen_A,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You need to find her. Seek out the dead places.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				_event.m.Woman.getFlags().set("lewdEtherealReadyFired", true);
				this.Characters.push(_event.m.Woman.getImagePath());

				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "You are drawn toward graveyards and restless spirits. Something waits for you there."
				});
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		local climaxes = this.m.Woman == null ? 0
			: this.m.Woman.getFlags().getAsInt("lewdPartnerClimaxes") + this.m.Woman.getFlags().getAsInt("lewdSelfClimaxes");

		if (this.m.Woman == null
			|| this.m.Woman.getFlags().has("lewdEtherealReadyFired")
			|| ::Lewd.Mastery.getLewdTier(this.m.Woman) < 2
			|| !this.m.Woman.getFlags().has("lewdEtherealSecondFired")
			|| climaxes < ::Lewd.Const.EtherealReadyEventThreshold
			|| this.World.Flags.getAsInt("lewdEtherealQuestStage") >= 1)
		{
			this.m.Score = 0;
		} else {
			this.m.Score = ::Lewd.Const.EtherealReadyEventBaseScore + climaxes * 10;
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
