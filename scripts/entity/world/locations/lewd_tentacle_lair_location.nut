// Stub location for Session 4 implementation
this.lewd_tentacle_lair_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A foreboding cavern. The spirit's voice trembles with ancient fury.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.lewd_tentacle_lair";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsScalingDefenders = false;
		this.m.Resources = 0;
		this.m.OnDestroyed = "event.lewd_ethereal_tentacle_destroyed";
	}

	function onSpawned()
	{
		this.m.Name = "Overgrown Cavern";

		// TODO Session 4: Add custom tentacle boss
		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.Kraken
		}, false);

		this.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
		this.location.onSpawned();
		this.m.CombatLocation.Template[0] = "tactical.tentacle_lair";
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.AdditionalRadius = 4;
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_lewd_tentacle_lair");
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.getSprite("selection").Visible = true;
	}
});
