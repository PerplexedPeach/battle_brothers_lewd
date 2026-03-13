// Male Penetration Mastery — tracks proficiency with vaginal penetration and force oral
// Granted by Carnal Knowledge perk, gains points from male_penetrate_vaginal and male_force_oral
this.male_mastery_penetration_effect <- this.inherit("scripts/skills/effects/lewd_mastery_effect", {
	function create()
	{
		this.lewd_mastery_effect.create();
		this.m.ID = "effects.male_mastery_penetration";
		this.m.Name = "Penetration Mastery";
		this.m.Description = "Skill and experience with vaginal penetration and forced oral. Knowing exactly how to move for maximum effect.";
		this.m.Icon = "skills/lewd_mastery_penetration.png";
		this.m.Limit = ::Lewd.Const.MaleMasteryLimitPenetration;
		this.m.BodyPart = "penetration";
		this.m.PerkId = "perk.lewd_carnal_knowledge";
		this.m.AssociatedSkillID = "actives.male_penetrate_vaginal";
	}

	function getTier()
	{
		if (this.m.Points >= ::Lewd.Const.MaleMasteryPenetrationT3) return 3;
		if (this.m.Points >= ::Lewd.Const.MaleMasteryPenetrationT2) return 2;
		return 1;
	}

	// Override to also gain points from force_oral
	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (this.hasPerk() && (_skill.getID() == "actives.male_penetrate_vaginal" || _skill.getID() == "actives.male_force_oral"))
		{
			local chance = ::Lewd.Const.MasteryPointGainBaseChance;
			local ap = _skill.m.ActionPointCost;
			chance += this.Math.floor(ap * ap * ::Lewd.Const.MasteryPointGainAPMultiplier);
			if (this.Math.rand(1, 100) <= chance)
			{
				this.addPoints(1);
			}
			this.m.CombatBonus = true;
		}
	}

	function getPleasureBonus()
	{
		if (this.m.Points >= ::Lewd.Const.MaleMasteryPenetrationPleasureThreshold)
			return ::Lewd.Const.MaleMasteryPenetrationPleasureBonus;
		return 0;
	}

	function getHitBonus()
	{
		if (this.m.Points >= ::Lewd.Const.MaleMasteryPenetrationHitThreshold)
			return ::Lewd.Const.MaleMasteryPenetrationHitBonus;
		return 0;
	}

	function getAPBonus()
	{
		if (this.m.Points >= ::Lewd.Const.MaleMasteryPenetrationAPThreshold)
			return ::Lewd.Const.MaleMasteryPenetrationAPBonus;
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
		tooltip.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Gains points from Penetrate (Vaginal) and Force Oral"
		});

		if (pts >= ::Lewd.Const.MaleMasteryPenetrationPleasureThreshold)
		{
			tooltip.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + pos + "]+" + ::Lewd.Const.MaleMasteryPenetrationPleasureBonus + "[/color] pleasure dealt (Penetrate Vaginal)"
			});
		}
		if (pts >= ::Lewd.Const.MaleMasteryPenetrationHitThreshold)
		{
			tooltip.push({
				id = 12,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + pos + "]+" + ::Lewd.Const.MaleMasteryPenetrationHitBonus + "%[/color] hit chance (Penetrate Vaginal / Force Oral)"
			});
		}
		if (pts >= ::Lewd.Const.MaleMasteryPenetrationAPThreshold)
		{
			tooltip.push({
				id = 13,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + pos + "]" + ::Lewd.Const.MaleMasteryPenetrationAPBonus + "[/color] AP cost (Penetrate Vaginal)"
			});
		}

		if (pts < ::Lewd.Const.MaleMasteryPenetrationPleasureThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryPenetrationPleasureThreshold + ": Bonus pleasure dealt" });
		else if (pts < ::Lewd.Const.MaleMasteryPenetrationT2)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryPenetrationT2 + ": Tier 2" });
		else if (pts < ::Lewd.Const.MaleMasteryPenetrationHitThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryPenetrationHitThreshold + ": Hit chance bonus" });
		else if (pts < ::Lewd.Const.MaleMasteryPenetrationT3)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryPenetrationT3 + ": Tier 3" });
		else if (pts < ::Lewd.Const.MaleMasteryPenetrationAPThreshold)
			tooltip.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "Next at " + ::Lewd.Const.MaleMasteryPenetrationAPThreshold + ": AP cost reduction" });

		return tooltip;
	}
});
