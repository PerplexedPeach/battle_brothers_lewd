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
		b.MeleeSkill = 60;
		b.MeleeDefense = 30;
		b.RangedDefense = 15;
		b.Initiative = 115;
		b.Bravery = 200;
		b.Stamina = 140;
		b.Allure = 45;
		b.ActionPoints = 9;
		this.m.ActionPoints = 9;
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

		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));

		// Dainty trait
		this.m.Skills.add(this.new("scripts/skills/traits/dainty_trait"));

		// Female sex skills
		this.m.Skills.add(this.new("scripts/skills/actives/hands_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/oral_skill"));
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
