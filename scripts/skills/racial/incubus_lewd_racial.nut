// Incubus Lewd Racial -- passive identifier + climax-triggered seal applicator
// Uses onTargetClimax hook: when someone climaxes because of the incubus,
// applies or advances lewd seal on the target.
this.incubus_lewd_racial <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.lewd_incubus";
		this.m.Name = "";
		this.m.Description = "";
		this.m.Type = this.Const.SkillType.Racial;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = false;
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();

		// Permanently horny: re-apply if removed by damage or expiry
		if (!actor.getSkills().hasSkill("effects.lewd_horny"))
		{
			actor.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
		}
	}

	// Called by onClimax notification when someone climaxes because of this incubus
	function onTargetClimax( _self, _target )
	{
		local seal = _target.getSkills().getSkillByID("effects.lewd_seal");
		local neg = this.Const.UI.Color.NegativeValue;
		local name = this.Const.UI.getColorizedEntityName(_target);

		if (seal == null)
		{
			_target.getSkills().add(this.new("scripts/skills/effects/lewd_seal_effect"));
			::logInfo("[incubus] Applied lewd seal stage 1 to " + _target.getName());
			this.Tactical.EventLog.log("[color=" + neg + "]A faint pink sigil flickers on " + name + "'s forehead...[/color]");
		}
		else if (seal.getStage() < 4)
		{
			local stage = seal.getStage();
			seal.advance();
			local msg = "";
			if (stage == 1)
				msg = "The sigil on " + name + "'s forehead glows brighter, seeping warmth through her skull";
			else if (stage == 2)
				msg = "The seal pulses in time with " + name + "'s heartbeat. Fear feels like a distant memory";
			else if (stage == 3)
				msg = "The seal burns itself into " + name + "'s very soul. There is no going back. She belongs to him now";
			this.Tactical.EventLog.log("[color=" + neg + "]" + msg + "[/color]");
		}
	}
});
