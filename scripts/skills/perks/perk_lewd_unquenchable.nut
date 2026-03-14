// Unquenchable: +3 Allure per enemy climax caused this battle (resets between fights)
// Climax increment handled via hook in mod_lewd.nut
this.perk_lewd_unquenchable <- this.inherit("scripts/skills/skill", {
	m = {
		ClimaxCount = 0
	},
	function create()
	{
		this.m.ID = "perk.lewd_unquenchable";
		this.m.Name = ::Const.Strings.PerkName.LewdUnquenchable;
		this.m.Description = ::Const.Strings.PerkDescription.LewdUnquenchable;
		this.m.Icon = "ui/perks/lewd_unquenchable.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function addClimax()
	{
		this.m.ClimaxCount += 1;
		this.getContainer().getActor().setDirty(true);
	}

	function onCombatStarted()
	{
		this.m.ClimaxCount = 0;
	}

	function onUpdate( _properties )
	{
		if (this.m.ClimaxCount > 0)
		{
			_properties.Allure += this.m.ClimaxCount * ::Lewd.Const.UnquenchableAllurePerClimax;
		}
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.ClimaxCount > 0)
		{
			local totalAllure = this.m.ClimaxCount * ::Lewd.Const.UnquenchableAllurePerClimax;
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.ClimaxCount + "[/color] " + (this.m.ClimaxCount == 1 ? "climax" : "climaxes") + " caused: [color=" + this.Const.UI.Color.PositiveValue + "]+" + totalAllure + "[/color] Allure"
			});
		}
		else
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "No climaxes caused yet this battle"
			});
		}

		return ret;
	}
});
