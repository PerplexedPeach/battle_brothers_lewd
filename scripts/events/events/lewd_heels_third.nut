this.lewd_heels_third <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_heels_third";
		this.m.Title = "At interesting offer..";
		// never fire this event again, as it is a one time thing
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/legend_glutton.png[/img]%woman% has been in reserves, and has filled %their_woman% spare time with food. Snacking through the day and taking second helpings at meal times, it is starting to impact your supplies. Perhaps %they_woman% needs more movement, or less food.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Flaunt your new stylish footwear!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Disregard such frivolous nonsense.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}

		});

		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/legend_glutton.png[/img]You decide to get %woman% a pair of heels to help with posture and encourage more movement. The heels are quite high, but %they_woman% is determined to make them work. After a few days of stumbling and falling, %they_woman% finally gets the hang of it. Now, %they_woman% struts around camp with confidence, showing off %their_woman% new footwear. The other mercenaries can\'t help but admire %their style and grace. It\'s a small change, but it\'s clear that %they_woman% is feeling more confident and comfortable in %their_woman% own skin. The heels may have been a bit of a challenge at first, but they\'ve definitely paid off in the end.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A new strut in their step!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local w = _event.m.Woman;

				local items = w.getItems();
				local item = this.new("scripts/items/heels_ballet");
				item.getFlags().set("cursed", true);
				items.equip(item);
				this.List.push({
					id = 10,
					icon = "ui/items/accessory/ballet_heels.png",
					text = "You are cursed to wear " + item.getName()
				});

				local toAdd = ["scripts/skills/traits/delicate_trait"];
				local toRemove = ["trait.dainty", "trait.huge", "trait.strong", "trait.tough", "trait.legend_heavy"];
				local skills = w.getSkills();
				{
					local skill = this.new("scripts/skills/traits/delicate_trait");
					skills.add(skill);
					this.List.push({
						id = 11,
						icon = skill.getIcon(),
						text = w.getName() + " is now " + skill.getName()
					});
				}
				local idx = 13;
				foreach (removedSkill in toRemove)
				{
					if (skills.hasSkill(removedSkill))
					{
						local skill = skills.getSkillByID(removedSkill);
						skills.removeByID(removedSkill);
						this.List.push({
							id = idx,
							icon = skill.getIcon(),
							text = w.getName() + " is no longer " + skill.getName()
						});
						idx++;
					}
				}

				::Lewd.Transform.sexy_stage_2(w);

				// push image of transformed character
				this.Characters.push(w.getImagePath());

				// TODO lower mood of other mercs due to lack of respect
				this.List.push(::Legends.EventList.changeMood(w, 2.0, "Got new footwear"));
			}
		});

	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if(bro.getGender() == 1 && bro.getFlags().get("IsPlayerCharacter")){
				if (bro.getFlags().get("IsPlayerCharacter")) {
					this.m.Woman = bro;
					break;
				} else {
					candidates.push(bro);
				}
			}
		}

		// TODO handle when you are not playing as avatar, but for now only support avatar due to narrative perspective
		// prefer avatar/player character if possible, otherwise randomly select a woman
		// if (this.m.Woman == null && candidates.len() > 0)
		// {
		// 	this.m.Woman = candidates[this.Math.rand(0, candidates.len() - 1)];
		// }

		if (this.m.Woman == null)
		{
			this.m.Score = 0;
		} else {
			// scale with reputation
			this.m.Score = ::Lewd.Const.HeelFirstEventBaseScore + this.World.Assets.getBusinessReputation() * ::Lewd.Const.HeelFirstEventScoreRenownScale;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"woman",
			this.m.Woman.getName()
		]);
	}

	function onClear()
	{
		this.m.Woman = null;
	}

});

