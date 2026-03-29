this.lewd_incubus_temple_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Ancient temple ruins half-swallowed by sand. A strange heat shimmers above the stone.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.lewd_incubus_temple";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsScalingDefenders = false;
		this.m.Resources = 0;
		this.m.OnDestroyed = "event.lewd_incubus_defeated";
		this.m.CombatLocation.Template[1] = "tactical.sunken_library";
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.AdditionalRadius = 4;
	}

	function addTroops()
	{
		// Incubus boss
		this.Const.World.Common.addTroop(this, {
			Type = {
				ID = this.Const.EntityType.Militia,
				Variant = 0,
				Strength = 500,
				Cost = 500,
				Row = 2,
				Script = "scripts/entity/tactical/enemies/lewd_incubus"
			}
		}, false);

		// Harem thralls: match party size, minimum 5
		local haremCount = this.Math.max(5, this.World.getPlayerRoster().getAll().len());
		for (local i = 0; i < haremCount; i++)
		{
			this.Const.World.Common.addTroop(this, {
				Type = {
					ID = this.Const.EntityType.Militia,
					Variant = 0,
					Strength = 50,
					Cost = 50,
					Row = this.Math.rand(0, 3),
					Script = "scripts/entity/tactical/enemies/lewd_incubus_thrall"
				}
			}, false);
		}
	}

	function onSpawned()
	{
		this.m.Name = "Ruined Temple";
		this.addTroops();
		this.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_ancient_statue");
	}

	function onBeforeCombatStarted()
	{
		if (this.m.Troops.len() == 0)
			this.addTroops();
		this.location.onBeforeCombatStarted();
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.getSprite("selection").Visible = true;
	}
});
