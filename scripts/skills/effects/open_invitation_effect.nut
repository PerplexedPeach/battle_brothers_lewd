// Open Invitation effect — flag status effect indicating Open Invitation is active
// Checked by female_sex_skill for +15% pleasure bonus and auto-hit on target
this.open_invitation_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.open_invitation";
		this.m.Name = "Open Invitation";
		this.m.Description = "You've invited the enemy in. Sex abilities deal more pleasure, but enemy sex abilities auto-hit you.";
		this.m.Icon = "skills/open_invitation_effect.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onUpdate( _properties )
	{
		_properties.ReceivedPleasureMult *= ::Lewd.Const.OpenInvitationReceivedPleasureMult;
	}

	function getTooltip()
	{
		local pctDealt = this.Math.floor((::Lewd.Const.SensualFocusOpenInvitationMult - 1.0) * 100);
		local pctReceived = this.Math.floor((::Lewd.Const.OpenInvitationReceivedPleasureMult - 1.0) * 100);
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
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + pctDealt + "%[/color] pleasure dealt by sex abilities"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]+" + pctReceived + "% pleasure received from enemy sex abilities[/color]"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]You let yourself accept all enemy sex abilities[/color]"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Bringing enemies to climax slowly increases Submission instead of Dominance[/color]"
			}
		];
	}
});
