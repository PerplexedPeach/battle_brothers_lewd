// Restrain — active skill from Iron Grip perk
// Requires: user is mounting a target, free offhand
// Applies lewd_restrained_effect on the mounted target
// TODO: ability icon, disabled icon, overlay
this.restrain_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.lewd_restrain";
		this.m.Name = "Restrain";
		this.m.Description = "Pin down and bind the target you are mounting, holding them completely in place. The target must break free as if caught in a net.";
		this.m.Icon = "skills/lewd_restrain.png"; // TODO: icon
		this.m.IconDisabled = "skills/lewd_restrain_bw.png"; // TODO: icon
		this.m.Overlay = ""; // TODO: overlay
		this.m.SoundOnUse = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = ::Lewd.Const.RestrainAP;
		this.m.FatigueCost = ::Lewd.Const.RestrainFatigue;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function isHidden()
	{
		// Only visible when mounting someone
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("effects.lewd_mounting")) return true;
		return false;
	}

	function isUsable()
	{
		if (!this.skill.isUsable()) return false;

		// Requires free offhand
		local actor = this.getContainer().getActor();
		local offhand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		if (offhand != null) return false;

		// Also check mainhand is not a two-hander occupying offhand
		local mainhand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (mainhand != null && mainhand.isItemType(this.Const.Items.ItemType.TwoHanded)) return false;

		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
		local target = _targetTile.getEntity();
		if (target == null) return false;

		// Must be mounting this specific target
		local actor = this.getContainer().getActor();
		local mountingEffect = actor.getSkills().getSkillByID("effects.lewd_mounting");
		if (mountingEffect == null) return false;
		if (mountingEffect.getTargetID() != target.getID()) return false;

		// Target not already restrained
		if (target.getSkills().hasSkill("effects.lewd_restrained")) return false;

		// Target not immune to root
		if (target.getCurrentProperties().IsImmuneToRoot) return false;

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;

		target.getSkills().add(this.new("scripts/skills/effects/lewd_restrained_effect"));

		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " restrains " + this.Const.UI.getColorizedEntityName(target) + "!");

		return true;
	}

	function getTooltip()
	{
		local pos = this.Const.UI.Color.PositiveValue;
		local neg = this.Const.UI.Color.NegativeValue;

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
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Target is [color=" + neg + "]rooted[/color] in place (like being netted)"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + neg + "]" + ::Lewd.Const.RestrainedMeleeDefPenalty + "[/color] Melee Defense on target"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + neg + "]" + ::Lewd.Const.RestrainedRangedDefPenalty + "[/color] Ranged Defense on target"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + neg + "]+25%[/color] pleasure received by target"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Target must [color=" + pos + "]Break Free[/color] to escape"
			}
		];

		// Usability warnings
		local actor = this.getContainer().getActor();
		if (!actor.getSkills().hasSkill("effects.lewd_mounting"))
		{
			result.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + neg + "]Requires:[/color] Must be mounting a target"
			});
		}

		local offhand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		local mainhand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local twoHanded = mainhand != null && mainhand.isItemType(this.Const.Items.ItemType.TwoHanded);
		if (offhand != null || twoHanded)
		{
			result.push({
				id = 21,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + neg + "]Requires:[/color] Free offhand"
			});
		}

		return result;
	}
});
