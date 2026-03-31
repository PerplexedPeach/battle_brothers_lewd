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
		b.PleasureMax = 150;
		b.ActionPoints = 12;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.PleasureReflectionMult = 3.0;

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

		// Permanently horny
		this.m.Skills.add(this.new("scripts/skills/effects/lewd_horny_effect"));

		// Male sex skills
		this.m.Skills.add(this.new("scripts/skills/actives/male_grope_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/male_force_oral_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/male_penetrate_vaginal_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/male_penetrate_anal_skill"));

		// Debauchery perks (unlock mastery for male sex skills)
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_wandering_hands"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_carnal_knowledge"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_forced_entry"));

		// Male mastery (all capped)
		local mg = this.getSkills().getSkillByID("effects.male_mastery_grope");
		if (mg != null) mg.m.Points = 60;
		local mp = this.getSkills().getSkillByID("effects.male_mastery_penetration");
		if (mp != null) mp.m.Points = 80;
		local ma = this.getSkills().getSkillByID("effects.male_mastery_anal");
		if (ma != null) ma.m.Points = 80;

		// Lewd perks
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_conqueror"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_soul_harvest"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_alluring_presence"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_sensual_focus"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_essence_feed"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_unquenchable"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_lewd_transcendence"));

		// Defense perks
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_ubernimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_dodge"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));

		// Offense perks
		this.m.Skills.add(this.new("scripts/skills/perks/perk_overwhelm"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_backstabber"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_duelist"));

		// Mobility perks
		this.m.Skills.add(this.new("scripts/skills/perks/perk_relentless"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_footwork"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));

		// Inject horny AI behaviors (bypasses horny effect's MoraleState.Ignore gate)
		this.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_horny"));
		this.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_horny_engage"));
	}

	function assignRandomEquipment()
	{
		// No armor -- incubus fights naked
		local w = this.new("scripts/items/weapons/named/named_battle_whip");
		w.m.Name = "Incubus' Tongue";
		this.m.Items.equip(w);
	}
});
