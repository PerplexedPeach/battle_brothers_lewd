// Horny status effect — applied by sex abilities (50% on hit) and entrancing beauty
// Debuffs: -15% Initiative, -5 Melee Defense
// Sex abilities auto-hit horny targets
// Lasts 2 turns, refreshable
this.lewd_horny_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2,
		HasAIBehavior = false
	},
	function create()
	{
		this.m.ID = "effects.lewd_horny";
		this.m.Name = "Horny";
		this.m.Icon = "skills/lewd_horny.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Overwhelmed by arousal, unable to focus. Will wear off in [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] turn(s).";
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] Initiative"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.HornyMeleeDefPenalty + "[/color] Melee Defense"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Sex abilities [color=" + this.Const.UI.Color.NegativeValue + "]auto-hit[/color] this target"
			}
		];
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();

		// resistance check
		if (actor.getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
		{
			if (!actor.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " resisted becoming horny");
			}
			this.removeSelf();
			return;
		}

		this.m.TurnsLeft = ::Lewd.Const.HornyDuration;

		// Show horny sprite overlay (suppress if lewd seal is visible to avoid clutter)
		if (actor.hasSprite("status_horny"))
		{
			local sealVisible = actor.hasSprite("lewd_seal") && actor.getSprite("lewd_seal").Visible;
			actor.getSprite("status_horny").setBrush("bust_horny");
			actor.getSprite("status_horny").Visible = !sealVisible;
			actor.setDirty(true);
		}

		// Grant male sex skills to ALL male humanoids (player + enemy)
		local isMaleHumanoid = actor.getGender() != 1
			&& actor.getMoraleState() != this.Const.MoraleState.Ignore
			&& ::Lewd.Mastery.isHumanoid(actor);

		if (isMaleHumanoid)
		{
			::logInfo("[horny] " + actor.getName() + " became horny (gender:" + actor.getGender() + " playerControlled:" + actor.isPlayerControlled() + " goblin:" + ::Lewd.Mastery.isGoblin(actor) + ")");

			// Grant male sex skills if not already present
			if (!actor.getSkills().hasSkill("actives.male_grope"))
			{
				::logInfo("[horny]   granting male sex skills to " + actor.getName());
				actor.getSkills().add(this.new("scripts/skills/actives/male_grope_skill"));
				actor.getSkills().add(this.new("scripts/skills/actives/male_force_oral_skill"));
				actor.getSkills().add(this.new("scripts/skills/actives/male_penetrate_vaginal_skill"));
				actor.getSkills().add(this.new("scripts/skills/actives/male_penetrate_anal_skill"));
			}
		}
		else
		{
			::logInfo("[horny] " + actor.getName() + " became horny (no male skills: gender=" + actor.getGender() + " humanoid=" + ::Lewd.Mastery.isHumanoid(actor) + ")");
		}

		// Inject AI horny behaviors for non-player entities
		// Separate from sex skill granting -- spiders/unholds aren't humanoid but still need AI
		if (!actor.isPlayerControlled())
		{
			local agent = actor.getAIAgent();
			if (agent != null && !this.m.HasAIBehavior)
			{
				if (::Lewd.Mastery.isGoblin(actor))
				{
					::logInfo("[horny]   injecting GOBLIN AI behaviors for " + actor.getName());
					agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_goblin_horny"));
					agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_horny_engage"));
					agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_horny_idle"));
				}
				else if (::Lewd.Mastery.isOrc(actor))
				{
					::logInfo("[horny]   injecting ORC AI behaviors for " + actor.getName());
					agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_orc_horny"));
					agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_horny_engage"));
				}
				else if (::Lewd.Mastery.isUnhold(actor))
				{
					::logInfo("[horny]   injecting UNHOLD AI behaviors for " + actor.getName());
					agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_unhold_horny"));
					agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_horny_engage"));
				}
				else if (::Lewd.Mastery.isSpider(actor))
				{
					::logInfo("[horny]   injecting SPIDER AI behaviors for " + actor.getName());
					agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_spider_horny"));
					agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_horny_engage"));
				}
				else if (isMaleHumanoid)
				{
					::logInfo("[horny]   injecting AI behaviors for " + actor.getName());
					agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_horny"));
					agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_horny_engage"));
				}
				this.m.HasAIBehavior = true;
			}
		}
	}

	function onRefresh()
	{
		this.m.TurnsLeft = ::Lewd.Const.HornyDuration;
	}

	function onUpdate( _properties )
	{
		_properties.InitiativeMult *= ::Lewd.Const.HornyInitiativeMult;
		_properties.MeleeDefense += ::Lewd.Const.HornyMeleeDefPenalty;
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		// Don't remove AI behaviors here — doing so mid-execution (e.g. opportunity
		// attack during movement) hangs the AI. The behaviors already return 0 from
		// onEvaluate when the horny effect is gone, so they safely self-deactivate.

		if (actor.hasSprite("status_horny"))
		{
			actor.getSprite("status_horny").Visible = false;
		}

		actor.setDirty(true);
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints > ::Lewd.Const.HornyDamageRemoveThreshold)
			this.removeSelf();
	}

	function onTurnEnd()
	{
		// Pliant Body: horny doesn't tick down while mounting someone with the perk
		local actor = this.getContainer().getActor();
		if (actor.getSkills().hasSkill("effects.lewd_mounting"))
		{
			local mounting = actor.getSkills().getSkillByID("effects.lewd_mounting");
			local target = this.Tactical.getEntityByID(mounting.getTargetID());
			if (target != null && target.isAlive() && target.getSkills().hasSkill("perk.lewd_pliant_body"))
				return;
		}

		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});
