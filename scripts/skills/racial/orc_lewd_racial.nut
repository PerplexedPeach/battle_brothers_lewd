// Orc Lewd Racial -- passive skill on all orc entities
// - onTurnStart: become horny if adjacent to a female with allure > threshold
// - onTurnStart: sustain horny while orc has an active claim
// - Grants orc_claim_skill and injects orc-specific AI claim behavior
this.orc_lewd_racial <- this.inherit("scripts/skills/skill", {
	m = {
		HasAIBehavior = false
	},
	function create()
	{
		this.m.ID = "racial.orc_lewd";
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

		// Grant orc claim skill
		if (!actor.getSkills().hasSkill("actives.orc_claim"))
			actor.getSkills().add(this.new("scripts/skills/actives/orc_claim_skill"));

		// Inject orc AI claim behavior (always active, not gated by horny)
		if (!actor.isPlayerControlled())
		{
			local agent = actor.getAIAgent();
			if (agent != null && !this.m.HasAIBehavior)
			{
				agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_orc_claim"));
				this.m.HasAIBehavior = true;
			}
		}

		// Grant debauchery perks by orc type
		local t = actor.getType();
		local skills = actor.getSkills();

		// Berserker: Brutal Force (+25% pleasure, +1 orgasm threshold)
		if (t == this.Const.EntityType.OrcBerserker)
		{
			if (!skills.hasSkill("perk.lewd_brutal_force"))
				skills.add(this.new("scripts/skills/perks/perk_lewd_brutal_force"));
		}
		// Warrior: Exploit Weakness (+25% armor damage vs females)
		else if (t == this.Const.EntityType.OrcWarrior)
		{
			if (!skills.hasSkill("perk.lewd_exploit_weakness"))
				skills.add(this.new("scripts/skills/perks/perk_lewd_exploit_weakness"));
		}
		// Warlord: Brutal Force + Conqueror (fatigue restore + morale on causing climax)
		else if (t == this.Const.EntityType.OrcWarlord)
		{
			if (!skills.hasSkill("perk.lewd_brutal_force"))
				skills.add(this.new("scripts/skills/perks/perk_lewd_brutal_force"));
			if (!skills.hasSkill("perk.lewd_conqueror"))
				skills.add(this.new("scripts/skills/perks/perk_lewd_conqueror"));
		}
		// Legend Orc Elite: Brutal Force + Iron Grip (restrain)
		else if (t == this.Const.EntityType.LegendOrcElite)
		{
			if (!skills.hasSkill("perk.lewd_brutal_force"))
				skills.add(this.new("scripts/skills/perks/perk_lewd_brutal_force"));
			if (!skills.hasSkill("perk.lewd_iron_grip"))
				skills.add(this.new("scripts/skills/perks/perk_lewd_iron_grip"));
		}
		// Legend Orc Behemoth: Brutal Force
		else if (t == this.Const.EntityType.LegendOrcBehemoth)
		{
			if (!skills.hasSkill("perk.lewd_brutal_force"))
				skills.add(this.new("scripts/skills/perks/perk_lewd_brutal_force"));
		}
		// Orc Young: no perks
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isAlive()) return;
		if (actor.getMoraleState() == this.Const.MoraleState.Fleeing) return;

		// Claim sustains horny: if orc has an active claim, keep them aroused
		if (actor.getFlags().has("lewdOrcClaimTarget"))
		{
			local claimedID = actor.getFlags().getAsInt("lewdOrcClaimTarget");
			if (claimedID >= 0)
			{
				local claimed = this.Tactical.getEntityByID(claimedID);
				if (claimed != null && claimed.isAlive())
				{
					if (actor.getSkills().hasSkill("effects.lewd_horny"))
					{
						actor.getSkills().getSkillByID("effects.lewd_horny").onRefresh();
						::logInfo("[orc_racial] " + actor.getName() + " refreshes horny (active claim on " + claimed.getName() + ")");
					}
					else
					{
						actor.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
						::logInfo("[orc_racial] " + actor.getName() + " becomes horny (active claim on " + claimed.getName() + ")");
					}
					return;
				}
			}
		}

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

			if (actor.getSkills().hasSkill("effects.lewd_horny"))
				return;

			if (target.allure() >= ::Lewd.Const.OrcHornyAllureThreshold)
			{
				::logInfo("[orc_racial] " + actor.getName() + " becomes horny from adjacent alluring target");
				actor.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
				return;
			}
		}
	}
});
