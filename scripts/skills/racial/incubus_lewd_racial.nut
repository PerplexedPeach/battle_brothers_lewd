// Incubus Lewd Racial -- passive identifier + climax-triggered seal applicator
// Wraps the player character's onClimax to detect incubus-caused climaxes.
// On first incubus-caused climax: applies lewd seal stage 1.
// On subsequent incubus-caused climaxes: advances the seal.
this.incubus_lewd_racial <- this.inherit("scripts/skills/skill", {
	m = {
		ClimaxWrapped = false
	},
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

		// Wrap player character's onClimax to detect incubus-caused climaxes (once per combat)
		if (!this.m.ClimaxWrapped)
		{
			local woman = ::Lewd.Transform.target();
			if (woman != null)
			{
				local originalClimax = woman.onClimax;
				woman.onClimax = function() {
					originalClimax();

					if (this.m.LastPleasureSourceID < 0) return;
					local source = this.Tactical.getEntityByID(this.m.LastPleasureSourceID);
					if (source == null || !source.getSkills().hasSkill("racial.lewd_incubus")) return;

					local seal = this.getSkills().getSkillByID("effects.lewd_seal");
					local neg = this.Const.UI.Color.NegativeValue;
					local name = this.Const.UI.getColorizedEntityName(this);
					if (seal == null)
					{
						this.getSkills().add(this.new("scripts/skills/effects/lewd_seal_effect"));
						::logInfo("[incubus] Applied lewd seal stage 1 to " + this.getName());
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
				};
				this.m.ClimaxWrapped = true;
			}
		}

		// Permanently horny: re-apply if removed by damage or expiry
		if (!actor.getSkills().hasSkill("effects.lewd_horny"))
		{
			actor.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
		}
	}
});
