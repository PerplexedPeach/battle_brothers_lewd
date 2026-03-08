this.lewd_mastery_anal_effect <- this.inherit("scripts/skills/effects/lewd_mastery_effect", {
	function create()
	{
		this.lewd_mastery_effect.create();
		this.m.ID = "effects.lewd_mastery_anal";
		this.m.Name = "Anal Mastery";
		this.m.Description = "Experience with submission and taking pleasure from pain.";
		this.m.Icon = "skills/lewd_mastery_anal.png";
		this.m.Limit = ::Lewd.Const.MasteryLimitAnal;
		this.m.BodyPart = "anal";
		this.m.PerkId = "perk.lewd_offering";
		this.m.AssociatedSkillID = "actives.lewd_anal";
	}

	function getTier()
	{
		if (this.m.Points >= ::Lewd.Const.MasteryAnalT3) return 3;
		if (this.m.Points >= ::Lewd.Const.MasteryAnalT2) return 2;
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

		if (pts >= ::Lewd.Const.MasteryAnalResolveThreshold)
		{
			tooltip.push({
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.MasteryAnalResolveBonus + "[/color] Resolve"
			});
		}
		if (pts >= ::Lewd.Const.MasteryAnalAPThreshold)
		{
			tooltip.push({
				id = 12,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.MasteryAnalAPBonus + "[/color] AP cost"
			});
		}
		if (pts >= ::Lewd.Const.MasteryAnalSplashThreshold)
		{
			tooltip.push({
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Climax pleasure splashes to adjacent enemies"
			});
		}

		if (pts < ::Lewd.Const.MasteryAnalResolveThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryAnalResolveThreshold + ": Resolve bonus" });
		else if (pts < ::Lewd.Const.MasteryAnalT2)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryAnalT2 + ": Skill upgrades to Take It" });
		else if (pts < ::Lewd.Const.MasteryAnalAPThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryAnalAPThreshold + ": AP cost reduction" });
		else if (pts < ::Lewd.Const.MasteryAnalT3)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryAnalT3 + ": Skill upgrades to Pain is Pleasure" });
		else if (pts < ::Lewd.Const.MasteryAnalSplashThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MasteryAnalSplashThreshold + ": Climax splash" });

		return tooltip;
	}

	function onUpdate( _properties )
	{
		if (this.getPoints() < 0) return;
		if (this.m.Points >= ::Lewd.Const.MasteryAnalResolveThreshold)
		{
			_properties.Bravery += ::Lewd.Const.MasteryAnalResolveBonus;
		}
	}
});
