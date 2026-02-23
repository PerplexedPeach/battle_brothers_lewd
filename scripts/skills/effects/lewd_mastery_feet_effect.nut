this.lewd_mastery_feet_effect <- this.inherit("scripts/skills/effects/lewd_mastery_effect", {
	function create()
	{
		this.lewd_mastery_effect.create();
		this.m.ID = "effects.lewd_mastery_feet";
		this.m.Name = "Feet Mastery";
		this.m.Description = "Skill with using your feet to tease and dominate.";
		this.m.Icon = "skills/lewd_mastery_feet.png";
		this.m.Limit = ::Lewd.Const.MasteryLimitFeet;
		this.m.BodyPart = "feet";
		this.m.PerkId = "perk.lewd_foot_tease";
		this.m.AssociatedSkillID = "actives.lewd_feet";
	}

	function getTier()
	{
		if (this.m.Points >= ::Lewd.Const.MasteryFeetT3) return 3;
		if (this.m.Points >= ::Lewd.Const.MasteryFeetT2) return 2;
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

		if (pts >= ::Lewd.Const.MasteryFeetFatigueThreshold)
		{
			tooltip.push({
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.MasteryFeetFatigueBonus + "[/color] Fatigue cost"
			});
		}
		if (pts >= ::Lewd.Const.MasteryFeetPleasureThreshold)
		{
			tooltip.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.MasteryFeetPleasureBonus + "[/color] pleasure dealt"
			});
		}
		if (pts >= ::Lewd.Const.MasteryFeetResolveIgnoreThreshold)
		{
			local pctIgnore = this.Math.floor(::Lewd.Const.MasteryFeetResolveIgnorePct * 100);
			tooltip.push({
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "Ignore [color=" + this.Const.UI.Color.PositiveValue + "]" + pctIgnore + "%[/color] of target's Resolve"
			});
		}

		if (pts < ::Lewd.Const.MasteryFeetFatigueThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryFeetFatigueThreshold + ": Fatigue reduction" });
		else if (pts < ::Lewd.Const.MasteryFeetT2)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryFeetT2 + ": Skill upgrades to Footjob" });
		else if (pts < ::Lewd.Const.MasteryFeetPleasureThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryFeetPleasureThreshold + ": Bonus pleasure dealt" });
		else if (pts < ::Lewd.Const.MasteryFeetT3)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryFeetT3 + ": Skill upgrades to Heel Domination" });
		else if (pts < ::Lewd.Const.MasteryFeetResolveIgnoreThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryFeetResolveIgnoreThreshold + ": Ignore target Resolve" });

		return tooltip;
	}
});
