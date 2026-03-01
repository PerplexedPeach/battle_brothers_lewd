// Force Oral — requires target to be mounted/restrained
// Low pleasure to target, high self-pleasure to user, applies Resolve debuff
// Scales with Melee Skill
this.male_force_oral_skill <- this.inherit("scripts/skills/actives/male_sex_skill", {
	m = {},
	function create()
	{
		this.male_sex_skill.create();
		this.m.SoundOnUse = ::Lewd.Const.SoundBlowjob;
		this.m.ID = "actives.male_force_oral";
		this.m.SexType = "oral";
		this.m.Name = "Force Oral";
		this.m.Description = "Force yourself on the restrained target. Provides high pleasure to the user but little to the target, while shaking their resolve.";
		this.m.Icon = "skills/lewd_hands_t2.png";
		this.m.IconDisabled = "skills/lewd_hands_t2_bw.png";
		this.m.Overlay = "lewd_hands_t2";
		this.m.ActionPointCost = ::Lewd.Const.MaleForceOralAP;
		this.m.FatigueCost = ::Lewd.Const.MaleForceOralFatigue;
		this.m.BasePleasure = ::Lewd.Const.MaleForceOralBasePleasure;
		this.m.MeleeSkillScale = ::Lewd.Const.MaleForceOralMeleeSkillScale;
		this.m.BaseHitChance = ::Lewd.Const.MaleForceOralBaseHitChance;
		this.m.SelfPleasure = ::Lewd.Const.MaleForceOralSelfPleasure;
		this.m.HitText = ["forces himself on", "uses the mouth of"];
		this.m.MissText = ["force himself on", "use"];
	}

	function calculatePleasure( _target )
	{
		// Low pleasure to target — having a penis in your mouth isn't pleasurable
		local user = this.getContainer().getActor();
		local pleasure = this.m.BasePleasure;
		pleasure += this.Math.floor(user.getCurrentProperties().getMeleeSkill() * this.m.MeleeSkillScale);
		return this.Math.max(1, pleasure);
	}

	function onHit( _user, _target )
	{
		// High flat self-pleasure to user
		if (::Lewd.Const.MaleForceOralSelfPleasure > 0 && _user.getPleasureMax() > 0)
			_user.addPleasure(::Lewd.Const.MaleForceOralSelfPleasure);

		this.tryApplyHorny(_target);

		// Apply Resolve debuff
		if (!_target.getSkills().hasSkill("effects.lewd_sex_debuff"))
		{
			local debuff = this.new("scripts/skills/effects/lewd_sex_debuff_effect");
			debuff.setDebuffs({ Resolve = ::Lewd.Const.MaleForceOralResolveDebuff, Duration = 1 });
			_target.getSkills().add(debuff);
		}
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
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.MaleForceOralSelfPleasure + "[/color] self-pleasure to user"
		});
		result.push({
			id = 9,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "Applies [color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.MaleForceOralResolveDebuff + "[/color] Resolve debuff"
		});
		return result;
	}
});
