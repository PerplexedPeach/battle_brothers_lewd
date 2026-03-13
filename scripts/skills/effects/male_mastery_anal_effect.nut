// Male Anal Mastery — tracks proficiency with anal penetration
// Granted by Forced Entry perk, gains points from male_penetrate_anal
this.male_mastery_anal_effect <- this.inherit("scripts/skills/effects/lewd_mastery_effect", {
	function create()
	{
		this.lewd_mastery_effect.create();
		this.m.ID = "effects.male_mastery_anal";
		this.m.Name = "Anal Mastery";
		this.m.Description = "Brutal experience with taking targets from behind. Knowing how to make masochists squirm.";
		this.m.Icon = "skills/lewd_mastery_anal.png";
		this.m.Limit = ::Lewd.Const.MaleMasteryLimitAnal;
		this.m.BodyPart = "anal";
		this.m.PerkId = "perk.lewd_forced_entry";
		this.m.AssociatedSkillID = "actives.male_penetrate_anal";
	}

	function getTier()
	{
		if (this.m.Points >= ::Lewd.Const.MaleMasteryAnalT3) return 3;
		if (this.m.Points >= ::Lewd.Const.MaleMasteryAnalT2) return 2;
		return 1;
	}

	function getHitBonus()
	{
		if (this.m.Points >= ::Lewd.Const.MaleMasteryAnalHitThreshold)
			return ::Lewd.Const.MaleMasteryAnalHitBonus;
		return 0;
	}

	function getPleasureBonus()
	{
		if (this.m.Points >= ::Lewd.Const.MaleMasteryAnalPleasureThreshold)
			return ::Lewd.Const.MaleMasteryAnalPleasureBonus;
		return 0;
	}

	function getAPBonus()
	{
		if (this.m.Points >= ::Lewd.Const.MaleMasteryAnalAPThreshold)
			return ::Lewd.Const.MaleMasteryAnalAPBonus;
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

		if (pts >= ::Lewd.Const.MaleMasteryAnalHitThreshold)
		{
			tooltip.push({
				id = 11,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + pos + "]+" + ::Lewd.Const.MaleMasteryAnalHitBonus + "%[/color] Penetrate (Anal) hit chance"
			});
		}
		if (pts >= ::Lewd.Const.MaleMasteryAnalPleasureThreshold)
		{
			tooltip.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + pos + "]+" + ::Lewd.Const.MaleMasteryAnalPleasureBonus + "[/color] Penetrate (Anal) pleasure dealt"
			});
		}
		if (pts >= ::Lewd.Const.MaleMasteryAnalAPThreshold)
		{
			tooltip.push({
				id = 13,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + pos + "]" + ::Lewd.Const.MaleMasteryAnalAPBonus + "[/color] AP cost (Penetrate Anal)"
			});
		}

		if (pts < ::Lewd.Const.MaleMasteryAnalHitThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryAnalHitThreshold + ": Hit chance bonus" });
		else if (pts < ::Lewd.Const.MaleMasteryAnalT2)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryAnalT2 + ": Tier 2" });
		else if (pts < ::Lewd.Const.MaleMasteryAnalPleasureThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryAnalPleasureThreshold + ": Bonus pleasure dealt" });
		else if (pts < ::Lewd.Const.MaleMasteryAnalT3)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryAnalT3 + ": Tier 3" });
		else if (pts < ::Lewd.Const.MaleMasteryAnalAPThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryAnalAPThreshold + ": AP cost reduction" });

		return tooltip;
	}
});
