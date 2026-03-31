this.lewd_incubus_concubine <- this.inherit("scripts/entity/tactical/enemies/bandit_raider", {
	m = {},
	function create()
	{
		this.bandit_raider.create();
		this.m.Name = "Concubine";
		this.m.IsGeneratingKillName = false;
		this.setGender(1);
	}

	function onInit()
	{
		this.bandit_raider.onInit();

		local b = this.m.BaseProperties;
		b.Hitpoints = 95;
		b.MeleeSkill = 80;
		b.MeleeDefense = 40;
		b.RangedDefense = 15;
		b.Initiative = 115;
		b.Bravery = 200;
		b.Stamina = 140;
		b.Allure = 80;
		b.PleasureMax = 120;
		b.ActionPoints = 9;
		this.m.ActionPoints = 9;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.MoraleState = this.Const.MoraleState.Ignore;

		// Force matching ethnicity for face + body
		this.setGender(1);
		local isSouthern = this.m.Ethnicity == 1;
		this.m.Bodies = isSouthern ? this.Const.Bodies.SouthernFemale : this.Const.Bodies.NorthernFemale;
		this.m.Faces = isSouthern ? this.Const.Faces.SouthernFemale : this.Const.Faces.AllFemale;
		this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
		local app = this.getItems().getAppearance();
		app.Body = this.m.Bodies[this.m.Body];
		app.Corpse = this.m.Bodies[this.m.Body] + "_dead";
		this.getSprite("body").setBrush(this.m.Bodies[this.m.Body]);
		this.setAppearance();
		this.getSprite("dirt").Visible = false;
		this.getSprite("body_blood").Visible = false;

		// Combat perks
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_dodge"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_backstabber"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_overwhelm"));

		// Lewd seal stage 4 (permanently branded)
		local seal = this.new("scripts/skills/effects/lewd_seal_effect");
		seal.setStage(4);
		this.m.Skills.add(seal);

		// Permanently horny
		this.m.Skills.add(this.new("scripts/skills/effects/lewd_horny_effect"));

		// Lewd perks (unlock skills + passives)
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_nimble_fingers"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_oral_arts"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_mounting"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_shameless"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_sensual_focus"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_pliant_body"));

		this.m.Skills.add(this.new("scripts/skills/effects/entrancing_beauty_effect"));

		// Dainty trait
		this.m.Skills.add(this.new("scripts/skills/traits/dainty_trait"));

		// Female sex skills
		this.m.Skills.add(this.new("scripts/skills/actives/hands_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/oral_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/vaginal_skill"));

		// Mastery (tier 2: hands 50, oral 70, vaginal 50)
		local mh = this.new("scripts/skills/effects/lewd_mastery_hands_effect");
		mh.m.Points = 50;
		this.m.Skills.add(mh);
		local mo = this.new("scripts/skills/effects/lewd_mastery_oral_effect");
		mo.m.Points = 70;
		this.m.Skills.add(mo);
		local mv = this.new("scripts/skills/effects/lewd_mastery_vaginal_effect");
		mv.m.Points = 50;
		this.m.Skills.add(mv);

		// Inject female sex AI behavior
		this.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_female_horny"));
	}

	function assignRandomEquipment()
	{
		if (this.Math.rand(1, 100) <= 50)
			this.m.Items.equip(this.new("scripts/items/weapons/battle_whip"));
		else
			this.m.Items.equip(this.new("scripts/items/weapons/dagger"));

		local armor;
		if (this.Math.rand(1, 100) <= 50)
		{
			armor = this.new("scripts/items/legend_armor/lewd/lewd_nude_frame");
		}
		else
		{
			armor = this.new("scripts/items/legend_armor/lewd/lewd_sheer_bodysuit");
		}

		armor.setUpgrade(this.new("scripts/items/legend_armor/lewd/lewd_corset"));
		this.m.Items.equip(armor);
	}
});
