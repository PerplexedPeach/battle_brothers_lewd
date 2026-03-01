// Vaginal skill — Straddle (T1) -> Riding (T2) -> Cowgirl (T3)
// T1 establishes mount, T2/T3 require mounted target
// Scales with Initiative
this.vaginal_skill <- this.inherit("scripts/skills/actives/lewd_sex_skill", {
	m = {},
	function create()
	{
		this.lewd_sex_skill.create();
		this.m.ID = "actives.lewd_vaginal";
		this.m.SexType = "vaginal";
		this.m.MasteryID = "effects.lewd_mastery_vaginal";
		this.m.PerkID = "perk.lewd_mounting";
		this.m.ScalingText = "Initiative";
		this.m.T3Debuff = { AP = ::Lewd.Const.VaginalT3APDebuff, Duration = ::Lewd.Const.VaginalT3DebuffDuration };
		this.m.Tiers = [
			{
				Name = "Straddle",
				Description = "Climb on top of the target, establishing a mount and dealing pleasure.",
				Icon = "skills/lewd_vaginal_t1.png",
				IconDisabled = "skills/lewd_vaginal_t1_bw.png",
				Overlay = "lewd_vaginal_t1",
				AP = ::Lewd.Const.VaginalT1AP,
				Fatigue = ::Lewd.Const.VaginalT1Fatigue,
				BasePleasure = ::Lewd.Const.VaginalT1BasePleasure,
				BaseHitChance = ::Lewd.Const.VaginalT1BaseHitChance,
				InitiativeScale = ::Lewd.Const.VaginalT1InitiativeScale,
				MountBonus = 0,
				HitText = ["straddles", "mounts"],
				MissText = ["straddle", "mount"]
			},
			{
				Name = "Riding",
				Description = "Ride the mounted target with practiced rhythm.",
				Icon = "skills/lewd_vaginal_t2.png",
				IconDisabled = "skills/lewd_vaginal_t2_bw.png",
				Overlay = "lewd_vaginal_t2",
				AP = ::Lewd.Const.VaginalT2AP,
				Fatigue = ::Lewd.Const.VaginalT2Fatigue,
				BasePleasure = ::Lewd.Const.VaginalT2BasePleasure,
				BaseHitChance = ::Lewd.Const.VaginalT2BaseHitChance,
				InitiativeScale = ::Lewd.Const.VaginalT2InitiativeScale,
				MountBonus = 0,
				HitText = ["rides", "grinds on"],
				MissText = ["ride", "grind on"]
			},
			{
				Name = "Cowgirl",
				Description = "Ride with expert skill, automatically succeeding and draining the target's action points.",
				Icon = "skills/lewd_vaginal_t3.png",
				IconDisabled = "skills/lewd_vaginal_t3_bw.png",
				Overlay = "lewd_vaginal_t3",
				AP = ::Lewd.Const.VaginalT3AP,
				Fatigue = ::Lewd.Const.VaginalT3Fatigue,
				BasePleasure = ::Lewd.Const.VaginalT3BasePleasure,
				BaseHitChance = ::Lewd.Const.VaginalT3BaseHitChance,
				InitiativeScale = ::Lewd.Const.VaginalT3InitiativeScale,
				MountBonus = 0,
				HitText = ["rides with expert rhythm", "grinds relentlessly on"],
				MissText = ["ride", "grind on"]
			}
		];
		this.m.Name = this.m.Tiers[0].Name;
		this.m.Description = this.m.Tiers[0].Description;
		this.m.Icon = this.m.Tiers[0].Icon;
		this.m.IconDisabled = this.m.Tiers[0].IconDisabled;
		this.m.Overlay = this.m.Tiers[0].Overlay;
		this.m.ActionPointCost = this.m.Tiers[0].AP;
		this.m.FatigueCost = this.m.Tiers[0].Fatigue;
	}

	function getFatigueCost()
	{
		local fat = this.getTierConfig().Fatigue;
		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryVaginalFatigueThreshold)
			fat += ::Lewd.Const.MasteryVaginalFatigueBonus;
		return this.Math.max(1, fat);
	}

	function getHitChanceAgainst( _target )
	{
		// T3 Cowgirl: auto-success
		if (this.getTier() >= 3) return 100;
		return this.lewd_sex_skill.getHitChanceAgainst(_target);
	}

	function calculateStatPleasure( _target )
	{
		local user = this.getContainer().getActor();
		return this.Math.floor(user.getInitiative() * this.getTierConfig().InitiativeScale);
	}

	function calculateMasteryPleasureBonus()
	{
		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryVaginalPleasureThreshold)
			return ::Lewd.Const.MasteryVaginalPleasureBonus;
		return 0;
	}

	function getSelfPleasure()
	{
		local tier = this.getTier();
		local selfP;
		if (tier >= 3) selfP = ::Lewd.Const.VaginalT3SelfPleasure;
		else if (tier >= 2) selfP = ::Lewd.Const.VaginalT2SelfPleasure;
		else selfP = ::Lewd.Const.VaginalT1SelfPleasure;

		// Vaginal mastery self-pleasure reduction
		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryVaginalSelfPleasureThreshold)
			selfP = this.Math.floor(selfP * ::Lewd.Const.MasteryVaginalSelfPleasureMult);

		return selfP;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.lewd_sex_skill.onVerifyTarget(_originTile, _targetTile)) return false;

		local tier = this.getTier();
		if (tier == 1) return true;

		// T2/T3: requires user and target to be in a mount relationship (either direction)
		local user = this.m.Container.getActor();
		local target = _targetTile.getEntity();
		return ::Lewd.Mastery.isMountedWith(user, target);
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;

		this.playSound(_user);
		local tier = this.getTier();

		// T1: establish mount first
		if (tier == 1)
		{
			local hitResult = this.rollHit(_user, target);
			if (!hitResult.hit)
			{
				this.logMiss(_user, target, hitResult);
				return true;
			}

			this.applyMount(_user, target);
			local pleasure = this.calculatePleasure(target);
			target.addPleasure(pleasure, _user);
			this.logHit(_user, target, pleasure, hitResult);
			this.tryApplyHorny(target);
		}
		else
		{
			// T2/T3: mounted continuation
			local hitResult = this.rollHit(_user, target);
			if (!hitResult.hit)
			{
				this.logMiss(_user, target, hitResult);
				return true;
			}

			local pleasure = this.calculatePleasure(target);
			target.addPleasure(pleasure, _user);
			this.logHit(_user, target, pleasure, hitResult);
			this.tryApplyHorny(target);

			// refresh mount duration (whichever direction exists)
			local mountedEffect = target.getSkills().getSkillByID("effects.lewd_mounted");
			if (mountedEffect != null)
				mountedEffect.setTurns(::Lewd.Const.MountDuration);
			local userMountedEffect = _user.getSkills().getSkillByID("effects.lewd_mounted");
			if (userMountedEffect != null)
				userMountedEffect.setTurns(::Lewd.Const.MountDuration);
		}

		// self-pleasure
		this.applySelfPleasure(_user, target);

		// T3 extra: AP debuff
		this.applyT3Debuff(target);

		this.recordSexContinuation(_user, target);
		return true;
	}

	function applyMount( _user, _target )
	{
		if (!_target.getSkills().hasSkill("effects.lewd_mounted"))
		{
			local mounted = this.new("scripts/skills/effects/lewd_mounted_effect");
			mounted.setMounter(_user.getID());
			_target.getSkills().add(mounted);
		}
		else
		{
			local mounted = _target.getSkills().getSkillByID("effects.lewd_mounted");
			mounted.setMounter(_user.getID());
			mounted.setTurns(::Lewd.Const.MountDuration);
		}

		if (!_user.getSkills().hasSkill("effects.lewd_mounting"))
		{
			local mounting = this.new("scripts/skills/effects/lewd_mounting_effect");
			mounting.setTarget(_target.getID());
			_user.getSkills().add(mounting);
		}
		else
		{
			local mounting = _user.getSkills().getSkillByID("effects.lewd_mounting");
			mounting.setTarget(_target.getID());
		}
	}

	function getTooltip()
	{
		local result = [
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Deals pleasure to the target (scales with " + this.m.ScalingText + ")"
			}
		];

		local tier = this.getTier();
		if (tier == 1)
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Establishes mount[/color] on the target"
			});
		}
		else
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Requires[/color] mount with target (either direction)"
			});
		}

		if (tier >= 3)
		{
			result.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Auto-success[/color] (always hits)"
			});
			result.push({
				id = 8,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Applies [color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.VaginalT3APDebuff + "[/color] AP debuff for " + ::Lewd.Const.VaginalT3DebuffDuration + " turn"
			});
		}

		local selfP = this.getSelfPleasure();
		if (selfP > 0)
		{
			result.push({
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + selfP + "[/color] self-pleasure"
			});
		}

		return result;
	}
});
