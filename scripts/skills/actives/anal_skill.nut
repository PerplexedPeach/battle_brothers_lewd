// Anal skill — Bend Over (T1) -> Rough It (T2) -> Breaking Point (T3)
// T1 applies mount to SELF (enemy becomes mounter), T2/T3 require self-mounted
// Requires masochism tiers for upgrades
this.anal_skill <- this.inherit("scripts/skills/actives/lewd_sex_skill", {
	m = {},
	function create()
	{
		this.lewd_sex_skill.create();
		this.m.ID = "actives.lewd_anal";
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
		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryAnalPleasureThreshold)
			return ::Lewd.Const.MasteryAnalPleasureBonus;
		return 0;
	}

	function getSelfPleasure()
	{
		local user = this.getContainer().getActor();
		local tier = this.getTier();
		local selfP;
		if (tier >= 3) selfP = ::Lewd.Const.AnalT3SelfPleasure;
		else if (tier >= 2) selfP = ::Lewd.Const.AnalT2SelfPleasure;
		else selfP = ::Lewd.Const.AnalT1SelfPleasure;

		// Anal mastery self-pleasure reduction
		local pts = this.getMasteryPoints();
		if (pts >= ::Lewd.Const.MasteryAnalSelfPleasureThreshold)
			selfP = this.Math.floor(selfP * ::Lewd.Const.MasteryAnalSelfPleasureMult);

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

		// T1: establish reverse mount (enemy mounts user)
		if (tier == 1)
		{
			local hitResult = this.rollHit(_user, target);
			if (!hitResult.hit)
			{
				this.logMiss(_user, target);
				return true;
			}

			this.applyReverseMount(_user, target);
			local pleasure = this.calculatePleasure(target);
			target.addPleasure(pleasure, _user);
			this.logHit(_user, target, pleasure);
			this.tryApplyHorny(target);
		}
		else
		{
			// T2/T3: mounted continuation
			local hitResult = this.rollHit(_user, target);
			if (!hitResult.hit)
			{
				this.logMiss(_user, target);
				return true;
			}

			local pleasure = this.calculatePleasure(target);

			// T3 kamikaze: check if user will climax from self-pleasure
			local selfP = this.getSelfPleasure();
			local willClimax = false;
			if (tier >= 3 && _user.getPleasureMax() > 0 && selfP > 0)
			{
				local afterSelf = _user.getPleasure() + selfP;
				if (afterSelf >= _user.getPleasureMax())
				{
					willClimax = true;
					pleasure += ::Lewd.Const.AnalT3KamikazePleasure;
				}
			}

			target.addPleasure(pleasure, _user);
			this.logHit(_user, target, pleasure);
			if (willClimax)
				this.Tactical.EventLog.log("KAMIKAZE CLIMAX!");
			this.tryApplyHorny(target);

			// refresh mount (whichever direction exists)
			local mountedEffect = _user.getSkills().getSkillByID("effects.lewd_mounted");
			if (mountedEffect != null)
				mountedEffect.setTurns(::Lewd.Const.MountDuration);
			local targetMountedEffect = target.getSkills().getSkillByID("effects.lewd_mounted");
			if (targetMountedEffect != null)
				targetMountedEffect.setTurns(::Lewd.Const.MountDuration);
		}

		// self-pleasure
		this.applySelfPleasure(_user, target);

		// self HP damage
		local selfDmg = this.getSelfDamage();
		if (selfDmg > 0 && _user.getHitpoints() > 1)
		{
			local newHP = this.Math.max(1, _user.getHitpoints() - selfDmg);
			local actualDmg = _user.getHitpoints() - newHP;
			_user.setHitpoints(newHP);
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " takes [color=" + this.Const.UI.Color.NegativeValue + "]" + actualDmg + "[/color] damage from the act");
		}

		return true;
	}

	function applyReverseMount( _user, _target )
	{
		// User becomes mounted (target mounts user)
		if (!_user.getSkills().hasSkill("effects.lewd_mounted"))
		{
			local mounted = this.new("scripts/skills/effects/lewd_mounted_effect");
			mounted.setMounter(_target.getID());
			_user.getSkills().add(mounted);
		}
		else
		{
			local mounted = _user.getSkills().getSkillByID("effects.lewd_mounted");
			mounted.setMounter(_target.getID());
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
				text = "Deals pleasure to the target through anal sex"
			}
		];

		local tier = this.getTier();
		if (tier == 1)
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Applies mount to yourself[/color] (enemy mounts you)"
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

		local selfP = this.getSelfPleasure();
		if (selfP > 0)
		{
			result.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + selfP + "[/color] self-pleasure"
			});
		}

		local selfDmg = this.getSelfDamage();
		if (selfDmg > 0)
		{
			result.push({
				id = 8,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + selfDmg + "[/color] HP damage to self"
			});
		}

		if (tier >= 3)
		{
			result.push({
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "If you climax during this, deal [color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.AnalT3KamikazePleasure + "[/color] bonus pleasure to target"
			});
		}

		return result;
	}
});
