this.lewd_broodthing_lair_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A foreboding cavern choked with fleshy growths. The spirit's voice trembles with ancient fury.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.lewd_broodthing_lair";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsScalingDefenders = false;
		this.m.Resources = 0;
		this.m.OnDestroyed = "event.lewd_ethereal_tentacle_destroyed";
		// Base terrain comes from world tile; broodthing corruption overlay adds decorations
		this.m.CombatLocation.Template[1] = "tactical.broodthing_lair";
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.AdditionalRadius = 4;
	}

	function onSpawned()
	{
		this.m.Name = "Overgrown Cavern";

		// Broodthing body (spawns its own tentacles in onInit)
		this.Const.World.Common.addTroop(this, {
			Type = {
				ID = this.Const.EntityType.Kraken,
				Variant = 0,
				Strength = 500,
				Cost = 500,
				Row = -1,
				Script = "scripts/entity/tactical/enemies/lewd_broodthing"
			}
		}, false);

		this.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_lewd_broodthing_lair");
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.getSprite("selection").Visible = true;
	}
});
