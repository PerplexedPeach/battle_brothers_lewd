// Penetrate (Vaginal) — easier/cheaper male penetration, establishes mount
// Scales with Melee Skill, bonus hit chance if already mounted
this.male_penetrate_vaginal_skill <- this.inherit("scripts/skills/actives/male_sex_skill", {
	m = {},
	function create()
	{
		this.male_sex_skill.create();
		this.m.SexDelay = 2000;
		this.m.ShakeCount = 4;
		this.m.ShakeIntensity = 6;
		this.m.ShakeTargetAway = true;
		this.m.ShakeTargetIntensity = 4;
		this.m.Delay = 2000;
		this.m.SoundOnHit = ::Lewd.Const.SoundFucking;
		this.m.ID = "actives.male_penetrate_vaginal";
		this.m.Name = "Penetrate (Vaginal)";
		this.m.Description = "Penetrate the target vaginally, dealing high pleasure and establishing dominance.";
		this.m.SexType = "vaginal";
		this.m.Icon = "skills/lewd_vaginal_t1.png";
		this.m.IconDisabled = "skills/lewd_vaginal_t1_bw.png";
		this.m.Overlay = "lewd_vaginal_t1";
		this.m.ActionPointCost = ::Lewd.Const.MalePenetrateVaginalAP;
		this.m.FatigueCost = ::Lewd.Const.MalePenetrateVaginalFatigue;
		this.m.BasePleasure = ::Lewd.Const.MalePenetrateVaginalBasePleasure;
		this.m.MeleeSkillScale = ::Lewd.Const.MalePenetrateVaginalMeleeSkillScale;
		this.m.BaseHitChance = ::Lewd.Const.MalePenetrateVaginalBaseHitChance;
		this.m.SelfPleasure = ::Lewd.Const.MalePenetrateVaginalSelfPleasure;
		this.m.HitText = ["penetrates", "thrusts into", "ravishes"];
		this.m.MissText = ["penetrate", "thrust into", "take"];
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target != null)
		{
			local tier = this.Math.max(1, ::Lewd.Mastery.getMasteryTier(target, "effects.lewd_mastery_vaginal"));
			this.m.Icon = "skills/lewd_vaginal_t" + tier + ".png";
			this.m.IconDisabled = "skills/lewd_vaginal_t" + tier + "_bw.png";
			this.m.Overlay = "lewd_vaginal_t" + tier;
		}
		return this.male_sex_skill.onUse(_user, _targetTile);
	}

	function getHitChanceAgainst( _target )
	{
		local chance = this.male_sex_skill.getHitChanceAgainst(_target);
		if (_target.getSkills().hasSkill("effects.lewd_mounted"))
			chance += ::Lewd.Const.MalePenetrateVaginalMountedHitBonus;
		return this.Math.max(20, this.Math.min(95, chance));
	}

	function getHitFactors( _targetTile )
	{
		local ret = this.male_sex_skill.getHitFactors(_targetTile);
		local target = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
		if (target == null) return ret;

		if (target.getSkills().hasSkill("effects.lewd_mounted"))
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.MalePenetrateVaginalMountedHitBonus + "%[/color] from target mounted"
			});

		return ret;
	}

	function calculateMountBonus( _target )
	{
		return ::Lewd.Const.MalePenetrateVaginalMountedPleasureBonus;
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
		target.addPleasure(pleasure, user);
		this.logHit(user, target, pleasure, hitResult, this.getSelfPleasure());
		this.onHit(user, target);
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
		local result = this.sex_skill_base.getTooltip();

		// Pleasure info
		result.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Deals [color=" + pos + "]pleasure[/color] to the target (scales with Melee Skill)"
		});

		// Hit chance
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Hit chance: [color=" + pos + "]" + this.m.BaseHitChance + "%[/color] base, modified by Melee Skill vs target Melee Defense"
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "[color=" + pos + "]+" + ::Lewd.Const.MaleSexMountedHitBonus + "%[/color] hit chance against mounted targets"
		});
		result.push({
			id = 8,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "[color=" + pos + "]+" + ::Lewd.Const.MalePenetrateVaginalMountedHitBonus + "%[/color] additional hit chance if target already mounted"
		});

		// Mount
		result.push({
			id = 9,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + pos + "]Establishes mount[/color] on the target, or refreshes duration if already mounted"
		});
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + pos + "]+" + ::Lewd.Const.MalePenetrateVaginalMountedPleasureBonus + "[/color] bonus pleasure if target is mounted"
		});

		// Self-pleasure
		if (this.m.SelfPleasure > 0)
		{
			result.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts [color=" + neg + "]" + this.m.SelfPleasure + "[/color] pleasure on the user"
			});
		}

		// Horny + target restriction
		result.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + pos + "]" + ::Lewd.Const.HornyApplyChance + "%[/color] chance to inflict Horny on hit"
		});
		result.push({
			id = 13,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + pos + "]Auto-hit[/color] against Horny or Open Invitation targets"
		});
		result.push({
			id = 14,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Only usable on female targets with Pleasure capacity"
		});

		return result;
	}
});
