this.lewd_drain_hunger <- this.inherit("scripts/events/event", {
	m = {
		Woman = null,
		Victim = null,
		StolenStat = null,
		DrainedTierName = ""
	},
	function create()
	{
		this.m.ID = "event.lewd_drain_hunger";
		this.m.Title = "Insatiable Hunger";
		this.m.Cooldown = ::Lewd.Const.DrainHungerCooldownDays * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "The hunger comes on like a tide, sudden and absolute. You find yourself watching %victim% by the campfire, the way the light catches their jaw, the steady pulse at their throat. They have no idea what stirs behind your eyes.\n\nYou know what you need. Not food, not rest. Something deeper. Something only they can give you, whether they understand it or not.\n\nYou rise from your seat and cross the camp with quiet purpose. %victim% looks up, reading something in your expression that makes their breath catch.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take what you need.",
					function getResult( _event )
					{
						return "B";
					}
				},
				{
					Text = "Resist the urge. Not tonight.",
					function getResult( _event )
					{
						return "Resist";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Woman.getImagePath());
				this.Characters.push(_event.m.Victim.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "B",
			Text = "You place a hand on %victim%'s chest and push them gently onto their back. They don't resist. They never do. Your fingers trace down their body as you straddle them, feeling the warmth radiating from their skin. Their eyes are wide, lips parted, already lost.\n\nYou lean in close, lips brushing their ear. %SPEECH_ON%Relax. Let me take care of you.%SPEECH_OFF%\n\nYour hand slides lower. They shudder, a strangled sound escaping their throat as you work them with practiced precision. You feel the energy building in them, that raw vitality coiling tighter and tighter. Your own body hums in anticipation.\n\nWhen they finally break, you are ready. You seal your lips around them and drink deep, pulling the essence from their core as they convulse beneath you. Their moans dissolve into whimpers, then silence. You swallow every drop, feeling their strength flow into you like warm honey.\n\nYou pull back, licking your lips. %victim% lies spent and glassy eyed, breathing shallow, staring at the stars with an expression of vacant devotion. Something vital has left them. Something that now belongs to you.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Delicious.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local w = _event.m.Woman;
				local v = _event.m.Victim;

				// Upgrade drained tier
				local drainedSkill = ::Lewd.Mastery.upgradeDrainedTier(v);
				if (drainedSkill != null)
				{
					_event.m.DrainedTierName = drainedSkill.getName();
					this.List.push({
						id = 10,
						icon = drainedSkill.getIcon(),
						text = v.getName() + " is now " + drainedSkill.getName()
					});
				}

				// Steal a stat
				local stolen = ::Lewd.Mastery.absorbStat(w, v, true);
				_event.m.StolenStat = stolen;
				if (stolen != null)
				{
					this.List.push({
						id = 11,
						icon = "ui/icons/special.png",
						text = w.getName() + " absorbs [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] " + stolen.label + " from " + v.getName()
					});
				}

				// Mood: victim loses mood, succubus gains mood
				this.List.push(::Legends.EventList.changeMood(v, -1.0, "Was drained by " + w.getName()));
				this.List.push(::Legends.EventList.changeMood(w, 1.0, "Satisfied her hunger"));

				this.Characters.push(w.getImagePath());
				this.Characters.push(v.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Resist",
			Text = "You clench your fists and turn away, forcing yourself back to your seat. The hunger gnaws at your insides, a hollow ache that won't be ignored. Every instinct screams at you to go back, to take what is yours.\n\nBut you hold. Barely.\n\nThe night stretches on, restless and miserable. Sleep brings no relief, only vivid dreams of %victim%'s warmth that leave you more starved than before.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This hunger will only grow worse.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local w = _event.m.Woman;
				this.List.push(::Legends.EventList.changeMood(w, -1.0, "Resisted the hunger, but it lingers"));
				this.Characters.push(w.getImagePath());
			}
		});
	}

	function onUpdateScore()
	{
		// Need an Ethereal succubus
		this.m.Woman = ::Lewd.Transform.target();
		if (this.m.Woman == null)
		{
			this.m.Score = 0;
			return;
		}
		if (::Lewd.Mastery.getLewdTier(this.m.Woman) < 3)
		{
			this.m.Score = 0;
			return;
		}

		// Find a drainable male ally
		local brothers = this.World.getPlayerRoster().getAll();
		local best = null;
		local bestScore = 0;
		local wBase = this.m.Woman.getBaseProperties();

		foreach (bro in brothers)
		{
			if (bro.getID() == this.m.Woman.getID()) continue;
			if (bro.getGender() != 0) continue; // male only

			// Skip tier 3 drained (Enthralled) — nothing left to take
			if (bro.getSkills().hasSkill("trait.drained_third")) continue;

			// Score by how many stats they have above the succubus
			local tBase = bro.getBaseProperties();
			local statScore = 0;
			local stats = ["Hitpoints", "Bravery", "Stamina", "MeleeSkill", "RangedSkill", "MeleeDefense", "RangedDefense", "Initiative"];
			foreach (prop in stats)
			{
				if (tBase[prop] > wBase[prop])
					statScore += 1;
			}

			// Prefer targets with more stealable stats, but allow any non-T3 target
			local score = 1 + statScore;
			if (score > bestScore)
			{
				bestScore = score;
				best = bro;
			}
		}

		if (best == null)
		{
			this.m.Score = 0;
			return;
		}

		this.m.Victim = best;

		local allure = this.m.Woman.getCurrentProperties().Allure;
		this.m.Score = ::Lewd.Const.DrainHungerBaseScore + allure * ::Lewd.Const.DrainHungerAllureScale;
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
		_vars.push([
			"victim",
			this.m.Victim.getName()
		]);
	}

	function onClear()
	{
		this.m.Woman = null;
		this.m.Victim = null;
		this.m.StolenStat = null;
		this.m.DrainedTierName = "";
	}
});
