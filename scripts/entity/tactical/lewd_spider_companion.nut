// Spider Companion -- player-allied spider spawned from pet accessory.
// Inherits base game spider with slightly reduced stats (it's a pet, not a wild spider).
// Faction set externally by unleash skill.
this.lewd_spider_companion <- this.inherit("scripts/entity/tactical/enemies/spider", {
	m = {},
	function onInit()
	{
		this.spider.onInit();

		// Pet adjustments
		this.m.IsActingImmediately = true;
		this.getCurrentProperties().TargetAttractionMult = 0.25;
		this.m.IsAffectedByInjuries = false;
	}
});
