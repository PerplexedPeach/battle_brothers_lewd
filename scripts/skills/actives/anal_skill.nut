// Anal skill — Bend Over (T1) -> Rough It (T2) -> Breaking Point (T3)
// All tiers establish/refresh reverse mount (enemy mounts user)
// Requires masochism tiers for upgrades
this.anal_skill <- this.inherit("scripts/skills/actives/female_sex_skill", {
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
		this.m.ID = "actives.lewd_anal";
		this.m.SexType = "anal";
		this.m.MasteryID = "effects.lewd_mastery_anal";
		this.m.PerkID = "perk.lewd_offering";
		this.m.ScalingText = "submission and masochism";
		this.m.T3Debuff = null;
		this.m.Tiers = [
			{
				Name = "Bend Over",
				Description = "Bend over for the target, allowing them to mount you and dealing pleasure to both.",
				Icon = "skills/lewd_anal_t1.png",
				IconDisabled = "skills/lewd_anal_t1_bw.png",
				Overlay = "lewd_anal_t1",
				AP = ::Lewd.Const.AnalT1AP,
				Fatigue = ::Lewd.Const.AnalT1Fatigue,
				BasePleasure = ::Lewd.Const.AnalT1BasePleasure,
				BaseHitChance = ::Lewd.Const.AnalT1BaseHitChance,
				SubScale = ::Lewd.Const.AnalT1SubScale,
				MountBonus = 0,
				HitText = ["bends over for", "presents herself to"],
				MissText = ["present to", "entice"]
			},
			{
				Name = "Rough It",
				Description = "Endure the rough treatment, channeling the experience into pleasure for both.",
				Icon = "skills/lewd_anal_t2.png",
				IconDisabled = "skills/lewd_anal_t2_bw.png",
				Overlay = "lewd_anal_t2",
				AP = ::Lewd.Const.AnalT2AP,
				Fatigue = ::Lewd.Const.AnalT2Fatigue,
				BasePleasure = ::Lewd.Const.AnalT2BasePleasure,
				BaseHitChance = ::Lewd.Const.AnalT2BaseHitChance,
				SubScale = ::Lewd.Const.AnalT2SubScale,
				MountBonus = 0,
				HitText = ["endures the pounding from", "takes it from"],
				MissText = ["take from", "endure"]
			},
			{
				Name = "Breaking Point",
				Description = "Push yourself to the breaking point, converting agony into devastating pleasure for the enemy. If you climax during this, deal massive bonus pleasure.",
				Icon = "skills/lewd_anal_t3.png",
				IconDisabled = "skills/lewd_anal_t3_bw.png",
				Overlay = "lewd_anal_t3",
				AP = ::Lewd.Const.AnalT3AP,
				Fatigue = ::Lewd.Const.AnalT3Fatigue,
				BasePleasure = ::Lewd.Const.AnalT3BasePleasure,
				BaseHitChance = ::Lewd.Const.AnalT3BaseHitChance,
				SubScale = ::Lewd.Const.AnalT3SubScale,
				MountBonus = 0,
				HitText = ["is broken by", "pushes to the limit with"],
				MissText = ["endure", "take from"]
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

	function getTier()
	{
		local mastery = ::Lewd.Mastery.getMasteryTier(this.getContainer().getActor(), this.m.MasteryID);
		local masoTier = ::Lewd.Mastery.getMasoTier(this.getContainer().getActor());
		if (mastery >= 3 && masoTier >= 3) return 3;
		if (mastery >= 2 && masoTier >= 2) return 2;
		return 1;
	}

	function isUsable()
	{
		if (!this.skill.isUsable()) return false;
		local masoTier = ::Lewd.Mastery.getMasoTier(this.getContainer().getActor());
		return masoTier >= 1;
	}

	function calculateStatPleasure( _target )
	{
		local user = this.getContainer().getActor();
		local tier = this.getTier();
		local cfg = this.getTierConfig();
		local masoTier = ::Lewd.Mastery.getMasoTier(user);
		local subScore = ::Lewd.Mastery.getSubScore(user);
		local pleasure = 0;

		if (tier >= 3) pleasure = masoTier * ::Lewd.Const.AnalT3MasoTierBonus;
		else if (tier >= 2) pleasure = masoTier * ::Lewd.Const.AnalT2MasoTierBonus;

		if (subScore > 0)
			pleasure += this.Math.floor(subScore * cfg.SubScale);

		return pleasure;
	}

	function calculateMasteryPleasureBonus()
	{
		return 0;
	}

	function getAPCost()
	{
		local ap = this.getTierConfig().AP;
		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryAnalAPThreshold)
			ap += ::Lewd.Const.MasteryAnalAPBonus;
		return this.Math.max(1, ap);
	}

	function getSelfPleasure()
	{
		local user = this.getContainer().getActor();
		local tier = this.getTier();
		local selfP;
		if (tier >= 3) selfP = ::Lewd.Const.AnalT3SelfPleasure;
		else if (tier >= 2) selfP = ::Lewd.Const.AnalT2SelfPleasure;
		else selfP = ::Lewd.Const.AnalT1SelfPleasure;

		// (Pliant Body reflection now handled centrally in applySelfPleasure)

		return selfP;
	}

	function getSelfDamage()
	{
		local tier = this.getTier();
		if (tier >= 3) return ::Lewd.Const.AnalT3SelfDamage;
		if (tier >= 2) return ::Lewd.Const.AnalT2SelfDamage;
		return ::Lewd.Const.AnalT1SelfDamage;
	}

	function onScheduledSexHit( _info )
	{
		_info.Container.setBusy(false);

		local user = _info.User;
		local target = _info.Target;

		if (!user.isAlive() || !target.isAlive()) return;

		local tier = this.getTier();
		local hitResult = _info.HitResult;

		if (!hitResult.hit)
		{
			this.logMiss(user, target, hitResult);
			return;
		}

		this.applyReverseMount(user, target);
		local pleasure = this.calculatePleasure(target);

		// T3 kamikaze: check if user will climax from self-pleasure
		local selfP = this.getSelfPleasure();
		local willClimax = false;
		if (tier >= 3 && user.getPleasureMax() > 0 && selfP > 0)
		{
			local afterSelf = user.getPleasure() + selfP;
			if (afterSelf >= user.getPleasureMax())
			{
				willClimax = true;
				pleasure += ::Lewd.Const.AnalT3KamikazePleasure;
			}
		}

		local actualPleasure = target.addPleasure(pleasure, user);
		if (willClimax)
			this.Tactical.EventLog.log("KAMIKAZE CLIMAX!");
		this.tryApplyHorny(target);

		local actualSelfP = this.applySelfPleasure(user, target);
		this.logHit(user, target, actualPleasure, hitResult, actualSelfP);

		// self HP damage
		local selfDmg = this.getSelfDamage();
		if (selfDmg > 0 && user.getHitpoints() > 1)
		{
			local newHP = this.Math.max(1, user.getHitpoints() - selfDmg);
			local actualDmg = user.getHitpoints() - newHP;
			user.setHitpoints(newHP);
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " takes [color=" + this.Const.UI.Color.NegativeValue + "]" + actualDmg + "[/color] damage from the act");

			// Embrace Pain: recover fatigue from sexual HP damage
			if (user.getSkills().hasSkill("perk.lewd_embrace_pain") && actualDmg > 0)
			{
				local fatigueRestore = actualDmg * ::Lewd.Const.EmbracePainSexDamageFatigueRestore;
				user.m.Fatigue = this.Math.max(0, user.m.Fatigue - fatigueRestore);
			}
		}

		this.recordSexContinuation(user, target);
	}

	function applyReverseMount( _user, _target )
	{
		// User becomes mounted (target mounts user)
		if (!_user.getSkills().hasSkill("effects.lewd_mounted"))
		{
			local mounted = this.new("scripts/skills/effects/lewd_mounted_effect");
			_user.getSkills().add(mounted);
			mounted.addMounter(_target.getID());
			mounted.setTurns(::Lewd.Const.MountDuration);
		}
		else
		{
			local mounted = _user.getSkills().getSkillByID("effects.lewd_mounted");
			mounted.addMounter(_target.getID());
			mounted.setTurns(::Lewd.Const.MountDuration);
		}

		// Target becomes mounter
		if (!_target.getSkills().hasSkill("effects.lewd_mounting"))
		{
			local mounting = this.new("scripts/skills/effects/lewd_mounting_effect");
			mounting.setTarget(_user.getID());
			_target.getSkills().add(mounting);
		}
		else
		{
			local mounting = _target.getSkills().getSkillByID("effects.lewd_mounting");
			mounting.setTarget(_user.getID());
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
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Hit chance: [color=" + pos + "]" + this.getBaseHitChance() + "%[/color] base, modified by Allure vs target Resolve"
		});

		// Mount mechanic
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + neg + "]Applies mount to yourself[/color] — the enemy mounts you"
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

		// Self-damage
		local selfDmg = this.getSelfDamage();
		if (selfDmg > 0)
		{
			result.push({
				id = 9,
				type = "text",
				icon = "ui/icons/health.png",
				text = "Deals [color=" + neg + "]" + selfDmg + "[/color] hitpoint damage to yourself"
			});
		}

		// Horny chance
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + pos + "]" + ::Lewd.Const.HornyApplyChance + "%[/color] chance to inflict Horny on hit"
		});

		// T3 special
		local tier = this.getTier();
		if (tier >= 3)
		{
			result.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "If you climax during this, deal [color=" + pos + "]+" + ::Lewd.Const.AnalT3KamikazePleasure + "[/color] bonus pleasure to target"
			});
		}

		return result;
	}
});
