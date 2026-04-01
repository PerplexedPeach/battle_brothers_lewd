// Rare Spider Companion -- stronger player-allied spider with enhanced stats.
// Based on a redback-tier spider with bonus HP, damage, and defense.
// Faction set externally by unleash skill.
this.lewd_rare_spider_companion <- this.inherit("scripts/entity/tactical/enemies/spider", {
	m = {},
	function onInit()
	{
		this.spider.onInit();

		// Rare pet: enhanced stats
		local b = this.m.BaseProperties;
		b.Hitpoints = 120;
		b.MeleeSkill = 75;
		b.MeleeDefense = 20;
		b.RangedDefense = 30;
		b.Initiative = 170;
		b.Bravery = 80;
		b.Armor = [40, 40];
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;

		this.m.IsActingImmediately = true;
		this.getCurrentProperties().TargetAttractionMult = 0.25;
		this.m.IsAffectedByInjuries = false;

		// Use Legends redback spider sprites for visual distinction
		if (this.hasSprite("body"))
		{
			local bodies = ["bust_spider_redback_body_01", "bust_spider_redback_body_02", "bust_spider_redback_body_03", "bust_spider_redback_body_04"];
			this.getSprite("body").setBrush(bodies[this.Math.rand(0, bodies.len() - 1)]);
		}
		if (this.hasSprite("head"))
			this.getSprite("head").setBrush("bust_spider_redback_head_01");
		if (this.hasSprite("legs_front"))
			this.getSprite("legs_front").setBrush("bust_spider_redback_legs_front");
		if (this.hasSprite("legs_back"))
			this.getSprite("legs_back").setBrush("bust_spider_redback_legs_back");
	}
});
