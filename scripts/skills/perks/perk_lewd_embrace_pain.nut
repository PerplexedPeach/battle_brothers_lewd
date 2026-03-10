this.perk_lewd_embrace_pain <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_embrace_pain";
		this.m.Name = ::Const.Strings.PerkName.LewdEmbracePain;
		this.m.Description = ::Const.Strings.PerkDescription.LewdEmbracePain;
		this.m.Icon = "ui/perks/lewd_embrace_pain.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints <= 0)
			return;

		local actor = this.getContainer().getActor();

		// Fatigue recovery on hit
		actor.m.Fatigue = this.Math.max(0, actor.m.Fatigue - ::Lewd.Const.EmbracePainFatiguePerHit);

		// Moan on hit
		if (actor.isAlive() && actor.isPlacedOnMap())
		{
			local moans = ::Lewd.Const.SoundMoans;
			this.Sound.play(moans[this.Math.rand(0, moans.len() - 1)], this.Const.Sound.Volume.Skill * 0.5, actor.getPos());
		}

		// Chance to make attacker horny, scaling with sub score
		if (_attacker != null && _attacker.isAlive() && !_attacker.isAlliedWith(actor))
		{
			local subScore = ::Lewd.Mastery.getSubScore(actor);
			local chance = ::Lewd.Const.EmbracePainHornyBaseChance + subScore * ::Lewd.Const.EmbracePainHornySubScale;
			local roll = this.Math.rand(1, 100);
			if (roll <= chance && !_attacker.getSkills().hasSkill("effects.lewd_horny"))
			{
				_attacker.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
				::logInfo("[embrace_pain] " + actor.getName() + "'s moan made " + _attacker.getName() + " horny (roll:" + roll + " <= " + chance + "%)");
			}
		}
	}
});
