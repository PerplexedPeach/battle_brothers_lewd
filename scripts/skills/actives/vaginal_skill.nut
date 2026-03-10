// Vaginal skill — Straddle (T1) -> Riding (T2) -> Cowgirl (T3)
// All tiers establish/refresh mount on target
// Scales with Initiative
this.vaginal_skill <- this.inherit("scripts/skills/actives/female_sex_skill", {
	m = {},
	function create()
	{
		this.female_sex_skill.create();
		this.m.SexDelay = 2000;
		this.m.ShakeCount = 4;
		this.m.ShakeIntensity = 4;
		this.m.ShakeTargetAway = true;
		this.m.ShakeTargetIntensity = 6;
		this.m.Delay = 2000;
		this.m.SoundOnHit = ::Lewd.Const.SoundFucking;
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

	function getAPCost()
	{
		local ap = this.getTierConfig().AP;
		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryVaginalAPThreshold)
			ap += ::Lewd.Const.MasteryVaginalAPBonus;
		if (this.getContainer().getActor().getSkills().hasSkill("effects.lewd_mounting"))
			ap -= ::Lewd.Const.MountedAPDiscount;
		return this.Math.max(1, ap);
	}

	function getHitChanceAgainst( _target )
	{
		// T3 Cowgirl: auto-success
		if (this.getTier() >= 3) return 100;
		return this.female_sex_skill.getHitChanceAgainst(_target);
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

	function onScheduledSexHit( _info )
	{
		_info.Container.setBusy(false);

		local user = _info.User;
		local target = _info.Target;

		if (!user.isAlive() || !target.isAlive()) return;

		local hitResult = _info.HitResult;

		if (!hitResult.hit)
		{
			this.logMiss(user, target, hitResult);
			return;
		}

		this.applyMount(user, target);
		local pleasure = this.calculatePleasure(target);
		local actualPleasure = target.addPleasure(pleasure, user);
		this.tryApplyHorny(target);

		local selfP = this.applySelfPleasure(user, target);
		this.applyT3Debuff(target);
		this.logHit(user, target, actualPleasure, hitResult, selfP);
		this.recordSexContinuation(user, target);
	}

	function applyMount( _user, _target )
	{
		if (!_target.getSkills().hasSkill("effects.lewd_mounted"))
		{
			local mounted = this.new("scripts/skills/effects/lewd_mounted_effect");
			_target.getSkills().add(mounted);
			mounted.addMounter(_user.getID());
			mounted.setTurns(::Lewd.Const.MountDuration);
		}
		else
		{
			local mounted = _target.getSkills().getSkillByID("effects.lewd_mounted");
			mounted.addMounter(_user.getID());
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
		local pos = this.Const.UI.Color.PositiveValue;
		local neg = this.Const.UI.Color.NegativeValue;
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
			}
		];

		// Pleasure info
		result.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Deals [color=" + pos + "]pleasure[/color] to the target (scales with " + this.m.ScalingText + ")"
		});

		// Hit chance
		local tier = this.getTier();
		if (tier >= 3)
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + pos + "]Always hits[/color]"
			});
		}
		else
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Hit chance: [color=" + pos + "]" + this.getBaseHitChance() + "%[/color] base, modified by Allure vs target Resolve"
			});
		}

		// Mount mechanic
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + pos + "]Establishes mount[/color] on the target"
		});

		// Self-pleasure
		local selfP = this.getSelfPleasure();
		if (selfP > 0)
		{
			result.push({
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts [color=" + neg + "]" + selfP + "[/color] pleasure on yourself"
			});
		}

		// Horny chance
		result.push({
			id = 9,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + pos + "]" + ::Lewd.Const.HornyApplyChance + "%[/color] chance to inflict Horny on hit"
		});

		return result;
	}
});
