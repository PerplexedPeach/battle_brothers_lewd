// AI behavior for horny unholds -- uses piledriver on adjacent targets.
// Horny-gated: only evaluates when the unhold has the horny effect.
// If no adjacent target, attempts short-range move + piledriver in same turn.
// Long-range movement is handled by ai_horny_engage (separate behavior).
this.ai_unhold_horny <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		MoveTile = null,
		PossibleSkills = [
			"actives.lewd_piledriver"
		],
		IsEngaging = false
	},
	function create()
	{
		this.m.ID = ::Lewd.Const.AIBehaviorIDUnholdHorny;
		this.m.Order = this.Const.AI.Behavior.Order.Protect;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		this.m.TargetTile = null;
		this.m.MoveTile = null;
		this.m.IsEngaging = false;

		if (!_entity.isAlive())
			return this.Const.AI.Behavior.Score.Zero;

		// Must be horny (regular unholds only piledriver when aroused)
		if (!_entity.getSkills().hasSkill("effects.lewd_horny"))
			return this.Const.AI.Behavior.Score.Zero;

		local skill = _entity.getSkills().getSkillByID("actives.lewd_piledriver");
		if (skill == null || !skill.isUsable() || !skill.isAffordable())
		{
			::logInfo("[ai_unhold_horny] Early exit: skill=" + (skill == null ? "null" : (!skill.isUsable() ? "not usable" : "not affordable")));
			return this.Const.AI.Behavior.Score.Zero;
		}

		local myTile = _entity.getTile();

		// Check adjacent tiles for valid piledriver targets
		local bestTarget = null;
		local bestAllure = 0;

		for (local i = 0; i < 6; i++)
		{
			if (!myTile.hasNextTile(i)) continue;
			local adjTile = myTile.getNextTile(i);
			if (!adjTile.IsOccupiedByActor) continue;

			local target = adjTile.getEntity();
			if (target == null || target.isAlliedWith(_entity)) continue;
			if (target.getGender() != 1) continue;
			if (target.getPleasureMax() <= 0) continue;

			local verified = skill.onVerifyTarget(myTile, adjTile);
			if (!verified) continue;

			local allure = target.allure();
			::logInfo("[ai_unhold_horny] Adjacent target: " + target.getName() + " allure=" + allure);

			if (allure > bestAllure)
			{
				bestAllure = allure;
				bestTarget = target;
				this.m.TargetTile = adjTile;
			}
		}

		if (bestTarget != null)
		{
			local score = (bestAllure * ::Lewd.Const.UnholdHornyAIScorePerAllure).tointeger();
			::logInfo("[ai_unhold_horny] Using piledriver on: " + bestTarget.getName() + " allure=" + bestAllure + " score=" + score);
			return score;
		}

		// No adjacent target: try to move + piledriver in same turn
		// Unholds have 9 AP, piledriver costs 7 -- only 2 AP for movement (~1 tile)
		local opponents = _entity.getAIAgent().getKnownOpponents();
		local bestEngageTarget = null;
		local bestEngageAllure = 0;
		local bestEngageTile = null;

		foreach (opp in opponents)
		{
			local e = opp.Actor;
			if (!e.isAlive() || e.getGender() != 1) continue;
			if (e.getPleasureMax() <= 0) continue;

			local allure = e.allure();
			if (allure <= bestEngageAllure) continue;

			// Find an empty tile adjacent to this target that we can reach
			local eTile = e.getTile();
			for (local d = 0; d < 6; d++)
			{
				if (!eTile.hasNextTile(d)) continue;
				local adjTile = eTile.getNextTile(d);
				if (!adjTile.IsEmpty) continue;
				if (this.Math.abs(adjTile.Level - myTile.Level) > 1) continue;

				// Avoid tiles in enemy ZoC
				if (adjTile.hasZoneOfControlOtherThan(_entity.getAlliedFactions()))
					continue;

				// Check we can reach it with AP left for piledriver
				local navSettings = this.Tactical.getNavigator().createSettings();
				navSettings.ActionPointCosts = _entity.getActionPointCosts();
				navSettings.AllowZoneOfControlPassing = false;
				local path = this.Tactical.getNavigator().findPath(myTile, adjTile, navSettings, 0);

				if (!path.isEmpty() && path.getCost() <= _entity.getActionPoints() - skill.getActionPointCost())
				{
					bestEngageAllure = allure;
					bestEngageTarget = e;
					bestEngageTile = adjTile;
				}
			}
		}

		if (bestEngageTarget != null)
		{
			local score = (bestEngageAllure * ::Lewd.Const.UnholdHornyAIScorePerAllure * 0.8).tointeger();
			::logInfo("[ai_unhold_horny] Move+piledriver toward: " + bestEngageTarget.getName() + " allure=" + bestEngageAllure + " score=" + score);
			this.m.MoveTile = bestEngageTile;
			this.m.TargetTile = bestEngageTarget.getTile();
			this.m.IsEngaging = true;
			return score;
		}

		return this.Const.AI.Behavior.Score.Zero;
	}

	function onExecute( _entity )
	{
		::logInfo("[ai_unhold_horny] onExecute called for " + _entity.getName());
		if (!_entity.isAlive()) return false;

		if (this.m.IsEngaging && this.m.MoveTile != null)
		{
			// Move toward target first
			local navSettings = this.Tactical.getNavigator().createSettings();
			navSettings.ActionPointCosts = _entity.getActionPointCosts();
			navSettings.AllowZoneOfControlPassing = false;
			this.Tactical.getNavigator().travel(_entity, this.m.MoveTile, navSettings);

			// After moving, re-check if we can piledriver
			local skill = _entity.getSkills().getSkillByID("actives.lewd_piledriver");
			if (skill != null && skill.isUsable() && skill.isAffordable() && this.m.TargetTile != null
				&& this.m.TargetTile.IsOccupiedByActor
				&& skill.onVerifyTarget(_entity.getTile(), this.m.TargetTile))
			{
				skill.use(this.m.TargetTile);
			}

			this.m.IsEngaging = false;
			return true;
		}

		if (this.m.TargetTile != null)
		{
			local skill = _entity.getSkills().getSkillByID("actives.lewd_piledriver");
			if (skill != null && skill.isUsable() && skill.isAffordable())
			{
				local result = skill.use(this.m.TargetTile);
				::logInfo("[ai_unhold_horny] skill.use result=" + result);
				return result;
			}
		}

		return false;
	}
});
