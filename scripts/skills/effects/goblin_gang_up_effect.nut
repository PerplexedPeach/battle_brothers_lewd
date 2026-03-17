// Goblin Gang-Up Effect — hidden status effect on targets surrounded by goblins
// Each adjacent goblin increases ReceivedPleasureMult by GoblinGangUpPleasureMult (20%)
// Added/removed dynamically by goblin_lewd_racial or combat hooks
this.goblin_gang_up_effect <- this.inherit("scripts/skills/skill", {
	m = {
		AdjacentGoblins = 0
	},
	function create()
	{
		this.m.ID = "effects.goblin_gang_up";
		this.m.Name = "Surrounded by Goblins";
		this.m.Description = "Goblins are swarming around you, making you more vulnerable to their advances.";
		this.m.Icon = "skills/status_effect_79.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local pct = this.Math.floor(this.m.AdjacentGoblins * ::Lewd.Const.GoblinGangUpPleasureMult * 100);
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
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "" + this.m.AdjacentGoblins + " goblin(s) surrounding you"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + neg + "]+" + pct + "%[/color] pleasure received"
			}
		];
	}

	function countAdjacentGoblins()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isAlive() || !actor.isPlacedOnMap()) return 0;

		local myTile = actor.getTile();
		local count = 0;
		for (local i = 0; i < 6; i++)
		{
			if (!myTile.hasNextTile(i)) continue;
			local tile = myTile.getNextTile(i);
			if (!tile.IsOccupiedByActor) continue;
			local adj = tile.getEntity();
			if (adj == null || !adj.isAlive()) continue;
			if (!::Lewd.Mastery.isGoblin(adj)) continue;
			if (actor.isAlliedWith(adj)) continue;
			count++;
		}
		return count;
	}

	function onUpdate( _properties )
	{
		this.m.AdjacentGoblins = this.countAdjacentGoblins();
		if (this.m.AdjacentGoblins > 0)
			_properties.ReceivedPleasureMult *= 1.0 + this.m.AdjacentGoblins * ::Lewd.Const.GoblinGangUpPleasureMult;
	}

	function onAfterUpdate( _properties )
	{
		// Auto-remove when no goblins are adjacent
		if (this.m.AdjacentGoblins <= 0)
			this.removeSelf();
	}
});
