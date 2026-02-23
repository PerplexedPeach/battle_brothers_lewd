this.lewd_mastery_hands_effect <- this.inherit("scripts/skills/effects/lewd_mastery_effect", {
	function create()
	{
		this.lewd_mastery_effect.create();
		this.m.ID = "effects.lewd_mastery_hands";
		this.m.Name = "Hands Mastery";
		this.m.Description = "Dexterity and skill with your hands for pleasuring others.";
		this.m.Icon = "skills/lewd_mastery_hands.png";
		this.m.Limit = ::Lewd.Const.MasteryLimitHands;
		this.m.BodyPart = "hands";
		this.m.PerkId = "perk.lewd_nimble_fingers";
		this.m.AssociatedSkillID = "actives.lewd_hands";
	}

	function getTier()
	{
		if (this.m.Points >= ::Lewd.Const.MasteryHandsT3) return 3;
		if (this.m.Points >= ::Lewd.Const.MasteryHandsT2) return 2;
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

		if (pts >= ::Lewd.Const.MasteryHandsHitThreshold)
		{
			tooltip.push({
				id = 11,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.MasteryHandsHitBonus + "%[/color] hit chance"
			});
		}
		if (pts >= ::Lewd.Const.MasteryHandsPleasureThreshold)
		{
			tooltip.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.MasteryHandsPleasureBonus + "[/color] pleasure dealt"
			});
		}
		if (pts >= ::Lewd.Const.MasteryHandsAPThreshold)
		{
			tooltip.push({
				id = 13,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.MasteryHandsAPBonus + "[/color] AP cost"
			});
		}

		if (pts < ::Lewd.Const.MasteryHandsHitThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryHandsHitThreshold + ": Hit chance bonus" });
		else if (pts < ::Lewd.Const.MasteryHandsT2)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryHandsT2 + ": Skill upgrades to Handjob" });
		else if (pts < ::Lewd.Const.MasteryHandsPleasureThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryHandsPleasureThreshold + ": Bonus pleasure dealt" });
		else if (pts < ::Lewd.Const.MasteryHandsT3)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryHandsT3 + ": Skill upgrades to Skilled Handjob" });
		else if (pts < ::Lewd.Const.MasteryHandsAPThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryHandsAPThreshold + ": AP cost reduction" });

		return tooltip;
	}
});
