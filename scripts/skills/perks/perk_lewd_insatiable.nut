// Insatiable: +3 AP when you actively bring someone to climax
// Checked in climax_effect onAdded via LastPleasureSourceID tracking
// Per-turn trigger limit controlled by ::Lewd.Const.InsatiableMaxTriggersPerTurn setting (0 = unlimited)
this.perk_lewd_insatiable <- this.inherit("scripts/skills/skill", {
	m = {
		TriggersThisTurn = 0
	},
	function create()
	{
		this.m.ID = "perk.lewd_insatiable";
		this.m.Name = ::Const.Strings.PerkName.LewdInsatiable;
		this.m.Description = ::Const.Strings.PerkDescription.LewdInsatiable;
		this.m.Icon = "ui/perks/lewd_insatiable.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function canTrigger()
	{
		local max = ::Lewd.Const.InsatiableMaxTriggersPerTurn;
		return max == 0 || this.m.TriggersThisTurn < max;
	}

	function recordTrigger()
	{
		this.m.TriggersThisTurn += 1;
	}

	function onTurnStart()
	{
		this.m.TriggersThisTurn = 0;
	}

	function onCombatStarted()
	{
		this.m.TriggersThisTurn = 0;
	}

});
