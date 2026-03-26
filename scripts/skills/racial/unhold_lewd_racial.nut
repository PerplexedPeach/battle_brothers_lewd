// Unhold Lewd Racial -- passive skill on all unhold entities
// - onTurnStart: become horny if adjacent to a female with allure > threshold
// - onTurnStart: sustain horny while mounting a target
// - Grants piledriver skill (shared with boss, but boss adds its own AI behavior)
this.unhold_lewd_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.unhold_lewd";
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

		// Grant piledriver skill (boss may already have it from its own onInit)
		if (!actor.getSkills().hasSkill("actives.lewd_piledriver"))
			actor.getSkills().add(this.new("scripts/skills/actives/lewd_piledriver_skill"));
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isAlive()) return;
		if (actor.getMoraleState() == this.Const.MoraleState.Fleeing) return;

		// Mount sustains horny: if currently mounting someone, stay aroused
		if (actor.getSkills().hasSkill("effects.lewd_mounting"))
		{
			if (actor.getSkills().hasSkill("effects.lewd_horny"))
			{
				actor.getSkills().getSkillByID("effects.lewd_horny").onRefresh();
				::logInfo("[unhold_racial] " + actor.getName() + " refreshes horny (mounting target)");
			}
			else
			{
				actor.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
				::logInfo("[unhold_racial] " + actor.getName() + " becomes horny (mounting target)");
			}
			return;
		}

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

			if (target.allure() >= ::Lewd.Const.UnholdHornyAllureThreshold)
			{
				::logInfo("[unhold_racial] " + actor.getName() + " becomes horny from adjacent alluring target");
				actor.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
				return;
			}
		}
	}
});
