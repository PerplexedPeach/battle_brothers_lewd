// Spider Eggs effect -- injury-like debuff from spider oviposition.
// Deposited when character climaxes while flagged as spider-injected.
// Persists after battle for SpiderEggDuration days, then produces egg sac loot items.
this.spider_eggs_effect <- this.inherit("scripts/skills/skill", {
	m = {
		EggCount = 1,
		DaysLeft = 0
	},
	function create()
	{
		this.m.ID = "effects.spider_eggs";
		this.m.Name = "Holding Eggs";
		this.m.Description = "Spider eggs have been implanted inside you. Each clutch weighs you down and saps your strength.";
		this.m.Icon = "skills/status_effect_110.png";
		this.m.IconMini = "";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
		this.m.IsSerialized = true;
		this.m.IsRemovedAfterBattle = false;
	}

	function onAdded()
	{
		this.m.DaysLeft = ::Lewd.Const.SpiderEggDuration;
		::logInfo("[spider_eggs] " + this.getContainer().getActor().getName() + " now holds " + this.m.EggCount + " eggs (" + this.m.DaysLeft + " days)");
	}

	function addEgg()
	{
		this.m.EggCount += 1;
		::logInfo("[spider_eggs] " + this.getContainer().getActor().getName() + " now holds " + this.m.EggCount + " eggs");
	}

	function getEggCount()
	{
		return this.m.EggCount;
	}

	function getTooltip()
	{
		local n = this.m.EggCount;
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = "You are carrying [color=" + this.Const.UI.Color.NegativeValue + "]" + n + "[/color] spider egg" + (n > 1 ? " clutches" : " clutch") + " inside you. They will hatch in [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.DaysLeft + "[/color] day" + (this.m.DaysLeft != 1 ? "s" : "") + "."
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + (::Lewd.Const.SpiderEggInitPenalty * n) + "[/color] Initiative"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + (::Lewd.Const.SpiderEggMeleeSkillPenalty * n) + "[/color] Melee Skill"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + (::Lewd.Const.SpiderEggMeleeDefPenalty * n) + "[/color] Melee Defense"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + (::Lewd.Const.SpiderEggRangedSkillPenalty * n) + "[/color] Ranged Skill"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + (::Lewd.Const.SpiderEggRangedDefPenalty * n) + "[/color] Ranged Defense"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + (::Lewd.Const.SpiderEggMaxFatiguePenalty * n) + "[/color] Max Fatigue"
			}
		];

		return tooltip;
	}

	function onUpdate( _properties )
	{
		local n = this.m.EggCount;
		_properties.Initiative += ::Lewd.Const.SpiderEggInitPenalty * n;
		_properties.MeleeSkill += ::Lewd.Const.SpiderEggMeleeSkillPenalty * n;
		_properties.MeleeDefense += ::Lewd.Const.SpiderEggMeleeDefPenalty * n;
		_properties.RangedSkill += ::Lewd.Const.SpiderEggRangedSkillPenalty * n;
		_properties.RangedDefense += ::Lewd.Const.SpiderEggRangedDefPenalty * n;
		_properties.Stamina += ::Lewd.Const.SpiderEggMaxFatiguePenalty * n;
	}

	function onNewDay()
	{
		this.m.DaysLeft--;
		::logInfo("[spider_eggs] " + this.getContainer().getActor().getName() + " eggs: " + this.m.DaysLeft + " days remaining (" + this.m.EggCount + " eggs)");

		if (this.m.DaysLeft <= 0)
		{
			this.produceEggs();
			this.removeSelf();
		}
	}

	function produceEggs()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlayerControlled()) return;

		local stash = this.World.Assets.getStash();
		::logInfo("[spider_eggs] " + actor.getName() + " eggs hatching: producing egg sac with " + this.m.EggCount + " eggs");

		// Produce one stacked egg sac item
		local item = this.new("scripts/items/misc/lewd_spider_egg_sac_item");
		item.setAmount(this.m.EggCount);
		if (!stash.add(item))
			::logInfo("[spider_eggs] Stash full, could not add egg sac");
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU8(this.m.EggCount);
		_out.writeU8(this.m.DaysLeft);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.EggCount = _in.readU8();
		this.m.DaysLeft = _in.readU8();
	}
});
