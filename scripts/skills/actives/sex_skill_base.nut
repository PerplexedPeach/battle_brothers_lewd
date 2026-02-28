// Base class for all sex abilities (both player/female and enemy/male)
// Provides shared: create() flags, onUse() flow, playSound, rollHit, tryApplyHorny,
// isAutoHit, onVerifyTarget, logMiss/logHit, getTooltip base entries
// Subclasses: lewd_sex_skill (tiers/mastery), male_sex_skill (flat values)
this.sex_skill_base <- this.inherit("scripts/skills/skill", {
	m = {
		HitText = [],
		MissText = []
	},
	function create()
	{
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_charm_kiss_01.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_02.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_03.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function isAutoHit( _target )
	{
		if (_target.getSkills().hasSkill("effects.open_invitation")) return true;
		if (_target.getSkills().hasSkill("effects.lewd_horny")) return true;
		return false;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
		local target = _targetTile.getEntity();
		if (target == null) return false;
		if (this.m.Container.getActor().isAlliedWith(target)) return false;
		if (target.getPleasureMax() <= 0) return false;
		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;

		this.playSound(_user);

		local hitResult = this.rollHit(_user, target);
		if (!hitResult.hit)
		{
			this.logMiss(_user, target);
			return true;
		}

		local pleasure = this.calculatePleasure(target);
		target.addPleasure(pleasure, _user);
		this.logHit(_user, target, pleasure);
		this.onHit(_user, target);
		return true;
	}

	function playSound( _user )
	{
		if (this.m.SoundOnUse.len() != 0)
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
	}

	function rollHit( _user, _target )
	{
		local chance = this.getHitChanceAgainst(_target);
		local roll = this.Math.rand(1, 100);
		return { chance = chance, roll = roll, hit = roll <= chance };
	}

	function logMiss( _user, _target )
	{
		local verb = this.m.MissText[this.Math.rand(0, this.m.MissText.len() - 1)];
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " tries to " + verb + " " + this.Const.UI.getColorizedEntityName(_target) + " but fails");
	}

	function logHit( _user, _target, _pleasure )
	{
		local verb = this.m.HitText[this.Math.rand(0, this.m.HitText.len() - 1)];
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " " + verb + " " + this.Const.UI.getColorizedEntityName(_target) + " for " + _pleasure + " pleasure");
	}

	function tryApplyHorny( _target )
	{
		if (_target.getPleasureMax() <= 0) return;
		if (this.Math.rand(1, 100) > ::Lewd.Const.HornyApplyChance) return;

		if (_target.getSkills().hasSkill("effects.lewd_horny"))
		{
			local effect = _target.getSkills().getSkillByID("effects.lewd_horny");
			effect.onRefresh();
		}
		else
		{
			local horny = this.new("scripts/skills/effects/lewd_horny_effect");
			_target.getSkills().add(horny);
		}
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
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
	}

	// --- Virtual stubs (subclasses must override) ---

	function calculatePleasure( _target )
	{
		return 0;
	}

	function getHitChanceAgainst( _target )
	{
		return 0;
	}

	function isHidden()
	{
		return true;
	}

	function onHit( _user, _target )
	{
		this.tryApplyHorny(_target);
	}
});
