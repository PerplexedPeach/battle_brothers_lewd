// Spider Lewd Racial -- passive skill on all spider entities
// - onTurnStart: become horny if adjacent to a female with allure > threshold
// - Grants spider_inject_skill for egg-laying
this.spider_lewd_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.spider_lewd";
		this.m.Name = "";
		this.m.Description = "";
		this.m.Type = this.Const.SkillType.Racial;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();

		// Grant spider inject skill
		if (!actor.getSkills().hasSkill("actives.spider_inject"))
			actor.getSkills().add(this.new("scripts/skills/actives/spider_inject_skill"));
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isAlive()) return;
		if (actor.getMoraleState() == this.Const.MoraleState.Fleeing) return;

		// Already horny -- don't re-check
		if (actor.getSkills().hasSkill("effects.lewd_horny"))
			return;

		// Standard horny trigger: adjacent to female with sufficient allure
		local myTile = actor.getTile();

		for (local i = 0; i < 6; i++)
		{
			if (!myTile.hasNextTile(i)) continue;
			local tile = myTile.getNextTile(i);
			if (!tile.IsOccupiedByActor) continue;
			local target = tile.getEntity();
			if (target == null || !target.isAlive()) continue;
			if (actor.isAlliedWith(target)) continue;
			if (target.getGender() != 1) continue;

			if (target.allure() >= ::Lewd.Const.SpiderHornyAllureThreshold)
			{
				::logInfo("[spider_racial] " + actor.getName() + " becomes horny from adjacent alluring target");
				actor.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
				return;
			}
		}
	}
});
