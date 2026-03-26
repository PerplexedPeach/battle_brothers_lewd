this.lewd_unhold_boss <- this.inherit("scripts/entity/tactical/enemies/unhold", {
	m = {},
	function create()
	{
		this.unhold.create();
		this.m.Name = "The Ancient One";
		this.m.XP = 600;
		this.m.SoundPitch = 0.8;
		this.m.SoundVolumeOverall = 1.5;

		this.m.IsMiniboss = true;
		this.m.IsGeneratingKillName = false;
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;

		// Enhanced stats: tougher, stronger, more resolute than a normal unhold
		b.ActionPoints = 10;
		b.Hitpoints = 1000;
		b.Bravery = 130;
		b.Stamina = 500;
		b.MeleeSkill = 80;
		b.RangedSkill = 0;
		b.MeleeDefense = 15;
		b.RangedDefense = 5;
		b.Initiative = 85;
		b.FatigueEffectMult = 1.0;
		b.MoraleEffectMult = 1.0;
		b.FatigueRecoveryRate = 35;
		b.Armor = [0, 0];
		b.IsImmuneToDisarm = true;
		b.IsImmuneToRotation = true;
		b.DamageTotalMult = 1.15;

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;

		// Visuals: custom unhold subjugator sprite
		this.m.Items.getAppearance().Body = "bust_unhold_subjugator";
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_unhold_subjugator");
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_unhold_02_injured");
		this.addSprite("armor");
		local head = this.addSprite("head");
		head.setBrush("bust_unhold_head_02");
		head.Visible = false;
		this.m.Items.getAppearance().HideCorpseHead = true;
		this.addSprite("helmet");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(-10, 16));
		this.setSpriteOffset("status_stunned", this.createVec(0, 10));
		this.setSpriteOffset("arrow", this.createVec(0, 10));

		// Skills: standard unhold + Nine Lives + Underdog
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battering_ram"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_stalwart"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(this.new("scripts/skills/racial/unhold_racial"));
		this.m.Skills.add(this.new("scripts/skills/actives/sweep_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/sweep_zoc_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/fling_back_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/unstoppable_charge_skill"));
		if (!this.getSkills().hasSkill("actives.lewd_piledriver"))
			this.m.Skills.add(this.new("scripts/skills/actives/lewd_piledriver_skill"));
		this.m.Skills.add(this.new("scripts/skills/effects/lewd_overwhelming_presence_effect"));

		// Inject piledriver AI behavior
		this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_piledriver"));
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("armor").setHorizontalFlipping(flip);
	}

	function onPlacedOnMap()
	{
		this.unhold.onPlacedOnMap();
		this.getSprite("miniboss").setBrush("bust_miniboss");
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local flip = this.Math.rand(1, 100) < 50;

		if (_tile != null)
		{
			this.m.IsCorpseFlipped = flip;
			this.spawnBloodPool(_tile, 1);
			local appearance = this.getItems().getAppearance();
			local sprite_body = this.getSprite("body");
			local sprite_head = this.getSprite("head");
			local decal;
			decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = sprite_body.Color;
			decal.Saturation = sprite_body.Saturation;
			decal.Scale = 0.9;
			decal.setBrightness(0.9);

			if (appearance.CorpseArmor != "")
			{
				decal = _tile.spawnDetail(appearance.CorpseArmor, this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
				decal.setBrightness(0.9);
			}

			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				if (!appearance.HideCorpseHead)
				{
					decal = _tile.spawnDetail(sprite_head.getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
					decal.Color = sprite_head.Color;
					decal.Saturation = sprite_head.Saturation;
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					decal = _tile.spawnDetail(appearance.HelmetCorpse, this.Const.Tactical.DetailFlag.Corpse, flip);
					decal.Scale = 0.9;
					decal.setBrightness(0.9);
				}
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [];

				if (!appearance.HideCorpseHead)
				{
					layers.push(sprite_head.getBrush().Name + "_dead");
				}

				if (appearance.HelmetCorpse.len() != 0)
				{
					layers.push(appearance.HelmetCorpse);
				}

				// Guard: only call spawnHeadEffect if layers is non-empty.
				// Empty layers causes a native crash (HideCorpseHead=true + no helmet).
				if (layers.len() > 0)
				{
					local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-75, 50), 90.0, sprite_head.getBrush().Name + "_dead_bloodpool");
					local idx = 0;

					if (!appearance.HideCorpseHead)
					{
						decap[idx].Color = sprite_head.Color;
						decap[idx].Saturation = sprite_head.Saturation;
						decap[idx].Scale = 0.9;
						decap[idx].setBrightness(0.9);
						idx = ++idx;
					}

					if (appearance.HelmetCorpse.len() != 0)
					{
						decap[idx].Scale = 0.9;
						decap[idx].setBrightness(0.9);
					}
				}
			}

			if (_fatalityType == this.Const.FatalityType.Disemboweled)
			{
				decal = _tile.spawnDetail("bust_unhold_guts", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail(sprite_body.getBrush().Name + "_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9;
			}

			this.spawnTerrainDropdownEffect(_tile);
		}

		local deathLoot = this.getItems().getDroppableLoot(_killer);
		local tileLoot = this.getLootForTile(_killer, deathLoot);
		this.dropLoot(_tile, tileLoot, !flip);
		local corpse = this.generateCorpse(_tile, _fatalityType, _killer);

		if (_tile == null)
		{
			this.Tactical.Entities.addUnplacedCorpse(corpse);
		}
		else
		{
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function getLootForTile( _killer, _loot )
	{
		// Base unhold loot (bones/skin)
		_loot = this.unhold.getLootForTile(_killer, _loot);

		// Boss money reward
		local money = this.new("scripts/items/supplies/money_item");
		money.m.IsDroppedAsLoot = true;
		money.setAmount(this.Math.rand(800, 1200));
		_loot.push(money);

		return _loot;
	}

	function generateCorpse( _tile, _fatalityType, _killer )
	{
		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = "The Ancient One";
		corpse.IsResurrectable = false;
		corpse.IsConsumable = true;
		corpse.Items = this.getItems().prepareItemsForCorpse(_killer);
		corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;

		if (_tile != null)
			corpse.Tile = _tile;

		return corpse;
	}
});
