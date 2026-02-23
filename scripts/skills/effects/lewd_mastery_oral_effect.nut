this.lewd_mastery_oral_effect <- this.inherit("scripts/skills/effects/lewd_mastery_effect", {
	function create()
	{
		this.lewd_mastery_effect.create();
		this.m.ID = "effects.lewd_mastery_oral";
		this.m.Name = "Oral Mastery";
		this.m.Description = "Experience with using your mouth to pleasure others.";
		this.m.Icon = "skills/lewd_mastery_oral.png";
		this.m.Limit = ::Lewd.Const.MasteryLimitOral;
		this.m.BodyPart = "oral";
		this.m.PerkId = "perk.lewd_oral_arts";
		this.m.AssociatedSkillID = "actives.lewd_oral";
	}

	function getTier()
	{
		if (this.m.Points >= ::Lewd.Const.MasteryOralT3) return 3;
		if (this.m.Points >= ::Lewd.Const.MasteryOralT2) return 2;
		return 1;
	}

	function getTooltip()
	{
		local tooltip = this.lewd_mastery_effect.getTooltip();
		local pts = this.getPoints();
		if (pts < 0) return tooltip;

		local tier = this.getTier();
		tooltip.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Current tier: [color=" + this.Const.UI.Color.PositiveValue + "]" + tier + "[/color]"
		});

		// passive bonuses
		if (pts >= ::Lewd.Const.MasteryOralFatigueThreshold)
		{
			tooltip.push({
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.MasteryOralFatigueBonus + "[/color] Fatigue cost"
			});
		}
		if (pts >= ::Lewd.Const.MasteryOralPleasureThreshold)
		{
			tooltip.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.MasteryOralPleasureBonus + "[/color] pleasure dealt"
			});
		}
		if (pts >= ::Lewd.Const.MasteryOralResolveThreshold)
		{
			tooltip.push({
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.MasteryOralResolveBonus + "[/color] Resolve"
			});
		}

		// next unlock preview
		if (pts < ::Lewd.Const.MasteryOralFatigueThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryOralFatigueThreshold + ": Fatigue reduction" });
		else if (pts < ::Lewd.Const.MasteryOralT2)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryOralT2 + ": Skill upgrades to Oral Service" });
		else if (pts < ::Lewd.Const.MasteryOralPleasureThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryOralPleasureThreshold + ": Bonus pleasure dealt" });
		else if (pts < ::Lewd.Const.MasteryOralT3)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryOralT3 + ": Skill upgrades to Deepthroat" });
		else if (pts < ::Lewd.Const.MasteryOralResolveThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryOralResolveThreshold + ": Resolve bonus" });

		return tooltip;
	}

	function onUpdate( _properties )
	{
		if (this.getPoints() < 0) return;
		if (this.m.Points >= ::Lewd.Const.MasteryOralResolveThreshold)
		{
			_properties.Bravery += ::Lewd.Const.MasteryOralResolveBonus;
		}
	}
});
