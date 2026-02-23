this.lewd_mastery_vaginal_effect <- this.inherit("scripts/skills/effects/lewd_mastery_effect", {
	function create()
	{
		this.lewd_mastery_effect.create();
		this.m.ID = "effects.lewd_mastery_vaginal";
		this.m.Name = "Vaginal Mastery";
		this.m.Description = "Skill and endurance with riding and mounting.";
		this.m.Icon = "skills/lewd_mastery_vaginal.png";
		this.m.Limit = ::Lewd.Const.MasteryLimitVaginal;
		this.m.BodyPart = "vaginal";
		this.m.PerkId = "perk.lewd_mounting";
		this.m.AssociatedSkillID = "actives.lewd_vaginal";
	}

	function getTier()
	{
		if (this.m.Points >= ::Lewd.Const.MasteryVaginalT3) return 3;
		if (this.m.Points >= ::Lewd.Const.MasteryVaginalT2) return 2;
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

		if (pts >= ::Lewd.Const.MasteryVaginalSelfPleasureThreshold)
		{
			local pctReduction = this.Math.floor((1.0 - ::Lewd.Const.MasteryVaginalSelfPleasureMult) * 100);
			tooltip.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]-" + pctReduction + "%[/color] self-pleasure"
			});
		}
		if (pts >= ::Lewd.Const.MasteryVaginalPleasureThreshold)
		{
			tooltip.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.MasteryVaginalPleasureBonus + "[/color] pleasure dealt"
			});
		}
		if (pts >= ::Lewd.Const.MasteryVaginalFatigueThreshold)
		{
			tooltip.push({
				id = 13,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.MasteryVaginalFatigueBonus + "[/color] Fatigue cost"
			});
		}

		if (pts < ::Lewd.Const.MasteryVaginalSelfPleasureThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryVaginalSelfPleasureThreshold + ": Self-pleasure reduction" });
		else if (pts < ::Lewd.Const.MasteryVaginalT2)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryVaginalT2 + ": Skill upgrades to Riding" });
		else if (pts < ::Lewd.Const.MasteryVaginalPleasureThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryVaginalPleasureThreshold + ": Bonus pleasure dealt" });
		else if (pts < ::Lewd.Const.MasteryVaginalT3)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryVaginalT3 + ": Skill upgrades to Cowgirl" });
		else if (pts < ::Lewd.Const.MasteryVaginalFatigueThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryVaginalFatigueThreshold + ": Fatigue cost reduction" });

		return tooltip;
	}
});
