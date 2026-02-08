this.heel_walking_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.heel_walking";
		this.m.Name = "Heel Walking";
		this.m.Description = "Walking in heels is much harder than it looks.";
		// TODO add icons
		this.m.Icon = "ui/perks/perk_29.png";
		this.m.IconMini = "perk_29_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		// TODO adjust movement sound
	}

	function getTooltip()
	{
		local heelHeight = this.getContainer().getActor().getFlags().getAsInt("heelHeight");
		local heelSkill = this.getContainer().getActor().getFlags().getAsInt("heelSkill");

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
				id = 15,
				type = "text",
				// icon = "ui/icons/special.png",
				text = "Heel height: [color=" + this.Const.UI.Color.NegativeValue + "]" + heelHeight + "[/color]"
			},
			{
				id = 16,
				type = "text",
				// icon = "ui/icons/special.png",
				text = "Heel skill: [color=" + this.Const.UI.Color.PositiveValue + "]" + heelSkill + "[/color]"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Every point the heel height is above your skill, every tile builds an additional [color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.HeelFatigueMultiplier + "[/color] fatigue per tile (so if heel height is 5 and skill is 3, you get 4 fatigue per tile). You increase your heel skill by wearing heels over time. The higher the difference in heel height and skill, the faster you gain skill."
			},
		];
	}
});

