// Penetrate (Vaginal) — easier/cheaper male penetration, establishes mount
// Scales with Melee Skill, bonus hit chance if already mounted
this.male_penetrate_vaginal_skill <- this.inherit("scripts/skills/actives/male_sex_skill", {
	m = {},
	function create()
	{
		this.male_sex_skill.create();
		this.m.ID = "actives.male_penetrate_vaginal";
		this.m.Name = "Penetrate (Vaginal)";
		this.m.Description = "Penetrate the target vaginally, dealing high pleasure and establishing dominance.";
		this.m.SexType = "vaginal";
		this.m.Icon = "skills/lewd_hands_t3.png";
		this.m.IconDisabled = "skills/lewd_hands_t3_bw.png";
		this.m.Overlay = "lewd_hands_t3";
		this.m.ActionPointCost = ::Lewd.Const.MalePenetrateVaginalAP;
		this.m.FatigueCost = ::Lewd.Const.MalePenetrateVaginalFatigue;
		this.m.BasePleasure = ::Lewd.Const.MalePenetrateVaginalBasePleasure;
		this.m.MeleeSkillScale = ::Lewd.Const.MalePenetrateVaginalMeleeSkillScale;
		this.m.BaseHitChance = ::Lewd.Const.MalePenetrateVaginalBaseHitChance;
		this.m.SelfPleasure = ::Lewd.Const.MalePenetrateVaginalSelfPleasure;
		this.m.HitText = ["penetrates", "thrusts into", "ravishes"];
		this.m.MissText = ["penetrate", "thrust into", "take"];
	}

	function getHitChanceAgainst( _target )
	{
		local chance = this.male_sex_skill.getHitChanceAgainst(_target);
		if (_target.getSkills().hasSkill("effects.lewd_mounted"))
			chance += ::Lewd.Const.MalePenetrateVaginalMountedHitBonus;
		return this.Math.max(20, this.Math.min(95, chance));
	}

	function calculateMountBonus( _target )
	{
		return ::Lewd.Const.MalePenetrateVaginalMountedPleasureBonus;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;

		this.playSound(_user);
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
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.MalePenetrateVaginalMountedHitBonus + "%[/color] hit chance if target already mounted"
		});
		if (this.m.SelfPleasure > 0)
		{
			result.push({
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.SelfPleasure + "[/color] self-pleasure"
			});
		}
		return result;
	}
});
