// AI behavior for horny spiders -- injects eggs into rooted targets, webs non-rooted targets.
// Horny-gated: only evaluates when the spider has the horny effect.
// Prefers inject on rooted targets (any root source, not just web) over webbing new targets.
// Allure-scaled scoring like other beast species.
this.ai_spider_horny <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
		SkillToUse = null,
		PossibleSkills = [
			"actives.spider_inject",
			"actives.web"
		]
	},
	function create()
	{
		this.m.ID = ::Lewd.Const.AIBehaviorIDSpiderHorny;
		this.m.Order = this.Const.AI.Behavior.Order.Protect;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		this.m.TargetTile = null;
		this.m.SkillToUse = null;

		if (!_entity.isAlive())
			return this.Const.AI.Behavior.Score.Zero;

		// Must be horny
		if (!_entity.getSkills().hasSkill("effects.lewd_horny"))
			return this.Const.AI.Behavior.Score.Zero;

		local injectSkill = _entity.getSkills().getSkillByID("actives.spider_inject");
		local webSkill = _entity.getSkills().getSkillByID("actives.web");
		local myTile = _entity.getTile();
		local ap = _entity.getActionPoints();

		::logInfo("[ai_spider_horny] " + _entity.getName() + " evaluating (AP:" + ap + " inject:" + (injectSkill != null) + " web:" + (webSkill != null) + ")");

		// Scan adjacent tiles for alluring female targets
		local bestInjectTarget = null;
		local bestInjectAllure = 0;
		local bestInjectTile = null;

		local bestWebTarget = null;
		local bestWebAllure = 0;
		local bestWebTile = null;

		local adjCount = 0;
		for (local i = 0; i < 6; i++)
		{
			if (!myTile.hasNextTile(i)) continue;
			local adjTile = myTile.getNextTile(i);
			if (!adjTile.IsOccupiedByActor) continue;

			local target = adjTile.getEntity();
			if (target == null || target.isAlliedWith(_entity)) continue;
			if (target.getGender() != 1) continue;
			if (target.getPleasureMax() <= 0) continue;

			adjCount++;
			local allure = target.allure();

			// If target is rooted (webbed): candidate for inject
			if (target.getCurrentProperties().IsRooted)
			{
				if (injectSkill != null && injectSkill.isUsable() && injectSkill.isAffordable()
					&& injectSkill.onVerifyTarget(myTile, adjTile))
				{
					if (allure > bestInjectAllure)
					{
						bestInjectAllure = allure;
						bestInjectTarget = target;
						bestInjectTile = adjTile;
					}
				}
				else
				{
					::logInfo("[ai_spider_horny]   inject rejected for " + target.getName() + " (usable:" + (injectSkill != null ? injectSkill.isUsable() : "null") + " affordable:" + (injectSkill != null ? injectSkill.isAffordable() : "null") + ")");
				}
			}
			else
			{
				// Target not webbed: candidate for webbing
				if (webSkill != null && webSkill.isUsable() && webSkill.isAffordable()
					&& !target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
				{
					if (allure > bestWebAllure)
					{
						bestWebAllure = allure;
						bestWebTarget = target;
						bestWebTile = adjTile;
					}
				}
				else
				{
					::logInfo("[ai_spider_horny]   web rejected for " + target.getName() + " (skill:" + (webSkill != null) + " usable:" + (webSkill != null ? webSkill.isUsable() : "null") + " affordable:" + (webSkill != null ? webSkill.isAffordable() : "null") + " immuneGrab:" + target.getCurrentProperties().IsImmuneToKnockBackAndGrab + ")");
				}
			}
		}

		// Prefer inject over web (webbed target is ready)
		if (bestInjectTarget != null)
		{
			local score = (bestInjectAllure * ::Lewd.Const.SpiderHornyAIScorePerAllure).tointeger();
			::logInfo("[ai_spider_horny] Inject target: " + bestInjectTarget.getName() + " allure=" + bestInjectAllure + " score=" + score);
			this.m.TargetTile = bestInjectTile;
			this.m.SkillToUse = injectSkill;
			return score;
		}

		// Web an alluring target (lower priority -- uses separate web score constant)
		if (bestWebTarget != null)
		{
			local score = (bestWebAllure * ::Lewd.Const.SpiderWebAIScorePerAllure).tointeger();
			::logInfo("[ai_spider_horny] Web target: " + bestWebTarget.getName() + " allure=" + bestWebAllure + " score=" + score);
			this.m.TargetTile = bestWebTile;
			this.m.SkillToUse = webSkill;
			return score;
		}

		::logInfo("[ai_spider_horny] " + _entity.getName() + " no targets (adjCandidates:" + adjCount + ")");
		return this.Const.AI.Behavior.Score.Zero;
	}

	function onExecute( _entity )
	{
		::logInfo("[ai_spider_horny] onExecute called for " + _entity.getName());
		if (!_entity.isAlive()) return true;

		if (this.m.TargetTile != null && this.m.SkillToUse != null)
		{
			if (this.m.SkillToUse.isAffordable())
			{
				local result = this.m.SkillToUse.use(this.m.TargetTile);
				::logInfo("[ai_spider_horny] " + this.m.SkillToUse.getID() + " result=" + result);
				// Always return true so the engine re-evaluates rather than re-executing
				// this behavior in a loop. The skill.use() return value is not a reliable
				// done/not-done signal (web skill onUse returns null on success).
				return true;
			}
			else
			{
				::logInfo("[ai_spider_horny] Skill no longer affordable");
			}
		}

		return true;
	}
});
