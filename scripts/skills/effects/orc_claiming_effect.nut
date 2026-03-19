// Orc Claiming Effect -- status on the orc to show it has claimed a target
// Purely informational for the player; lets them identify which orc to kill
// Removed when claim ends (target dies, claimer dies, or claimed effect removed)
this.orc_claiming_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TargetID = -1,
		TargetName = ""
	},
	function create()
	{
		this.m.ID = "effects.orc_claiming";
		this.m.Name = "Claiming";
		this.m.Description = "This orc has marked a target as its own.";
		this.m.Icon = "skills/lewd_orc_claimed.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function setTarget( _id, _name )
	{
		this.m.TargetID = _id;
		this.m.TargetName = _name;
	}

	function getTooltip()
	{
		local neg = this.Const.UI.Color.NegativeValue;
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
				text = "Has claimed [color=" + neg + "]" + this.m.TargetName + "[/color]"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Killing this orc will release the claim"
			}
		];
	}
});
