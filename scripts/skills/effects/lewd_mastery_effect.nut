this.lewd_mastery_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Points = 0,
		Limit = 100,
		BodyPart = "",
		PerkId = "",
		CombatBonus = false,
		AssociatedSkillID = ""
	},

	function create()
	{
		this.m.ID = "effects.lewd_mastery";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
	}

	function isHidden()
	{
		if (!this.getContainer().getActor().getSkills().hasSkill(this.m.PerkId)) return true;
		return this.m.Points <= 0;
	}

	function addPoints( _add )
	{
		local add = _add;
		// (Practiced Control no longer boosts mastery — it reduces reflection instead)
		this.m.Points = this.Math.min(this.m.Points + add, this.m.Limit);
	}

	function getPoints()
	{
		if (this.isHidden()) return -1;
		return this.m.Points;
	}

	function getTier()
	{
		return 1; // overridden by children
	}

	function getName()
	{
		return this.m.Name + " (" + this.m.Points + "/" + this.m.Limit + ")";
	}

	function getTooltip()
	{
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.m.Description
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Gain mastery points by using associated abilities in combat"
			}
		];
		if (this.getPoints() >= 0)
		{
			tooltip.push({
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "+" + ::Lewd.Const.MasteryCombatBonus + " points at end of battle if ability was used"
			});
		}
		return tooltip;
	}

	function onCombatStarted()
	{
		if (!this.isHidden())
			this.m.CombatBonus = true;
	}

	function onCombatFinished()
	{
		if (!this.isHidden() && this.m.CombatBonus)
		{
			this.m.CombatBonus = false;
			this.addPoints(::Lewd.Const.MasteryCombatBonus);
		}
	}

	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (this.getPoints() >= 0 && _skill.getID() == this.m.AssociatedSkillID)
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

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU8(this.m.Points);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.Points = _in.readU8();
	}
});
