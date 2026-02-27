// Open Invitation effect — flag status effect indicating Open Invitation is active
// Checked by lewd_sex_skill for +15% pleasure bonus and auto-hit on target
this.open_invitation_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.open_invitation";
		this.m.Name = "Open Invitation";
		this.m.Description = "You've invited the enemy in. Sex abilities deal more pleasure, but enemy sex abilities auto-hit you.";
		this.m.Icon = "skills/open_invitation.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
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
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] pleasure dealt by sex abilities"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]You let yourself accept all enemy sex abilities[/color]"
			}
		];
	}
});
