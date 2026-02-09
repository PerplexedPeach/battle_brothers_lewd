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

		this.m.Screens.push({
			ID = "A",
			Text = "%woman% has been practicing walking in heels, even in combat. %They_woman% is starting to feel confident in the %heel_name% and more used to the extra height.",
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

