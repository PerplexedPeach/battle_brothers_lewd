// Restrained status effect — applied by Iron Grip's Restrain ability
// Like being netted: IsRooted, defense penalties, pleasure vulnerability
// Target must use Break Free to escape (same mechanic as net/web)
// TODO: restrained sprite (shibari?), status icon
this.lewd_restrained_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.lewd_restrained";
		this.m.Name = "Restrained";
		this.m.Description = "Held down and bound in place. Unable to move, with reduced ability to defend. Must break free to escape.";
		this.m.Icon = "skills/lewd_restrained.png"; // TODO: icon
		this.m.IconMini = ""; // TODO: mini icon
		this.m.Overlay = ""; // TODO: overlay
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local neg = this.Const.UI.Color.NegativeValue;
		return [
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
				id = 9,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + neg + "]Unable to move[/color]"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + neg + "]" + ::Lewd.Const.RestrainedMeleeDefPenalty + "[/color] Melee Defense"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + neg + "]" + ::Lewd.Const.RestrainedRangedDefPenalty + "[/color] Ranged Defense"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + neg + "]+25%[/color] pleasure received"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsRooted = true;
		_properties.MeleeDefense += ::Lewd.Const.RestrainedMeleeDefPenalty;
		_properties.RangedDefense += ::Lewd.Const.RestrainedRangedDefPenalty;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();

		// Grant break free skill if not already present
		if (!actor.getSkills().hasSkill("actives.break_free"))
		{
			local breakFree = this.new("scripts/skills/actives/break_free_skill");
			breakFree.setChanceBonus(::Lewd.Const.RestrainedBreakFreeBaseChance);
			actor.getSkills().add(breakFree);
		}

		// TODO: show restrained sprite
		// if (actor.hasSprite("status_rooted"))
		// {
		// 	actor.getSprite("status_rooted").setBrush("status_restrained");
		// 	actor.getSprite("status_rooted").Visible = true;
		// }

		actor.setDirty(true);
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		// TODO: hide restrained sprite
		// if (actor.hasSprite("status_rooted"))
		// {
		// 	actor.getSprite("status_rooted").Visible = false;
		// }

		actor.setDirty(true);
	}
});
