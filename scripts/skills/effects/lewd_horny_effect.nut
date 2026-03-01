// Horny status effect — applied by sex abilities (50% on hit) and entrancing beauty
// Debuffs: -15 Resolve, -15% Initiative, -5 Melee Defense
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
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.HornyResolvePenalty + "[/color] Resolve"
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

		// AI integration: grant sex skills and inject behavior for non-player male humanoids
		if (!actor.isPlayerControlled() && actor.getGender() != 1 && actor.getMoraleState() != this.Const.MoraleState.Ignore && ::Lewd.Mastery.isHumanoid(actor))
		{
			::logInfo("[horny] " + actor.getName() + " became horny (gender:" + actor.getGender() + " playerControlled:" + actor.isPlayerControlled() + ")");

			// Grant male sex skills if not already present
			if (!actor.getSkills().hasSkill("actives.male_grope"))
			{
				::logInfo("[horny]   granting male sex skills to " + actor.getName());
				actor.getSkills().add(this.new("scripts/skills/actives/male_grope_skill"));
				actor.getSkills().add(this.new("scripts/skills/actives/male_force_oral_skill"));
				actor.getSkills().add(this.new("scripts/skills/actives/male_penetrate_vaginal_skill"));
				actor.getSkills().add(this.new("scripts/skills/actives/male_penetrate_anal_skill"));
			}

			// Inject AI horny behaviors into existing agent
			local agent = actor.getAIAgent();
			if (agent != null && !this.m.HasAIBehavior)
			{
				::logInfo("[horny]   injecting AI behaviors for " + actor.getName());
				agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_horny"));
				agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_horny_engage"));
				this.m.HasAIBehavior = true;
			}
		}
		else
		{
			::logInfo("[horny] " + actor.getName() + " became horny (no AI: player=" + actor.isPlayerControlled() + " gender=" + actor.getGender() + " moraleIgnore=" + (actor.getMoraleState() == this.Const.MoraleState.Ignore) + " humanoid=" + ::Lewd.Mastery.isHumanoid(actor) + ")");
		}
	}

	function onRefresh()
	{
		this.m.TurnsLeft = ::Lewd.Const.HornyDuration;
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += ::Lewd.Const.HornyResolvePenalty;
		_properties.InitiativeMult *= ::Lewd.Const.HornyInitiativeMult;
		_properties.MeleeDefense += ::Lewd.Const.HornyMeleeDefPenalty;

		local actor = this.getContainer().getActor();
		if (actor.hasSprite("status_horny"))
		{
			actor.getSprite("status_horny").setBrush("bust_horny");
			actor.getSprite("status_horny").Visible = true;
			actor.setDirty(true);
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		// Remove AI behaviors if we injected them
		if (this.m.HasAIBehavior)
		{
			local agent = actor.getAIAgent();
			if (agent != null)
			{
				agent.removeBehavior(::Lewd.Const.AIBehaviorIDHorny);
				agent.removeBehavior(::Lewd.Const.AIBehaviorIDHornyEngage);
			}
			this.m.HasAIBehavior = false;
		}

		if (actor.hasSprite("status_horny"))
		{
			actor.getSprite("status_horny").Visible = false;
		}

		actor.setDirty(true);
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

	function onCombatFinished()
	{
		this.removeSelf();
	}
});
