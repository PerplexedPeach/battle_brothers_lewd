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
		head.Visible = false;
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
