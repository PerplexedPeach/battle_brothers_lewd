// Essence Feed: gain Allure, Initiative, Resolve per nearby Horny enemy
this.perk_lewd_essence_feed <- this.inherit("scripts/skills/skill", {
	m = {
		HornyCount = 0
	},
	function create()
	{
		this.m.ID = "perk.lewd_essence_feed";
		this.m.Name = ::Const.Strings.PerkName.LewdEssenceFeed;
		this.m.Description = ::Const.Strings.PerkDescription.LewdEssenceFeed;
		this.m.Icon = "ui/perks/lewd_essence_feed.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return;

		local myTile = actor.getTile();
		local count = 0;
		local range = ::Lewd.Const.EssenceFeedRange;

		local entities = ::Tactical.Entities.getAllInstancesAsArray();
		foreach (e in entities)
		{
			if (e == null || !e.isAlive() || e.isAlliedWith(actor)) continue;
			if (!e.isPlacedOnMap()) continue;
			if (!e.getSkills().hasSkill("effects.lewd_horny")) continue;
			if (myTile.getDistanceTo(e.getTile()) > range) continue;
			count++;
		}

		this.m.HornyCount = count;

		if (count > 0)
		{
			_properties.Allure += count * ::Lewd.Const.EssenceFeedAllurePerHorny;
			_properties.Initiative += count * ::Lewd.Const.EssenceFeedInitiativePerHorny;
			_properties.Bravery += count * ::Lewd.Const.EssenceFeedResolvePerHorny;
		}
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.HornyCount > 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Currently feeding on [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.HornyCount + "[/color] Horny " + (this.m.HornyCount == 1 ? "enemy" : "enemies") + ":\n[color=" + this.Const.UI.Color.PositiveValue + "]+" + (this.m.HornyCount * ::Lewd.Const.EssenceFeedAllurePerHorny) + "[/color] Allure, [color=" + this.Const.UI.Color.PositiveValue + "]+" + (this.m.HornyCount * ::Lewd.Const.EssenceFeedInitiativePerHorny) + "[/color] Initiative, [color=" + this.Const.UI.Color.PositiveValue + "]+" + (this.m.HornyCount * ::Lewd.Const.EssenceFeedResolvePerHorny) + "[/color] Resolve"
			});
		}
		else
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "No Horny enemies nearby"
			});
		}

		return ret;
	}
});
