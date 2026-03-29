this.lewd_incubus <- this.inherit("scripts/entity/tactical/enemies/bandit_raider", {
	m = {},
	function create()
	{
		this.bandit_raider.create();
		this.m.Name = "Incubus";
		this.m.XP = 500;
		this.m.IsGeneratingKillName = false;
		this.setGender(0);
	}

	function onInit()
	{
		this.bandit_raider.onInit();

		local C = ::Lewd.Const;
		local b = this.m.BaseProperties;
		b.Hitpoints = C.IncubusHP;
		b.MeleeSkill = C.IncubusMeleeSkill;
		b.MeleeDefense = C.IncubusMeleeDef;
		b.RangedDefense = C.IncubusRangedDef;
		b.Initiative = C.IncubusInitiative;
		b.Bravery = C.IncubusResolve;
		b.Stamina = 200;
		b.FatigueRecoveryRate = 25;
		b.Allure = C.IncubusAllure;
		b.ActionPoints = 12;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;

		this.m.ActionPoints = 12;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.MoraleState = this.Const.MoraleState.Ignore;

		// Miniboss decorated plate
		this.getSprite("miniboss").setBrush("bust_miniboss");

		// Fixed appearance: clean-shaven, flowing grey hair, handsome
		local head = this.getSprite("head");
		head.setBrush("bust_head_03");
		head.Color = this.createColor("#d49080");
		local body = this.getSprite("body");
		body.Color = this.createColor("#d49080");
		local hair = this.getSprite("hair");
		hair.setBrush("hair_lewd_incubus");
		this.getSprite("beard").setBrush("");
		this.getSprite("beard").Visible = false;
		if (this.hasSprite("beard_top"))
		{
			this.getSprite("beard_top").setBrush("");
			this.getSprite("beard_top").Visible = false;
		}
		this.getSprite("dirt").Visible = false;
		this.getSprite("body_blood").Visible = false;

		// Racial identifier (lewd seal checks for this)
		this.m.Skills.add(this.new("scripts/skills/racial/incubus_lewd_racial"));

		// Male sex skills
		this.m.Skills.add(this.new("scripts/skills/actives/male_grope_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/male_force_oral_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/male_penetrate_vaginal_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/male_penetrate_anal_skill"));

		// Conqueror perk: heals from causing climax
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_conqueror"));

		// Extra combat perks
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
	}

	function assignRandomEquipment()
	{
		// No armor -- incubus fights naked
		this.m.Items.equip(this.new("scripts/items/weapons/named/named_battle_whip"));
	}
});
