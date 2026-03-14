this.lewd_bandit_boss <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.BanditLeader;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = 500;
		this.m.Name = "Roderick";
		this.m.Title = "the Faithless";
		this.m.IsGeneratingKillName = false;
		this.human.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = ["grey"];
		this.m.Beards = this.Const.Beards.Raider;
		this.m.BeardChance = 100;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bandit_melee_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;

		// Enhanced stats: tougher than a normal bandit leader (~day 60-80 equivalent)
		b.ActionPoints = 9;
		b.Hitpoints = 130;
		b.Bravery = 80;
		b.Stamina = 140;
		b.MeleeSkill = 82;
		b.RangedSkill = 50;
		b.MeleeDefense = 20;
		b.RangedDefense = 12;
		b.Initiative = 110;
		b.FatigueEffectMult = 1.0;
		b.MoraleEffectMult = 1.0;
		b.FatigueRecoveryRate = 22;

		// Specialized in all melee weapon types
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInAxes = true;
		b.IsSpecializedInMaces = true;
		b.IsSpecializedInFlails = true;
		b.IsSpecializedInHammers = true;
		b.IsSpecializedInCleavers = true;
		b.IsSpecializedInDaggers = true;

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_bandits");

		local dirt = this.getSprite("dirt");
		dirt.Visible = true;
		dirt.Alpha = 200;
		this.getSprite("armor").Saturation = 0.85;
		this.getSprite("helmet").Saturation = 0.85;
		this.getSprite("helmet_damage").Saturation = 0.85;
		this.getSprite("shield_icon").Saturation = 0.85;
		this.getSprite("shield_icon").setBrightness(0.85);

		// Perks: standard leader perks + Fortified Mind (resisted the succubus)
		this.m.Skills.add(this.new("scripts/skills/perks/perk_captain"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_shield_expert"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_brawny"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_sundering_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_quick_hands"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fortified_mind"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/actives/rotation"));
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));

		// Traits: iron lungs, brave, tough
		this.m.Skills.add(this.new("scripts/skills/traits/trait_iron_lungs"));
		this.m.Skills.add(this.new("scripts/skills/traits/trait_brave"));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.actor.onAppearanceChanged(_appearance, false);
		this.getSprite("armor").setBrightness(0.9);
		this.getSprite("helmet").setBrightness(0.9);
		this.getSprite("helmet_damage").setBrightness(0.9);
		this.setDirty(true);
	}

	function assignRandomEquipment()
	{
		// Fixed loadout: greatsword, heavy armor, good helmet
		this.m.Items.equip(this.new("scripts/items/weapons/greatsword"));
		this.m.Items.equip(this.new("scripts/items/armor/reinforced_mail_hauberk"));
		this.m.Items.equip(this.new("scripts/items/helmets/flat_top_with_mail"));

		// Throwing axes in bag
		this.m.Items.addToBag(this.new("scripts/items/weapons/throwing_axe"));
	}

	function makeMiniboss()
	{
		if (!this.actor.makeMiniboss())
			return false;

		this.getSprite("miniboss").setBrush("bust_miniboss");
		return true;
	}
});
