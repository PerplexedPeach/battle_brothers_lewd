// AI behavior for orcs -- claim unclaimed alluring targets
// Always active (injected by racial, not gated by horny), but only evaluates when horny
// Highest priority orc behavior -- claim before using sex skills
this.ai_orc_claim <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		SelectedSkill = null,
		GaveUp = false
	},
	function create()
	{
		this.m.ID = ::Lewd.Const.AIBehaviorIDOrcClaim;
		this.m.Order = this.Const.AI.Behavior.Order.AttackDefault;
		this.behavior.create();
	}

	function onTurnStarted()
	{
		this.m.GaveUp = false;
	}

	function onEvaluate( _entity )
	{
		::logInfo("[ai_orc_claim] " + _entity.getName() + " evaluating (AP:" + _entity.getActionPoints() + " GaveUp:" + this.m.GaveUp + ")");

		if (this.m.GaveUp)
			return 0;

		// Must be horny to claim
		if (!_entity.getSkills().hasSkill("effects.lewd_horny"))
			return 0;

		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
			return 0;

		// Must not already have an active claim on a living target
		if (_entity.getFlags().has("lewdOrcClaimTarget"))
		{
			local existingID = _entity.getFlags().getAsInt("lewdOrcClaimTarget");
			if (existingID >= 0)
			{
				local existing = this.Tactical.getEntityByID(existingID);
				if (existing != null && existing.isAlive())
				{
					::logInfo("[ai_orc_claim] " + _entity.getName() + " already has claim on " + existing.getName());
					return 0;
				}
				// Claimed target is dead, clear stale flag
				_entity.getFlags().set("lewdOrcClaimTarget", -1);
			}
		}

		// Must have the claim skill
		local claimSkill = _entity.getSkills().getSkillByID("actives.orc_claim");
		if (claimSkill == null)
		{
			::logInfo("[ai_orc_claim] " + _entity.getName() + " has no claim skill");
			this.m.GaveUp = true;
			return 0;
		}

		if (!claimSkill.isUsable())
		{
			::logInfo("[ai_orc_claim] " + _entity.getName() + " claim not usable");
			return 0;
		}

		// Find adjacent unclaimed female target with highest allure
		local myTile = _entity.getTile();
		local bestTile = null;
		local bestAllure = 0;

		for (local i = 0; i < 6; i++)
		{
			if (!myTile.hasNextTile(i)) continue;
			local tile = myTile.getNextTile(i);
			if (!tile.IsOccupiedByActor) continue;
			local target = tile.getEntity();
			if (target == null || !target.isAlive()) continue;
			if (_entity.isAlliedWith(target)) continue;

			if (!claimSkill.onVerifyTarget(myTile, tile))
				continue;

			local allure = target.allure();
			::logInfo("[ai_orc_claim]   adj: " + target.getName() + " allure:" + allure + " claimed:" + target.getSkills().hasSkill("effects.orc_claimed"));

			if (allure > bestAllure)
			{
				bestAllure = allure;
				bestTile = tile;
			}
		}

		if (bestTile == null)
			return 0;

		this.m.TargetTile = bestTile;
		this.m.SelectedSkill = claimSkill;

		local score = ::Lewd.Const.OrcClaimAIScore * this.getProperties().BehaviorMult[this.m.ID];
		::logInfo("[ai_orc_claim] " + _entity.getName() + " will claim " + bestTile.getEntity().getName() + " (score:" + score + ")");
		return score;
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			this.m.IsFirstExecuted = false;
			if (this.m.TargetTile != null)
				this.getAgent().adjustCameraToTarget(this.m.TargetTile);
			return false;
		}

		local apBefore = _entity.getActionPoints();
		if (this.m.SelectedSkill != null && this.m.TargetTile != null && this.m.TargetTile.IsOccupiedByActor)
		{
			::logInfo("[ai_orc_claim] " + _entity.getName() + " EXECUTING claim on " + this.m.TargetTile.getEntity().getName());
			this.m.SelectedSkill.use(this.m.TargetTile);

			if (_entity.isAlive())
				this.getAgent().declareAction();
		}

		if (_entity.isAlive() && _entity.getActionPoints() >= apBefore)
		{
			::logInfo("[ai_orc_claim] " + _entity.getName() + " skill did not consume AP, giving up");
			this.m.GaveUp = true;
		}

		this.m.TargetTile = null;
		this.m.SelectedSkill = null;
		return true;
	}
});
