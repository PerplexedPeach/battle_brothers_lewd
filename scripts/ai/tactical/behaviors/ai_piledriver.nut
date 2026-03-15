// AI behavior for unhold boss piledriver ability.
// Prioritizes using piledriver on adjacent allure > 50 females.
// If no adjacent target, moves toward highest-allure female without triggering ZoC.
// Falls back to normal unhold behavior otherwise.
this.ai_piledriver <- this.inherit("scripts/ai/tactical/behavior", {
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
		this.m.ID = ::Lewd.Const.AIBehaviorIDPiledriver;
		this.m.Order = this.Const.AI.Behavior.Order.Protect;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		this.m.TargetTile = null;
		this.m.MoveTile = null;
		this.m.IsEngaging = false;

		::logInfo("[ai_piledriver] onEvaluate called for " + _entity.getName());

		if (!_entity.isAlive())
		{
			::logInfo("[ai_piledriver] Early exit: dead");
			return this.Const.AI.Behavior.Score.Zero;
		}

		local skill = _entity.getSkills().getSkillByID("actives.lewd_piledriver");
		if (skill == null || !skill.isUsable() || !skill.isAffordable())
		{
			::logInfo("[ai_piledriver] Early exit: skill=" + (skill == null ? "null" : (!skill.isUsable() ? "not usable" : "not affordable")));
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

			::logInfo("[ai_piledriver] Checking adjacent: " + target.getName() + " gender=" + target.getGender() + " pleasureMax=" + target.getPleasureMax());

			if (target.getGender() != 1) continue;
			if (target.getPleasureMax() <= 0) continue;

			local allure = target.allure();
			::logInfo("[ai_piledriver] " + target.getName() + " allure=" + allure);
			if (allure < 50) continue;

			local verified = skill.onVerifyTarget(myTile, adjTile);
			::logInfo("[ai_piledriver] " + target.getName() + " onVerifyTarget=" + verified);
			if (!verified) continue;

			if (allure > bestAllure)
			{
				bestAllure = allure;
				bestTarget = target;
				this.m.TargetTile = adjTile;
			}
		}

		if (bestTarget != null)
		{
			::logInfo("[ai_piledriver] Found adjacent target: " + bestTarget.getName() + " allure=" + bestAllure);
			return ::Lewd.Const.PiledriverAIScore;
		}

		// No adjacent target: try to move to engage highest allure female
		// Only move if it won't trigger zone of control attacks
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
			if (allure < 50) continue;

			if (allure <= bestEngageAllure) continue;

			// Find an empty tile adjacent to this target that we can reach
			local eTile = e.getTile();
			for (local d = 0; d < 6; d++)
			{
				if (!eTile.hasNextTile(d)) continue;
				local adjTile = eTile.getNextTile(d);
				if (!adjTile.IsEmpty) continue;
				if (this.Math.abs(adjTile.Level - myTile.Level) > 1) continue;

				// Check that the tile is not in enemy ZoC (to avoid opportunity attacks)
				if (adjTile.hasZoneOfControlOtherThan(_entity.getAlliedFactions()))
					continue;

				// Check we can actually reach it with remaining AP
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
			::logInfo("[ai_piledriver] Engaging toward: " + bestEngageTarget.getName() + " allure=" + bestEngageAllure);
			this.m.MoveTile = bestEngageTile;
			this.m.TargetTile = bestEngageTarget.getTile();
			this.m.IsEngaging = true;
			return ::Lewd.Const.PiledriverAIScore * 0.8;
		}

		return this.Const.AI.Behavior.Score.Zero;
	}

	function onExecute( _entity )
	{
		::logInfo("[ai_piledriver] onExecute called for " + _entity.getName());
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
				::logInfo("[ai_piledriver] skill.use result=" + result);
				return result;
			}
			else
			{
				::logInfo("[ai_piledriver] onExecute: skill not usable/affordable");
			}
		}

		return false;
	}
});
