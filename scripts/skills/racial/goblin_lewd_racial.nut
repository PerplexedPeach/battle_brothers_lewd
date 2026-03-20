// Goblin Lewd Racial — passive skill on all goblin entities
// - onTurnStart: become horny if adjacent to a rooted/restrained female with allure > threshold
// - Grants goblin_restrain_skill and injects goblin-specific AI behaviors
this.goblin_lewd_racial <- this.inherit("scripts/skills/skill", {
	m = {
		HasAIBehavior = false
	},
	function create()
	{
		this.m.ID = "racial.goblin_lewd";
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

		// Grant goblin restrain skill
		if (!actor.getSkills().hasSkill("actives.goblin_restrain"))
			actor.getSkills().add(this.new("scripts/skills/actives/goblin_restrain_skill"));

		// Inject goblin AI behaviors (restrain is always active, not gated by horny)
		if (!actor.isPlayerControlled())
		{
			local agent = actor.getAIAgent();
			if (agent != null && !this.m.HasAIBehavior)
			{
				agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_goblin_restrain"));
				this.m.HasAIBehavior = true;
			}
		}

		// Grant debauchery perks by goblin type
		local t = actor.getType();
		local skills = actor.getSkills();

		// Goblin Leader: Conqueror (benefits from swarm causing climaxes)
		if (t == this.Const.EntityType.GoblinLeader)
		{
			if (!skills.hasSkill("perk.lewd_conqueror"))
				skills.add(this.new("scripts/skills/perks/perk_lewd_conqueror"));
		}
		// Legend Goblin Berserker: Brutal Force (+25% pleasure, +1 orgasm threshold)
		else if (t == this.Const.EntityType.LegendGoblinBerserker)
		{
			if (!skills.hasSkill("perk.lewd_brutal_force"))
				skills.add(this.new("scripts/skills/perks/perk_lewd_brutal_force"));
		}
		// Legend Goblin Tribe Defender: Exploit Weakness (+25% armor damage vs females)
		else if (t == this.Const.EntityType.LegendGoblinTribeDefender)
		{
			if (!skills.hasSkill("perk.lewd_exploit_weakness"))
				skills.add(this.new("scripts/skills/perks/perk_lewd_exploit_weakness"));
		}
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isAlive()) return;
		if (actor.getMoraleState() == this.Const.MoraleState.Fleeing) return;

		local myTile = actor.getTile();
		local becomeHorny = false;

		// Check adjacent tiles for rooted/restrained female enemies -> become horny
		for (local i = 0; i < 6; i++)
		{
			if (!myTile.hasNextTile(i)) continue;
			local tile = myTile.getNextTile(i);
			if (!tile.IsOccupiedByActor) continue;
			local target = tile.getEntity();
			if (target == null || !target.isAlive()) continue;
			if (actor.isAlliedWith(target)) continue;
			if (target.getGender() != 1) continue;

			// Horny trigger: adjacent to rooted/restrained female with sufficient allure
			if (!becomeHorny && !actor.getSkills().hasSkill("effects.lewd_horny")
				&& target.getCurrentProperties().IsRooted
				&& target.allure() >= ::Lewd.Const.GoblinHornyAllureThreshold)
			{
				becomeHorny = true;
			}
		}

		if (becomeHorny)
		{
			::logInfo("[goblin_racial] " + actor.getName() + " becomes horny from adjacent restrained target");
			actor.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
		}
	}
});
