// Penetrate (Anal) — rougher/harder male penetration, establishes mount
// Scales with Melee Skill, bonus pleasure per target masochism tier
this.male_penetrate_anal_skill <- this.inherit("scripts/skills/actives/male_sex_skill", {
	m = {},
	function create()
	{
		this.male_sex_skill.create();
		this.m.SoundOnUse = ::Lewd.Const.SoundFucking;
		this.m.ID = "actives.male_penetrate_anal";
		this.m.Name = "Penetrate (Anal)";
		this.m.Description = "Take the target from behind with brute force. Deals bonus pleasure to masochistic targets.";
		this.m.SexType = "anal";
		this.m.Icon = "skills/lewd_hands_t3.png";
		this.m.IconDisabled = "skills/lewd_hands_t3_bw.png";
		this.m.Overlay = "lewd_hands_t3";
		this.m.ActionPointCost = ::Lewd.Const.MalePenetrateAnalAP;
		this.m.FatigueCost = ::Lewd.Const.MalePenetrateAnalFatigue;
		this.m.BasePleasure = ::Lewd.Const.MalePenetrateAnalBasePleasure;
		this.m.MeleeSkillScale = ::Lewd.Const.MalePenetrateAnalMeleeSkillScale;
		this.m.BaseHitChance = ::Lewd.Const.MalePenetrateAnalBaseHitChance;
		this.m.SelfPleasure = ::Lewd.Const.MalePenetrateAnalSelfPleasure;
		this.m.HitText = ["sodomizes", "takes from behind", "ravishes anally"];
		this.m.MissText = ["sodomize", "take from behind", "ravish"];
	}

	function getHitChanceAgainst( _target )
	{
		local chance = this.male_sex_skill.getHitChanceAgainst(_target);
		if (_target.getSkills().hasSkill("effects.lewd_mounted"))
			chance += ::Lewd.Const.MalePenetrateAnalMountedHitBonus;
		return this.Math.max(20, this.Math.min(95, chance));
	}

	function calculateMountBonus( _target )
	{
		return ::Lewd.Const.MalePenetrateAnalMountedPleasureBonus;
	}

	function calculatePleasure( _target )
	{
		local pleasure = this.male_sex_skill.calculatePleasure(_target);

		// Masochism tier bonus
		local masoTier = ::Lewd.Mastery.getMasoTier(_target);
		if (masoTier > 0)
			pleasure += masoTier * ::Lewd.Const.MalePenetrateAnalMasoTierBonus;

		return this.Math.max(1, pleasure);
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;

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
		this.onHit(_user, target);
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
		local result = this.male_sex_skill.getTooltip();
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]Establishes mount[/color] on the target (or refreshes if already mounted)"
		});
		result.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.MalePenetrateAnalMountedHitBonus + "%[/color] hit chance if target already mounted"
		});
		result.push({
			id = 9,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.MalePenetrateAnalMasoTierBonus + "[/color] pleasure per target masochism tier"
		});
		if (this.m.SelfPleasure > 0)
		{
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.SelfPleasure + "[/color] self-pleasure"
			});
		}
		return result;
	}
});
