this.lewd_daji_incubus <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		Daji = null,
		IsDom = false
	},
	function create()
	{
		this.m.ID = "event.lewd_daji_incubus";
		this.m.Title = "Daji's Warning";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = ::Lewd.Strings.DajiIncubus.Screen_A,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What would you have me do?",
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
				if (_event.m.Daji != null)
					this.Characters.push(_event.m.Daji.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Dom",
			Text = ::Lewd.Strings.DajiIncubus.Screen_Dom,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "His crown will look better on me.",
					function getResult( _event )
					{
						return "Wake";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				if (_event.m.Daji != null)
					this.Characters.push(_event.m.Daji.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Sub",
			Text = ::Lewd.Strings.DajiIncubus.Screen_Sub,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I will not let him have me.",
					function getResult( _event )
					{
						return "Wake";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				if (_event.m.Daji != null)
					this.Characters.push(_event.m.Daji.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Wake",
			Text = ::Lewd.Strings.DajiIncubus.Screen_Wake,
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prepare for the hunt.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.World.Flags.set("lewdIncubusQuestStarted", true);
				this.Characters.push(_event.m.Woman.getImagePath());

				local playerTile = this.World.State.getPlayer().getTile();
				local tile = ::Lewd.Location.findNearbyTile(playerTile,
					::Lewd.Const.IncubusQuestSpawnMinDist,
					::Lewd.Const.IncubusQuestSpawnMaxDist);

				if (tile != null)
				{
					local loc = this.World.spawnLocation(
						"scripts/entity/world/locations/lewd_incubus_temple_location",
						tile.Coords);
					loc.onSpawned();
					loc.setDiscovered(true);
					loc.getSprite("selection").Visible = true;
					this.World.uncoverFogOfWar(loc.getTile().Pos, 500.0);
					this.World.Flags.set("lewdIncubusTempleID", loc.getID());

					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = "A ruined temple has been revealed on the map"
					});
				}

				this.List.push({
					id = 11,
					icon = "ui/icons/warning.png",
					text = "Daji warns: do not let the incubus complete his seal"
				});
			}
		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		if (this.m.Woman == null
			|| ::Lewd.Mastery.getLewdTier(this.m.Woman) < 3
			|| this.World.Flags.has("lewdIncubusQuestStarted")
			|| !this.World.Flags.has("lewdRecipeCorset")
			|| !this.World.Flags.has("lewdRecipeLatexHarness"))
		{
			this.m.Score = 0;
			return;
		}

		local body = this.m.Woman.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		if (body == null)
		{
			this.m.Score = 0;
			return;
		}

		local isWearingHarness = false;
		if ("getUpgrades" in body)
		{
			local upgrades = body.getUpgrades();
			foreach (u in upgrades)
			{
				if (u != null && u.getID() == "legend_armor.body.lewd_latex_harness")
				{
					isWearingHarness = true;
					break;
				}
			}
		}

		if (!isWearingHarness)
		{
			this.m.Score = 0;
			return;
		}

		local allure = this.m.Woman.getCurrentProperties().getAllure();
		this.m.Score = ::Lewd.Const.DajiIncubusBaseScore + allure * ::Lewd.Const.DajiIncubusAllureScale;
		this.m.IsDom = ::Lewd.Mastery.getDomSub(this.m.Woman) >= 0;
	}

	function onPrepare()
	{
		this.m.Daji = this.World.getGuestRoster().create("scripts/entity/tactical/humans/succubus_gheist");
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
		if (this.m.Daji != null)
		{
			this.World.getGuestRoster().remove(this.m.Daji);
			this.m.Daji = null;
		}
		this.m.Woman = null;
	}
});
