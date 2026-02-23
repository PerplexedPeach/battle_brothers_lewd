// Generic temporary debuff applied by T3 sex abilities
this.lewd_sex_debuff_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 1,
		ResolveDebuff = 0,
		InitDebuff = 0,
		APDebuff = 0,
		MelDefDebuff = 0
	},
	function create()
	{
		this.m.ID = "effects.lewd_sex_debuff";
		this.m.Name = "Distracted";
		this.m.Description = "Still reeling from a lewd encounter.";
		this.m.Icon = "skills/lewd_sex_debuff.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = false;
	}

	function setDebuffs( _table )
	{
		if ("Resolve" in _table) this.m.ResolveDebuff = _table.Resolve;
		if ("Init" in _table) this.m.InitDebuff = _table.Init;
		if ("AP" in _table) this.m.APDebuff = _table.AP;
		if ("MelDef" in _table) this.m.MelDefDebuff = _table.MelDef;
		if ("Duration" in _table) this.m.TurnsLeft = _table.Duration;
	}

	function getTooltip()
	{
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		if (this.m.ResolveDebuff != 0)
		{
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.ResolveDebuff + "[/color] Resolve"
			});
		}
		if (this.m.InitDebuff != 0)
		{
			result.push({
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.InitDebuff + "[/color] Initiative"
			});
		}
		if (this.m.APDebuff != 0)
		{
			result.push({
				id = 12,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.APDebuff + "[/color] Action Points"
			});
		}
		if (this.m.MelDefDebuff != 0)
		{
			result.push({
				id = 13,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.MelDefDebuff + "[/color] Melee Defense"
			});
		}

		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Turns remaining: [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color]"
		});

		return result;
	}

	function onUpdate( _properties )
	{
		if (this.m.ResolveDebuff != 0) _properties.Bravery += this.m.ResolveDebuff;
		if (this.m.InitDebuff != 0) _properties.Initiative += this.m.InitDebuff;
		if (this.m.APDebuff != 0) _properties.ActionPoints += this.m.APDebuff;
		if (this.m.MelDefDebuff != 0) _properties.MeleeDefense += this.m.MelDefDebuff;
	}

	function onTurnEnd()
	{
		this.m.TurnsLeft -= 1;
		if (this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

	function onCombatFinished()
	{
		this.removeSelf();
	}

	function removeSelf()
	{
		this.getContainer().getActor().getSkills().removeByID(this.m.ID);
	}
});
