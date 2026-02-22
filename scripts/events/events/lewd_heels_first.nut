this.lewd_heels_first <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_heels_first";
		this.m.Title = "At interesting offer..";
		// never fire this event again, as it is a one time thing
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/heels_1_1.png[/img]An opulent palanquin comes into view, hefted on the backs of 8 servants wearing dark blue robes. Another servant, judging from their attire, approaches the party. From a close range, you see that their robes seem to be made from silk. They speak with a thick accent, hands held together in front of them, %SPEECH_ON%I bring an invitation to whoever among you is named %woman% to speak with my lord in his palanquin.%SPEECH_OFF%He looks around, spotting you as you come forward to see what the commotion is about. Weighing the pros and cons of taking on this invitation, the impressive gleam of the tip of the enclosed palanquin convinces you to volunteer yourself. %SPEECH_ON%I am her.%SPEECH_OFF% You say as he gestures for you to walk in front of him. As you get closer, the size of the palanquin becomes clearer. Looking up, it seems more like a mobile house than just a carriage.\n You half expected the palanquin to be lowered, but instead several servants brings a stepped ramp. You take the steps and raise a curtain to enter.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Step into the palanquin.",
					function getResult( _event )
					{
						return "B";
					}

				},
			]
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/heels_1_2.png[/img]The inside feels like a different world, with almost every surface being gilded. The air is also cool and refreshing. %SPEECH_ON%It's saltpeter.%SPEECH_OFF% A single man sits cross legged on a carpet, examining you with sharp eyes like a merchant appraising his wares. He strokes his beard, and speaks without much accent, %SPEECH_ON%I am Qingde, emissary of the great Emperor of the east and am responsible for seeking candidates for His rear court from all over the world. I see potential in you, a warrior at heart but possessing beauty of your own.%SPEECH_OFF% You take a while digesting his words, and from what you know of emperors and his praising of your beauty, you interpret rear court as his harem. Just as you open your mouth to reject this proposal, he interrupts you, %SPEECH_ON%It is a great honor and a great life. Are you not mercenaries for power and wealth? You will be wealthy beyond your imagination and will want for nothing. You will hold power over an incomprehensible number of people, and only be under a few. Is that not what you are striving for?%SPEECH_OFF% He pauses for the logic of his words to stew in your mind, before finishing off with. %SPEECH_ON%You do not have to commit to anything now. I simply want to present you with a gift in coin to show the Empire's generosity, and a gift in fashion to broaden your horizon.%SPEECH_OFF% He lays out a hefty bag of gold along a pair of what appears to be gladiator shoes. They are composed of black straps made of some mysterious leather, golden buckles, and a heel elevating the sole from the ground. Fighting in them would likely be difficult.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Don't look a gift horse in the mouth.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Gifts comes with strings attached, reject the offer.",
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
			ID = "C",
			Text = "[img]gfx/ui/events/heels_1_3.png[/img]He nods as you reach for the coin and says. %SPEECH_ON%You should try on the shoes to make sure the size is right. It may take some getting used to.%SPEECH_OFF% Having already taken the money, you oblige, suddenly embarrassed of the callouses on your feet and the unpleasant scent of your own sweat marinated in leather after a day of physical work in the field. You look to Qingde's eyes as if monitoring for disapproval, but his expression is a wall, seemingly devoid of emotion. Sliding into the straps, you buckle them in without trouble. They are perfectly sized, and the straps hug your feet snugly. Taking some experimental steps, you are surprised at how well you can move in them. It seems doable to get used to them, even in combat. At this, he finally smiles, %SPEECH_ON%Excellent, you are a quick learner. May you hone your craft and refine your beauty on the battlefield. We will see each other later.%SPEECH_OFF% At this, he stands up and holds the curtain open, letting the bright sunlight invade the previous peace indoors. You embark on your first challenge as you descend the steps in your new heels.\n\n You walk slowly and carefully back to camp, concerned about twisting your ankles. The men raise an eyebrow at your new attire, but say nothing seeing the hefty bag of coin in your hand.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A new strut in your step!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{

				{
					local money = 1000;
					Ehis.World.Assets.addMoney(money);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
					});
				}

				local w = _event.m.Woman;

				local items = w.getItems();
				// remove any existing item
				local prevItem = items.getItemAtSlot(this.Const.ItemSlot.Accessory);
				if (prevItem != null) {
					items.unequip(prevItem);
				}
				local item = this.new("scripts/items/heels_black_short");
				items.equip(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You are gifted " + item.getName()
				});

				// push image of transformed character
				this.Characters.push(w.getImagePath());

				this.List.push(::Legends.EventList.changeMood(w, 2.0, "Got a big new secret admirer!"));
			}
		});

	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();

		// don't fire if she already has heels on, or if she already has heel skill
		if (this.m.Woman == null || this.m.Woman.getFlags().getAsInt("heelHeight") > 0 )
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

