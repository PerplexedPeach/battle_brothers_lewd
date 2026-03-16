// Overwhelming Presence: doubles pleasure reflection to anyone targeting this creature.
// Modifies PleasureReflectionMult property, read by sex ability self-pleasure calculations.
this.lewd_overwhelming_presence_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.lewd_overwhelming_presence";
		this.m.Name = "Overwhelming Presence";
		this.m.Description = "This creature's sheer physical intensity doubles the pleasure reflected to those who engage it.";
		this.m.Icon = "skills/status_effect_100.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.First;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsSerialized = false;
	}

	function onUpdate( _properties )
	{
		_properties.PleasureReflectionMult *= 2.0;
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
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+100%[/color] Pleasure Reflection"
			}
		];
	}
});
