this.lewd_bandit_camp_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A bandit hideout. The spirit's voice whispers that a faithless man hides within.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.lewd_bandit_camp";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.human_camp";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Palisade;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsScalingDefenders = false;
		this.m.Resources = 0;
		this.m.OnDestroyed = "event.lewd_ethereal_bandit_destroyed";
	}

	function onSpawned()
	{
		this.m.Name = "Bandit Hideout";

		// Add custom boss: Roderick the Faithless
		this.Const.World.Common.addTroop(this, {
			Type = {
				ID = this.Const.EntityType.BanditLeader,
				Variant = 1,
				Strength = 50,
				Cost = 50,
				Row = 2,
				Script = "scripts/entity/tactical/humans/lewd_bandit_boss"
			}
		}, false);

		// Add escort: 2 raiders, 2 marksmen, 4 thugs
		for (local i = 0; i < 2; i++)
		{
			this.Const.World.Common.addTroop(this, {
				Type = {
					ID = this.Const.EntityType.BanditRaider,
					Variant = 0,
					Strength = 25,
					Cost = 20,
					Row = 0,
					Script = "scripts/entity/tactical/enemies/bandit_raider"
				}
			}, false);
		}

		for (local i = 0; i < 2; i++)
		{
			this.Const.World.Common.addTroop(this, {
				Type = {
					ID = this.Const.EntityType.BanditMarksman,
					Variant = 0,
					Strength = 18,
					Cost = 15,
					Row = 3,
					Script = "scripts/entity/tactical/enemies/bandit_marksman"
				}
			}, false);
		}

		for (local i = 0; i < 4; i++)
		{
			this.Const.World.Common.addTroop(this, {
				Type = {
					ID = this.Const.EntityType.BanditThug,
					Variant = 0,
					Strength = 10,
					Cost = 8,
					Row = 0,
					Script = "scripts/entity/tactical/enemies/bandit_thug"
				}
			}, false);
		}

		this.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(200, 500), _lootTable);
		this.dropArmorParts(this.Math.rand(10, 20), _lootTable);
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_bandit_camp_01");
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.getSprite("selection").Visible = true;
	}
});
