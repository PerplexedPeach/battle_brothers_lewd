// Spider Eggs injury -- from spider oviposition.
// Added by spider_inject_skill. Each climax while carrying adds +1 stack
// via onOwnerClimax. Persists after battle for SpiderEggDuration days, then produces egg sac loot items.
this.spider_eggs_effect <- this.inherit("scripts/skills/injury/injury", {
	m = {
		EggCount = 0,
		DaysLeft = 0
	},
	function create()
	{
		this.injury.create();
		this.m.ID = "effects.spider_eggs";
		this.m.Name = "Holding Eggs";
		this.m.Description = "Spider eggs have been implanted inside you. Each clutch weighs you down and saps your strength.";
		this.m.Icon = "skills/lewd_spider_eggs.png";
		this.m.IconMini = "lewd_spider_eggs_mini";
		this.m.DropIcon = "lewd_spider_eggs";
		this.m.IsHealingMentioned = false;
		this.m.IsTreatable = false;
		this.m.IsContentWithReserve = false;
	}

	function onAdded()
	{
		if (this.m.DaysLeft == 0)
			this.m.DaysLeft = ::Lewd.Const.SpiderEggDuration;
		this.m.IsHidden = this.m.EggCount <= 0;

		if (!this.m.IsHidden)
			this.injury.onAdded();

		::logInfo("[spider_eggs] " + this.getContainer().getActor().getName() + " now holds " + this.m.EggCount + " eggs (" + this.m.DaysLeft + " days)");
	}

	function addEgg()
	{
		this.m.EggCount += 1;
		this.m.IsHidden = false;
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

	// Called by onClimax notification -- each climax adds another egg clutch
	function onOwnerClimax( _actor, _source )
	{
		this.addEgg();

		if (_actor.isPlacedOnMap())
			this.spawnIcon("lewd_spider_eggs", _actor.getTile());

		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_actor) + " feels another clutch settling deep inside...");
		::logInfo("[spider_eggs] " + _actor.getName() + " climaxed -- now holds " + this.m.EggCount + " eggs");
	}

	function onCombatFinished()
	{
		this.injury.onCombatFinished();

		if (this.m.EggCount <= 0)
		{
			::logInfo("[spider_eggs] " + this.getContainer().getActor().getName() + " has 0 eggs, removing quietly");
			this.removeSelf();
		}
	}

	// Custom day countdown -- not using injury's healing time system
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

		local item = this.new("scripts/items/misc/lewd_spider_egg_sac_item");
		item.setAmount(this.m.EggCount);
		if (!stash.add(item))
			::logInfo("[spider_eggs] Stash full, could not add egg sac");

		// Fire narrative event
		local evt = this.World.Events.getEvent("event.lewd_spider_eggs_hatch");
		if (evt != null)
		{
			evt.m.Woman = actor;
			evt.m.EggCount = this.m.EggCount;
			this.World.Events.fire("event.lewd_spider_eggs_hatch", false);
		}
	}

	function onSerialize( _out )
	{
		this.injury.onSerialize(_out);
		_out.writeU8(this.m.EggCount);
		_out.writeU8(this.m.DaysLeft);
	}

	function onDeserialize( _in )
	{
		this.injury.onDeserialize(_in);
		this.m.EggCount = _in.readU8();
		this.m.DaysLeft = _in.readU8();
	}
});
