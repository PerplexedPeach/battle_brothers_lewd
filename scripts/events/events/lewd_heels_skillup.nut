this.lewd_heels_skillup <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		heelSkill = -1,
	},
	function create()
	{
		this.m.ID = "event.lewd_heels_skillup";
		this.m.Title = "Beauty is Pain";
		this.m.Cooldown = ::Lewd.Const.HeelSkillUpCooldownDays * this.World.getTime().SecondsPerDay;

		local textOne = "%woman% pauses during a march break, adjusting the straps on her %heel_name%. She's been pushing herself, practicing deliberate steps on uneven ground, balancing during sparring sessions, even charging into mock combats without stumbling. The extra height once felt like a curse, throwing off her center and making every swing precarious. But now? It's clicking. Her gait smooths out; the sway becomes natural, almost empowering in its rhythm. She feels the burn in her calves fading, replaced by a strange confidence. Combat in these might still be tricky, but she's adapting faster than expected. One of the brothers, %randombrother%, chuckles from the sidelines. %SPEECH_ON%Captain, you're strutting like some noble's mistress now. Remember when you nearly twisted an ankle on that root? Look at you dancing with death in those things.%SPEECH_OFF% Another, %randombrother2%, nods approvingly but with a smirk. %SPEECH_ON%Aye, and it's doing wonders for morale. Half the lads can't keep their eyes off your legs. Just don't trip in the next scrap, eh?%SPEECH_OFF% %woman% shoots them a glare but can't hide a faint smile. The heels are changing more than her walk: they're reshaping how the company sees her, and how she sees herself."
		local textTwo = "In the aftermath of a skirmish, %woman% wipes blood from her blade, steady on her %heel_name% despite the mud and gore underfoot. She's been drilling relentlessly: lunges in elevation, pivots on the steep lift, parries while arched high. The initial wobbles are gone; now the height gives her leverage, a taller reach that surprises foes. She rolls her ankles experimentally. %randombrother% claps her on the back. %SPEECH_ON%By the old gods, captain, you fought like a demon in those fancy stilts. Thought you'd eat dirt when that orc charged, but you dodged like wind.%SPEECH_OFF% %randombrother2% laughs, eyeing her legs. %SPEECH_ON%And lookin' finer for it. If heels make you that deadly, maybe we all oughta try 'em. Nah, just kiddin', suits you better.%SPEECH_OFF% The praise lingers; %woman% stands taller, literally and figuratively, the adaptation sinking in."
		local textThree = "Around the evening fire, %woman% practices her stride in the %heel_name%, circling the camp with purposeful clicks. The extra height used to make her feel exposed, off-balance amid the rough terrain and stares. But hours of wear, marching, drilling, even sleeping in them sometimes, have honed her. She moves fluidly now, the arch feeling like an extension of her body rather than a hindrance. %randombrother% whistles low. %SPEECH_ON%Captain's got the hang of those torture devices. You were wobblin' like a newborn foal at first, but now? Graceful as a court dancer.%SPEECH_OFF% %randombrother2% grunts, tossing a log on the fire. %SPEECH_ON%Graceful, aye—and distracting. Keep that up, and we'll lose half the fights to oglin' instead of swingin'. But damn if it don't make you look invincible.%SPEECH_OFF% %woman% ignores the jabs, but inside, the growing ease fuels a quiet thrill. The heels are no longer a burden, they're becoming her edge."
		local textFour = "Mid-battle cleanup, %woman% surveys the fallen enemies, her %heel_name% planted firmly in the churned earth. She's been forcing adaptation: charging in them, dodging swings, holding formations despite the lift. The initial stumbles are fading. Now the height aids her vision over shields, her steps precise and predatory. %randombrother% sheathes his weapon, grinning. %SPEECH_ON%Saw you leap that ditch in those heels, captain. Thought you'd snap like a twig, but you're movin' like you've worn 'em all your life.%SPEECH_OFF% %randombrother2% wipes sweat, leering a bit. %SPEECH_ON%And makin' us all jealous. That strut's got the beasts runnin' scared or starin'. Keep it up; it's good for business.%SPEECH_OFF% %woman% flexes her toes in the straps, feeling the surge of mastery. The transformation is rewriting her on the field."
		local textFive = "%woman% has been practicing walking in heels, even in combat. They are starting to feel confident in the %heel_name% and more used to the extra height."

		this.m.Screens.push({
			ID = "A",
			Text = "{ " + textOne + " | " + textTwo + " | " + textThree + " | " + textFour + " | " + textFive + " }",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Strut around the camp",
					function getResult( _event )
					{
						return 0;
					}

				},
			],
			function start( _event )
			{
				local w = _event.m.Woman;

				if (w == null)
				{
					logError("Trying to start lewd heels skillup event but no woman is set");
					return;
				}
				// check heel skill is currently 0
				local currentHeelSkill = w.getFlags().getAsInt("heelSkill");
				local heelHeight = w.getFlags().getAsInt("heelHeight");

				if (heelHeight <= currentHeelSkill)
				{
					// should never happen, but just in case
					logError("Trying to increase heel skill but current heel skill is already " + currentHeelSkill + " and heel height is " + heelHeight);
					return;
				}

				w.getFlags().set("heelSkill", currentHeelSkill + 1);

				this.List.push( {
					id = 16,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Increase your heel skill to " + w.getFlags().getAsInt("heelSkill")
				});

				// push image of transformed character
				this.Characters.push(w.getImagePath());
			}


		});
	}

	function onUpdateScore()
	{
		this.m.Woman = ::Lewd.Transform.target();
		local w = this.m.Woman;

		if (w == null)
		{
			this.m.Score = 0;
		} else {
			local heelSkill = w.getFlags().getAsInt("heelSkill");
			this.m.heelSkill = heelSkill;
			local heelHeight = w.getFlags().getAsInt("heelHeight");
			if (heelHeight <= heelSkill)
			{
				// not wearing heels higher than current skill, can't improve skill
				this.m.Score = 0;
				return;
			}

			local score = ::Lewd.Const.HeelSkillUpBaseScore + (w.getLevel() - 1) * ::Lewd.Const.HeelSkillUpLevelScale + (heelHeight - heelSkill) * ::Lewd.Const.HeelSkillUpDifferenceMultiplier;
			if (w.getSkills().hasSkill("perk.nimble"))
			{
				score += ::Lewd.Const.HeelSkillUpNimbleBonus;
			}
			if (w.getSkills().hasSkill("perk.student"))
			{
				score += ::Lewd.Const.HeelSkillUpStudentBonus;
			}

			this.m.Score = score;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		// local heelSkill = this.m.Woman.getFlags().getAsInt("heelSkill");
		local wornHeels = this.m.Woman.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

		_vars.push([
			"woman",
			this.m.Woman.getName()
		]);
		_vars.push([
			"heel_name",
			wornHeels.getName()
		]);
	}

	function onClear()
	{
		this.m.Woman = null;
	}

});

