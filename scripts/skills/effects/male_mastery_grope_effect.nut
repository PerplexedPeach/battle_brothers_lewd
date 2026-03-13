// Male Grope Mastery — tracks proficiency with the Grope ability
// Granted by Wandering Hands perk, gains points from using male_grope
this.male_mastery_grope_effect <- this.inherit("scripts/skills/effects/lewd_mastery_effect", {
	function create()
	{
		this.lewd_mastery_effect.create();
		this.m.ID = "effects.male_mastery_grope";
		this.m.Name = "Grope Mastery";
		this.m.Description = "Experience with rough handling and finding vulnerable spots on the female body.";
		this.m.Icon = "skills/lewd_mastery_grope.png";
		this.m.Limit = ::Lewd.Const.MaleMasteryLimitGrope;
		this.m.BodyPart = "hands";
		this.m.PerkId = "perk.lewd_wandering_hands";
		this.m.AssociatedSkillID = "actives.male_grope";
	}

	function getTier()
	{
		if (this.m.Points >= ::Lewd.Const.MaleMasteryGropeT3) return 3;
		if (this.m.Points >= ::Lewd.Const.MaleMasteryGropeT2) return 2;
		return 1;
	}

	function getHitBonus()
	{
		local pts = this.m.Points;
		local bonus = 0;
		if (pts >= ::Lewd.Const.MaleMasteryGropeHitThreshold)
			bonus += ::Lewd.Const.MaleMasteryGropeHitBonus;
		if (pts >= ::Lewd.Const.MaleMasteryGropeHitT3Threshold)
			bonus += ::Lewd.Const.MaleMasteryGropeHitT3Bonus;
		return bonus;
	}

	function getPleasureBonus()
	{
		if (this.m.Points >= ::Lewd.Const.MaleMasteryGropePleasureThreshold)
			return ::Lewd.Const.MaleMasteryGropePleasureBonus;
		return 0;
	}

	function getTooltip()
	{
		local tooltip = this.lewd_mastery_effect.getTooltip();
		local pts = this.getPoints();
		if (pts < 0) return tooltip;

		local tier = this.getTier();
		local pos = this.Const.UI.Color.PositiveValue;
		tooltip.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Current tier: [color=" + pos + "]" + tier + "[/color]"
		});

		if (pts >= ::Lewd.Const.MaleMasteryGropeHitThreshold)
		{
			tooltip.push({
				id = 11,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + pos + "]+" + ::Lewd.Const.MaleMasteryGropeHitBonus + "%[/color] Grope hit chance"
			});
		}
		if (pts >= ::Lewd.Const.MaleMasteryGropePleasureThreshold)
		{
			tooltip.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + pos + "]+" + ::Lewd.Const.MaleMasteryGropePleasureBonus + "[/color] Grope pleasure dealt"
			});
		}
		if (pts >= ::Lewd.Const.MaleMasteryGropeHitT3Threshold)
		{
			tooltip.push({
				id = 13,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + pos + "]+" + ::Lewd.Const.MaleMasteryGropeHitT3Bonus + "%[/color] Grope hit chance"
			});
		}

		if (pts < ::Lewd.Const.MaleMasteryGropeHitThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryGropeHitThreshold + ": Hit chance bonus" });
		else if (pts < ::Lewd.Const.MaleMasteryGropeT2)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryGropeT2 + ": Tier 2" });
		else if (pts < ::Lewd.Const.MaleMasteryGropePleasureThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryGropePleasureThreshold + ": Bonus pleasure dealt" });
		else if (pts < ::Lewd.Const.MaleMasteryGropeT3)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryGropeT3 + ": Tier 3" });
		else if (pts < ::Lewd.Const.MaleMasteryGropeHitT3Threshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryGropeHitT3Threshold + ": Hit chance bonus" });

		return tooltip;
	}
});
