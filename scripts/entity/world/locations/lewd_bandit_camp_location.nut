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

		// Scale escort count with player party strength
		// <200: base, 200-299: +2 raiders +1 thug,
		// 300-499: +4 raiders +1 marksman +2 thugs, 500+: +6 raiders +2 marksmen +3 thugs
		local strength = this.World.State.getPlayer().getStrength();
		local extraRaiders = 0;
		local extraMarksmen = 0;
		local extraThugs = 0;
		if (strength >= 500)
		{
			extraRaiders = 6;
			extraMarksmen = 2;
			extraThugs = 3;
		}
		else if (strength >= 300)
		{
			extraRaiders = 4;
			extraMarksmen = 1;
			extraThugs = 2;
		}
		else if (strength >= 200)
		{
			extraRaiders = 2;
			extraThugs = 1;
		}

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

		// Base escort: 2 raiders, 2 marksmen, 4 thugs + scaling extras
		for (local i = 0; i < 2 + extraRaiders; i++)
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

		for (local i = 0; i < 2 + extraMarksmen; i++)
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

		for (local i = 0; i < 4 + extraThugs; i++)
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

		::logInfo("[mod_lewd] Bandit camp spawned: strength=" + strength + " raiders=" + (2 + extraRaiders) + " marksmen=" + (2 + extraMarksmen) + " thugs=" + (4 + extraThugs));
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
