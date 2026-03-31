// Soul Harvest: heal on causing climax (via hook) and on killing Horny enemies (via onTargetKilled)
this.perk_lewd_soul_harvest <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lewd_soul_harvest";
		this.m.Name = ::Const.Strings.PerkName.LewdSoulHarvest;
		this.m.Description = ::Const.Strings.PerkDescription.LewdSoulHarvest;
		this.m.Icon = "ui/perks/lewd_soul_harvest.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (_targetEntity == null) return;
		if (!_targetEntity.getSkills().hasSkill("effects.lewd_horny")) return;

		local actor = this.getContainer().getActor();
		local healAmount = this.Math.max(1, this.Math.floor(_targetEntity.getHitpointsMax() * ::Lewd.Const.SoulHarvestKillHealPct));
		actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + healAmount));
		if (!actor.isHiddenToPlayer())
		{
			this.spawnIcon("status_effect_79", actor.getTile());
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " harvests [color=" + this.Const.UI.Color.PositiveValue + "]" + healAmount + "[/color] health from " + this.Const.UI.getColorizedEntityName(_targetEntity) + "'s death");
		}
		::logInfo("[soul_harvest] " + actor.getName() + " harvested " + healAmount + " HP from killing Horny " + _targetEntity.getName());
	}
});
