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
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsScalingDefenders = false;
		this.m.Resources = 0;
		this.m.OnDestroyed = "event.lewd_ethereal_unhold_destroyed";
	}

	function onSpawned()
	{
		this.m.Name = "Beast's Lair";

		// Custom boss: The Ancient One
		this.Const.World.Common.addTroop(this, {
			Type = {
				ID = this.Const.EntityType.Unhold,
				Variant = 1,
				Strength = 80,
				Cost = 80,
				Row = -1,
				Script = "scripts/entity/tactical/enemies/lewd_unhold_boss"
			}
		}, false);

		// Scale escort unholds with player party strength
		// <200: 1 extra, 200-299: 2 extra, 300-499: 2 + 1 bog, 500+: 3 + 1 bog
		local strength = this.World.State.getPlayer().getStrength();
		local extraUnholds = 1;
		local bogUnholds = 0;
		if (strength >= 500)
		{
			extraUnholds = 3;
			bogUnholds = 1;
		}
		else if (strength >= 300)
		{
			extraUnholds = 2;
			bogUnholds = 1;
		}
		else if (strength >= 200)
		{
			extraUnholds = 2;
		}

		for (local i = 0; i < extraUnholds; i++)
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.Unhold
			}, false);
		}

		for (local i = 0; i < bogUnholds; i++)
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.UnholdBog
			}, false);
		}

		::logInfo("[mod_lewd] Unhold lair spawned: strength=" + strength + " unholds=" + (1 + extraUnholds) + " bog=" + bogUnholds);
		this.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_lewd_unhold_lair");
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.getSprite("selection").Visible = true;
	}
});
