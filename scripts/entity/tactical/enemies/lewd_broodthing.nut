// Broodthing -- the central body of the tentacle boss encounter.
// Follows kraken pattern: immobile body spawns tentacles, killing tentacles damages the body.
// Uses bust_broodthing_body_01 brush.
this.lewd_broodthing <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Tentacles = [],
		TentaclesDestroyed = 0,
		IsEnraged = false
	},
	function getImageOffsetY()
	{
		return 40;
	}

	function create()
	{
		this.m.Type = this.Const.EntityType.Kraken;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.IsUsingZoneOfControl = false;
		this.m.RenderAnimationDistanceMult = 3.0;
		this.actor.create();
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(-30, -15);
		this.m.DecapitateBloodAmount = 2.0;
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/krake_hurt_01.wav",
			"sounds/enemies/dlc2/krake_hurt_02.wav",
			"sounds/enemies/dlc2/krake_hurt_03.wav",
			"sounds/enemies/dlc2/krake_hurt_04.wav",
			"sounds/enemies/dlc2/krake_hurt_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc2/krake_death_01.wav",
			"sounds/enemies/dlc2/krake_death_02.wav",
			"sounds/enemies/dlc2/krake_death_03.wav",
			"sounds/enemies/dlc2/krake_death_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/dlc2/krake_idle_01.wav",
			"sounds/enemies/dlc2/krake_idle_02.wav",
			"sounds/enemies/dlc2/krake_idle_03.wav",
			"sounds/enemies/dlc2/krake_idle_04.wav",
			"sounds/enemies/dlc2/krake_idle_05.wav",
			"sounds/enemies/dlc2/krake_idle_06.wav",
			"sounds/enemies/dlc2/krake_idle_07.wav",
			"sounds/enemies/dlc2/krake_idle_08.wav",
			"sounds/enemies/dlc2/krake_idle_09.wav",
			"sounds/enemies/dlc2/krake_idle_10.wav",
			"sounds/enemies/dlc2/krake_idle_11.wav",
			"sounds/enemies/dlc2/krake_idle_12.wav",
			"sounds/enemies/dlc2/krake_idle_13.wav",
			"sounds/enemies/dlc2/krake_idle_14.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/dlc2/krake_enraging_01.wav",
			"sounds/enemies/dlc2/krake_enraging_02.wav",
			"sounds/enemies/dlc2/krake_enraging_03.wav",
			"sounds/enemies/dlc2/krake_enraging_04.wav"
		];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1] = 1.5;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 1.5;
		// Same AI as kraken body: just attack_default (uses devour)
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/kraken_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Kraken);
		b.TargetAttractionMult = 3.0;
		b.IsAffectedByNight = false;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToPoison = true;
		b.IsMovable = false;
		b.IsAffectedByInjuries = false;
		b.IsRooted = true;
		b.IsImmuneToDisarm = true;
		b.Hitpoints = 2000;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;

		this.setName("Broodthing");

		// Sprites
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_broodthing_body_01");
		body.setHorizontalFlipping(true);
		this.addDefaultStatusSprites();
		this.setSpriteOffset("arrow", this.createVec(20, 190));

		// Skills: ravage (pleasure-based devour replacement) + perks
		this.m.Skills.add(this.new("scripts/skills/actives/broodthing_ravage_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/effects/lewd_overwhelming_presence_effect"));

		// Spawn tentacles around the body
		local myTile = this.getTile();
		for (local i = 0; i < 8; i++)
		{
			local mapSize = this.Tactical.getMapSize();

			for (local attempts = 0; attempts < 500; attempts++)
			{
				local x = this.Math.rand(this.Math.max(0, myTile.SquareCoords.X - 2), this.Math.min(mapSize.X - 1, myTile.SquareCoords.X + 8));
				local y = this.Math.rand(this.Math.max(0, myTile.SquareCoords.Y - 8), this.Math.min(mapSize.Y - 1, myTile.SquareCoords.Y + 8));
				local tile = this.Tactical.getTileSquare(x, y);

				if (tile.IsEmpty)
				{
					local tentacle = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/lewd_broodthing_tentacle", tile.Coords);
					tentacle.setParent(this);
					tentacle.setFaction(this.getFaction());
					this.m.Tentacles.push(this.WeakTableRef(tentacle));
					break;
				}
			}
		}
	}

	function onPlacedOnMap()
	{
		this.actor.onPlacedOnMap();
		this.getTile().clear();
		this.getTile().IsHidingEntity = false;
	}

	function setFaction( _f )
	{
		this.actor.setFaction(_f);

		foreach (t in this.m.Tentacles)
		{
			if (!t.isNull() && t.isAlive())
				t.setFaction(_f);
		}
	}

	function onTentacleDestroyed()
	{
		if (!this.isAlive() || this.isDying())
			return;

		++this.m.TentaclesDestroyed;

		// Remove dead tentacle from list
		foreach (i, t in this.m.Tentacles)
		{
			if (t.isNull() || t.isDying() || !t.isAlive())
			{
				this.m.Tentacles.remove(i);
				break;
			}
		}

		// Body takes damage when a tentacle dies (diminishing returns)
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = this.Math.max(35, 190 - (this.m.TentaclesDestroyed - 1) * 5);
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = this.Const.BodyPart.Head;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		this.onDamageReceived(this, null, hitInfo);

		if (!this.isAlive() || this.isDying())
			return;

		// Respawn tentacles to maintain count based on HP
		local numTentacles = this.Math.max(4, this.Math.min(8, this.Math.ceil(this.getHitpointsPct() * 2.0 * 8)));

		while (this.m.Tentacles.len() < numTentacles)
		{
			local mapSize = this.Tactical.getMapSize();
			local myTile = this.getTile();
			local spawned = false;

			for (local attempts = 0; attempts < 500; attempts++)
			{
				local x = this.Math.rand(this.Math.max(0, myTile.SquareCoords.X - 8), this.Math.min(mapSize.X - 1, myTile.SquareCoords.X + 8));
				local y = this.Math.rand(this.Math.max(0, myTile.SquareCoords.Y - 8), this.Math.min(mapSize.Y - 1, myTile.SquareCoords.Y + 8));
				local tile = this.Tactical.getTileSquare(x, y);

				if (tile.IsEmpty)
				{
					local tentacle = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/lewd_broodthing_tentacle", tile.Coords);
					tentacle.setParent(this);
					tentacle.setFaction(this.getFaction());
					tentacle.setMode(this.m.IsEnraged ? 1 : 0);
					tentacle.riseFromGround();
					this.m.Tentacles.push(this.WeakTableRef(tentacle));
					spawned = true;
					break;
				}
			}

			if (!spawned)
				break;
		}
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		_hitInfo.BodyPart = this.Const.BodyPart.Head;
		local ret = this.actor.onDamageReceived(_attacker, _skill, _hitInfo);

		// Enrage when enough tentacles destroyed or HP low
		if (!this.m.IsEnraged && (this.m.TentaclesDestroyed >= 6 || this.getHitpointsPct() <= 0.5))
		{
			this.playSound(this.Const.Sound.ActorEvent.Other1, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1] * this.m.SoundVolumeOverall);
			this.m.IsEnraged = true;

			foreach (t in this.m.Tentacles)
			{
				if (!t.isNull() && t.isAlive() && t.getHitpoints() > 0)
					t.setMode(1);
			}
		}

		return ret;
	}

	function onUpdateInjuryLayer()
	{
		local body = this.getSprite("body");

		if (this.getHitpointsPct() > 0.5)
			body.setBrush("bust_broodthing_body_01");
		else
			body.setBrush("bust_broodthing_body_01_injured");

		this.setDirty(true);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			local body = this.getSprite("body");
			local decal = _tile.spawnDetail("bust_broodthing_body_01_dead", this.Const.Tactical.DetailFlag.Corpse, false);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.95;
			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);

			// Kill all remaining tentacles
			foreach (t in this.m.Tentacles)
			{
				if (t.isNull())
					continue;

				t.setParent(null);

				if (t.isPlacedOnMap())
					t.killSilently();
			}

			this.m.Tentacles = [];
		}

		// Drop loot on tile
		local tileLoot = this.getLootForTile(_killer, []);
		this.dropLoot(_tile, tileLoot, false);

		local corpse = this.generateCorpse(_tile, _fatalityType, _killer);

		if (_tile == null)
			this.Tactical.Entities.addUnplacedCorpse(corpse);
		else
		{
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function getLootForTile( _killer, _loot )
	{
		local money = this.new("scripts/items/supplies/money_item");
		money.setAmount(this.Math.rand(1500, 2500));
		_loot.push(money);

		// Kraken crafting materials
		_loot.push(this.new("scripts/items/misc/kraken_horn_plate_item"));
		_loot.push(this.new("scripts/items/misc/kraken_tentacle_item"));

		// Treasure from the creature's hoard
		local treasurePool = [
			"scripts/items/loot/ancient_gold_coins_item",
			"scripts/items/loot/golden_chalice_item",
			"scripts/items/loot/jeweled_crown_item",
			"scripts/items/loot/gemstones_item",
			"scripts/items/loot/ancient_amber_item",
			"scripts/items/loot/white_pearls_item",
			"scripts/items/loot/signet_ring_item"
		];

		// Drop 2-3 random treasure items
		local numTreasure = this.Math.rand(2, 3);
		for (local i = 0; i < numTreasure; i++)
			_loot.push(this.new(treasurePool[this.Math.rand(0, treasurePool.len() - 1)]));

		return this.actor.getLootForTile(_killer, _loot);
	}

	function generateCorpse( _tile, _fatalityType, _killer )
	{
		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = "Broodthing";
		corpse.IsResurrectable = false;
		corpse.IsConsumable = false;
		corpse.Items = this.getItems().prepareItemsForCorpse(_killer);
		corpse.IsHeadAttached = true;

		if (_tile != null)
			corpse.Tile = _tile;

		return corpse;
	}

	function spawnBloodPool( _a, _b )
	{
	}

	function onDiscovered()
	{
		this.playSound(this.Const.Sound.ActorEvent.Idle, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1] * this.m.SoundVolumeOverall);
		this.actor.onDiscovered();
	}
});
