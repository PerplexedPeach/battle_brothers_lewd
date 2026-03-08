// Force Oral — requires target to be mounted/restrained
// Minimal pleasure to target, self-pleasure to user scales with target's oral mastery
// Better oral skill = more pleasure for the one being sucked
this.male_force_oral_skill <- this.inherit("scripts/skills/actives/male_sex_skill", {
	m = {},
	function create()
	{
		this.male_sex_skill.create();
		this.m.SoundOnUse = ::Lewd.Const.SoundBlowjob;
		this.m.ID = "actives.male_force_oral";
		this.m.SexType = "oral";
		this.m.Name = "Force Oral";
		this.m.Description = "Force yourself on the restrained target. The target\'s oral skill determines how much pleasure you receive.";
		this.m.Icon = "skills/lewd_oral_t1.png";
		this.m.IconDisabled = "skills/lewd_oral_t1_bw.png";
		this.m.Overlay = "lewd_oral_t1";
		this.m.ActionPointCost = ::Lewd.Const.MaleForceOralAP;
		this.m.FatigueCost = ::Lewd.Const.MaleForceOralFatigue;
		this.m.BasePleasure = ::Lewd.Const.MaleForceOralBasePleasure;
		this.m.MeleeSkillScale = ::Lewd.Const.MaleForceOralMeleeSkillScale;
		this.m.BaseHitChance = ::Lewd.Const.MaleForceOralBaseHitChance;
		this.m.SelfPleasure = ::Lewd.Const.MaleForceOralSelfPleasure;
		this.m.HitText = ["forces himself on", "uses the mouth of"];
		this.m.MissText = ["force himself on", "use"];
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target != null)
		{
			local tier = this.Math.max(1, ::Lewd.Mastery.getMasteryTier(target, "effects.lewd_mastery_oral"));
			this.m.Icon = "skills/lewd_oral_t" + tier + ".png";
			this.m.IconDisabled = "skills/lewd_oral_t" + tier + "_bw.png";
			this.m.Overlay = "lewd_oral_t" + tier;
		}
		return this.male_sex_skill.onUse(_user, _targetTile);
	}

	function calculatePleasure( _target )
	{
		// Minimal pleasure to target — being forced isn't pleasurable
		return this.Math.max(1, this.m.BasePleasure);
	}

	function calculateSelfPleasure( _target )
	{
		// Self-pleasure scales with target's oral mastery — better oral skill = feels better
		local selfP = ::Lewd.Const.MaleForceOralSelfPleasure;
		local oralPts = ::Lewd.Mastery.getMasteryPoints(_target, "effects.lewd_mastery_oral");
		if (oralPts > 0)
			selfP += this.Math.floor(oralPts * ::Lewd.Const.MaleForceOralOralMasteryScale);
		return selfP;
	}

	function onHit( _user, _target )
	{
		// Self-pleasure to user, scaled by target's oral mastery
		local selfP = this.calculateSelfPleasure(_target);

		// Pliant Body: target's accommodating body gives attacker more self-pleasure + target recovers fatigue
		if (_target.getSkills().hasSkill("perk.lewd_pliant_body"))
		{
			selfP = this.Math.floor(selfP * ::Lewd.Const.PliantBodyReflectionMult);
			_target.m.Fatigue = this.Math.max(0, _target.m.Fatigue - ::Lewd.Const.PliantBodyFatigueRecovery);
		}

		// Surrender to Pleasure: target has given in, mounters feel it more
		local surrenderEffect = _target.getSkills().getSkillByID("effects.surrender_to_pleasure");
		if (surrenderEffect != null)
			selfP = this.Math.floor(selfP * surrenderEffect.getMounterMult());

		if (selfP > 0 && _user.getPleasureMax() > 0)
			_user.addPleasure(selfP);

		// Willing Victim: target deals counter-pleasure back to attacker
		if (_target.getSkills().hasSkill("perk.lewd_willing_victim") && _user.getPleasureMax() > 0)
			_user.addPleasure(::Lewd.Const.WillingVictimCounterPleasure, _target);

		this.tryApplyHorny(_target);
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.male_sex_skill.onVerifyTarget(_originTile, _targetTile)) return false;
		local target = _targetTile.getEntity();
		// Requires target to be mounted (restrained)
		if (!target.getSkills().hasSkill("effects.lewd_mounted")) return false;
		return true;
	}

	function getTooltip()
	{
		local result = this.male_sex_skill.getTooltip();
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]Requires[/color] target to be mounted (restrained)"
		});
		result.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.MaleForceOralSelfPleasure + "[/color] base self-pleasure (scales with target\'s oral mastery)"
		});
		return result;
	}
});
