this.lewd_incubus_thrall <- this.inherit("scripts/entity/tactical/enemies/bandit_raider", {
	m = {},
	function create()
	{
		this.bandit_raider.create();
		this.m.Name = "Branded Thrall";
		this.m.IsGeneratingKillName = false;
		this.setGender(1);
	}

	function onInit()
	{
		this.bandit_raider.onInit();

		local b = this.m.BaseProperties;
		b.Hitpoints = 80;
		b.MeleeSkill = 50;
		b.MeleeDefense = 20;
		b.RangedDefense = 10;
		b.Initiative = 100;
		b.Bravery = 200;
		b.Stamina = 120;
		b.Allure = 30;
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

		// Female sex skills
		this.m.Skills.add(this.new("scripts/skills/actives/hands_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/oral_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/vaginal_skill"));

		// Inject female sex AI behavior
		this.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_female_horny"));
	}

	function assignRandomEquipment()
	{
		if (this.Math.rand(1, 100) <= 20)
			this.m.Items.equip(this.new("scripts/items/weapons/battle_whip"));
		else
			this.m.Items.equip(this.new("scripts/items/weapons/dagger"));
	}
});
