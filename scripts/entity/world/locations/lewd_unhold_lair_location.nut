// Stub location for Session 3 implementation
this.lewd_unhold_lair_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A beast's lair. The spirit whispers of an unhold of terrible strength within.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.lewd_unhold_lair";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.plains";
		this.m.CombatLocation.CutDownTrees = true;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsScalingDefenders = false;
		this.m.Resources = 0;
		this.m.OnDestroyed = "event.lewd_ethereal_unhold_destroyed";
	}

	function onSpawned()
	{
		this.m.Name = "Beast's Lair";

		// TODO Session 3: Add custom unhold boss + escort unholds
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.Unhold
		}, false);
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.Unhold
		}, false);

		this.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_monster_lair_01");
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.getSprite("selection").Visible = true;
	}
});
