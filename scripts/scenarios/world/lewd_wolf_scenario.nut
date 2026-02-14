this.lewd_wolf_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.lewd_wolf";
		this.m.Name = "Courtesan (WIP)";
		this.m.Description = "[p=c][img]gfx/ui/events/courtesan.png[/img][/p][p]You\'ve been prized as a courtesan by nobles, taking part in festivities and nightly activities. Growing tired of being passed around, you yearn for adventure on your own. A woman of striking beauty and litheness, can you survive in such a dangerous world? \n\n[color=#bcad8c]Lewd Wolf:[/color] Start with a single seductive dancer with low funds and few weapons.\n[color=#bcad8c]Avatar:[/color] If your courtesan dies, the campaign ends.[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 110;
		this.m.IsFixedLook = true;

		this.m.StartingRosterTier = this.Const.Roster.getTierForSize(1);
		// this.m.RosterTierMax = this.Const.Roster.getTierForSize(12);
		this.m.StartingBusinessReputation = 250;
		this.setRosterReputationTiers(this.Const.Roster.createReputationTiers(this.m.StartingBusinessReputation));

	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();

		local bro = roster.create("scripts/entity/tactical/player");
		bro.m.HireTime = this.Time.getVirtualTimeF();
		bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);

		local bros = roster.getAll(); //starting party
		// TODO add custom background for this character
		bros[0].setStartValuesEx([
			"legend_assassin_commander_background",
		], true, 1);
		bros[0].getBackground().m.RawDescription = "An experienced courtesan, knows how to entice anyone with her beauty and charm. She\'s been passed around by nobles for years, but she\'s grown tired of it. She yearns for adventure and excitement on her own terms. She\'s not afraid to use her allure to get what she wants, but she also knows how to defend herself if things go south.";
		bros[0].getBackground().buildDescription(true);
		bros[0].setTitle("Jewel of the Night");
		// TODO consider what perks and traits to add later as well as custom ones
		// ::Legends.Perks.grant(bros[0], ::Legends.Perk.LegendFavouredEnemySwordmaster);
		::Legends.Traits.grant(bros[0], ::Legends.Trait.Player);
		::Legends.Traits.grant(bros[0], ::Legends.Trait.LegendSeductive);
		::Legends.Traits.grant(bros[0], ::Legends.Trait.LegendLWRelationship);
		bros[0].setPlaceInFormation(4);
		bros[0].getFlags().set("IsPlayerCharacter", true);
		bros[0].getSprite("miniboss").setBrush("bust_miniboss_lone_wolf");
		bros[0].m.HireTime = this.Time.getVirtualTimeF();
		bros[0].m.PerkPoints = 3;
		bros[0].m.LevelUps = 3;
		bros[0].m.Level = 4;
		bros[0].setVeteranPerks(2);
		bros[0].m.Talents = [];
		bros[0].m.Attributes = [];
		local talents = bros[0].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeDefense] = 3;
		talents[this.Const.Attributes.Fatigue] = 3;
		talents[this.Const.Attributes.Bravery] = 3;
		talents[this.Const.Attributes.MeleeSkill] = 2;
		talents[this.Const.Attributes.RangedSkill] = 2;
		bros[0].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		//---
		this.World.Assets.addBusinessReputation(this.m.StartingBusinessReputation);
		this.World.Flags.set("HasLegendCampTraining", true);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/smoked_ham_item"));

		this.World.Assets.m.Money = this.World.Assets.m.Money / 3 - (this.World.Assets.getEconomicDifficulty() == 0 ? 0 : 100);
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 3;
		this.World.Assets.m.Ammo = 0;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3 && !randomVillage.isSouthern())
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 1), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 1));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 1), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 1));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) == 0)
				{
				}
				else if (!tile.HasRoad)
				{
				}
				else
				{
					randomVillageTile = tile;
					break;
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(6);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		// this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		// {
		// 	this.Music.setTrackList([
		// 		"music/noble_02.ogg"
		// 	], this.Const.Music.CrossFadeTime);
		// 	// TODO add custom event for this scenario
		// 	this.World.Events.fire("event.lone_wolf_scenario_intro");
		// }, null);

	}

	function onInit()
	{
		// this.World.Assets.m.BrothersMax = 12;
	}

	function onCombatFinished()
	{
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				return true;
			}
		}

		return false;
	}

	function setupBro( _bro )
	{
		// _bro.m.HiringCost = 0;
		// _bro.getBaseProperties().DailyWage = 0;
		::Legends.Traits.grant(_bro, ::Legends.Trait.LegendLWRelationship);
	}
});

