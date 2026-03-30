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
		b.MeleeSkill = 70;
		b.MeleeDefense = 40;
		b.RangedDefense = 20;
		b.Initiative = 130;
		b.Bravery = 200;
		b.Stamina = 160;
		b.Allure = 60;
		b.ActionPoints = 10;
		this.m.ActionPoints = 10;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;

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

		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));

		// Delicate trait
		this.m.Skills.add(this.new("scripts/skills/traits/delicate_trait"));

		// Female sex skills
		this.m.Skills.add(this.new("scripts/skills/actives/hands_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/oral_skill"));
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
