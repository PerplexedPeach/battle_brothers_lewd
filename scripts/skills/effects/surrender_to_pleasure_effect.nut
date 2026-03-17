// Surrender to Pleasure effect — temporary buff indicating the character has given in
// Mounters receive boosted self-pleasure when using sex abilities on this target
// Character also takes more pleasure themselves (at half scaling)
// Bonus scales with AP spent and sub score at time of activation
// Lasts until the start of the character's next turn
this.surrender_to_pleasure_effect <- this.inherit("scripts/skills/skill", {
	m = {
		APSpent = 0,
		SubScore = 0
	},
	function create()
	{
		this.m.ID = "effects.surrender_to_pleasure";
		this.m.Name = "Surrendered to Pleasure";
		this.m.Description = "You've given in completely, making it much more pleasurable for those mounting you.";
		this.m.Icon = "skills/surrender_to_pleasure_status.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function setParams( _apSpent, _subScore )
	{
		this.m.APSpent = _apSpent;
		this.m.SubScore = _subScore;
	}

	// Multiplier for mounter self-pleasure: 1.0 + (ap * sub) / divisor
	function getMounterMult()
	{
		return 1.0 + (this.m.APSpent * this.m.SubScore) / ::Lewd.Const.SurrenderToPleasureMounterDivisor;
	}

	// Multiplier for self-pleasure vulnerability: 1.0 + (ap * sub) / (divisor * 2)
	function getSelfVulnMult()
	{
		return 1.0 + (this.m.APSpent * this.m.SubScore) / ::Lewd.Const.SurrenderToPleasureSelfDivisor;
	}

	function onUpdate( _properties )
	{
		_properties.ReceivedPleasureMult *= this.getSelfVulnMult();
	}

	function getTooltip()
	{
		local mounterPct = this.Math.floor((this.getMounterMult() - 1.0) * 100);
		local selfPct = this.Math.floor((this.getSelfVulnMult() - 1.0) * 100);
		local result = [
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
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Mounters receive [color=" + this.Const.UI.Color.PositiveValue + "]+" + mounterPct + "%[/color] self-pleasure from sex abilities on you"
			}
		];

		if (selfPct > 0)
		{
			result.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "You receive [color=" + this.Const.UI.Color.NegativeValue + "]+" + selfPct + "%[/color] more pleasure"
			});
		}

		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Expires at the start of your next turn"
		});

		return result;
	}

	function onTurnStart()
	{
		this.removeSelf();
	}
});
