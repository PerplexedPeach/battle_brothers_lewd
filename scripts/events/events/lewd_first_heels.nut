this.lewd_first_heels <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_first_heels";
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
				this.Characters.push(w.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/items/accessory/black_heels.png",
					text = "You gain Black Heels"
				});
				local items = w.getItems();
				local item = this.new("scripts/items/glowing_amulet_of_valor");
				item.getFlags().set("cursed", true);
				items.equip(item);
				// this.World.Assets.getStash().add(this.new("scripts/items/accessory/black_heels"));

				// change sprite
				w.getSprite("head").setBrush("bust_head_lewd_02");
				w.getSprite("body").setBrush("bust_body_lewd_02");
				// w.getSprite("body").setHorizontalFlipping(true);
				// clear scars and tattoos
				w.getSprite("tattoo_body").setBrush("");
				// clear bust so accessories are visible
				w.getSprite("miniboss").setBrush("");

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
				// TODO check against having this item or traits
				this.m.Woman = bro;
				// scale with reputation
				this.m.Score = 5 + this.World.Assets.getBusinessReputation() / 50;
			}
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

