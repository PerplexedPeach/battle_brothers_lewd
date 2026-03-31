this.lewd_incubus_favored_concubine <- this.inherit("scripts/entity/tactical/enemies/bandit_raider", {
	m = {},
	function create()
	{
		this.bandit_raider.create();
		this.m.Name = "Favored Concubine";
		this.m.IsGeneratingKillName = false;
		this.setGender(1);
	}

	function onInit()
	{
		this.bandit_raider.onInit();

		local b = this.m.BaseProperties;
		b.Hitpoints = 110;
		b.MeleeSkill = 90;
		b.MeleeDefense = 50;
		b.RangedDefense = 20;
		b.Initiative = 130;
		b.Bravery = 200;
		b.Stamina = 160;
		b.Allure = 60;
		b.PleasureMax = 120;
		b.ActionPoints = 10;
		this.m.ActionPoints = 10;
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

		// Lewd hairstyle
		local styles = ["lewd_01", "lewd_02", "lewd_03", "lewd_04", "lewd_05", "lewd_06"];
		local colors = ["blonde", "brown", "red", "black", "grey"];
		local style = styles[this.Math.rand(0, styles.len() - 1)];
		local color = colors[this.Math.rand(0, colors.len() - 1)];
		this.getSprite("hair").setBrush("hair_" + color + "_" + style);

		// Combat perks
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_dodge"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_backstabber"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_overwhelm"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_footwork"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_relentless"));

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
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_alluring_presence"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_practiced_control"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_transcendence"));

		this.m.Skills.add(this.new("scripts/skills/effects/entrancing_beauty_effect"));

		// Delicate trait
		this.m.Skills.add(this.new("scripts/skills/traits/delicate_trait"));

		// Female sex skills
		this.m.Skills.add(this.new("scripts/skills/actives/hands_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/oral_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/vaginal_skill"));

		// Mastery (tier 3: hands 80, oral 100, vaginal 120 -- all capped)
		local mh = this.new("scripts/skills/effects/lewd_mastery_hands_effect");
		mh.m.Points = 80;
		this.m.Skills.add(mh);
		local mo = this.new("scripts/skills/effects/lewd_mastery_oral_effect");
		mo.m.Points = 100;
		this.m.Skills.add(mo);
		local mv = this.new("scripts/skills/effects/lewd_mastery_vaginal_effect");
		mv.m.Points = 120;
		this.m.Skills.add(mv);

		// Inject female sex AI behavior
		this.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_female_horny"));
	}

	function assignRandomEquipment()
	{
		this.m.Items.equip(this.new("scripts/items/weapons/battle_whip"));

		local armor = this.new("scripts/items/legend_armor/lewd/lewd_sheer_bodysuit");
		armor.setUpgrade(this.new("scripts/items/legend_armor/lewd/lewd_corset"));
		armor.setUpgrade(this.new("scripts/items/legend_armor/lewd/lewd_latex_harness"));
		this.m.Items.equip(armor);
	}
});
