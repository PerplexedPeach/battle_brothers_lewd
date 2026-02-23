this.climax_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 0
	},
	function create()
	{
		this.m.ID = "effects.climax";
		this.m.Name = "Climax";
		this.m.Description = "Overwhelmed by pleasure, leaving them dazed and vulnerable.";
		this.m.Icon = "skills/climax.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_charm_kiss_01.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_02.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_03.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_04.wav"
		];
	}

	function setTurns( _turns )
	{
		this.m.TurnsLeft = _turns;
	}

	function getTooltip()
	{
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
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.ClimaxAPPenalty + "[/color] Action Points"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.ClimaxMeleeDefensePenalty + "[/color] Melee Defense"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.ClimaxInitiativePenalty + "[/color] Initiative"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.ClimaxResolveBonus + "[/color] Resolve"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.ClimaxAllureBonus + "[/color] Allure"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Turns remaining: [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color]"
			}
		];
	}

	function onAdded()
	{
		this.m.TurnsLeft = ::Lewd.Const.ClimaxDuration;
		local actor = this.getContainer().getActor();

		if (actor.isPlacedOnMap())
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill, actor.getPos());
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " reaches climax!");

			// Shameless perk: daze adjacent enemies on own climax
			if (actor.getSkills().hasSkill("perk.lewd_shameless") && actor.isPlacedOnMap())
			{
				local tile = actor.getTile();
				for (local i = 0; i < 6; i++)
				{
					if (tile.hasNextTile(i))
					{
						local nextTile = tile.getNextTile(i);
						if (nextTile.IsOccupiedByActor)
						{
							local adj = nextTile.getEntity();
							if (adj != null && !adj.isAlliedWith(actor) && adj.isAlive())
							{
								this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(adj) + " is dazed by the shameless display!");
								adj.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
							}
						}
					}
				}
			}

			// Pleasure Overflow: when an enemy climaxes, check if any adjacent player ally has the perk
			// If so, splash pleasure to adjacent enemies of the climaxing entity
			if (!actor.isPlayerControlled())
			{
				local hasOverflow = false;
				local tile = actor.getTile();
				for (local i = 0; i < 6; i++)
				{
					if (!hasOverflow && tile.hasNextTile(i))
					{
						local nextTile = tile.getNextTile(i);
						if (nextTile.IsOccupiedByActor)
						{
							local adj = nextTile.getEntity();
							if (adj != null && adj.isAlliedWith(actor) == false && adj.isAlive() && adj.getSkills().hasSkill("perk.lewd_pleasure_overflow"))
								hasOverflow = true;
						}
					}
				}

				if (hasOverflow)
				{
					local splashAmount = this.Math.max(1, this.Math.floor(actor.getPleasureMax() * ::Lewd.Const.PleasureOverflowSplashPct));
					for (local i = 0; i < 6; i++)
					{
						if (tile.hasNextTile(i))
						{
							local nextTile = tile.getNextTile(i);
							if (nextTile.IsOccupiedByActor)
							{
								local adj = nextTile.getEntity();
								// splash to other enemies adjacent to the climaxing enemy (not the player)
								if (adj != null && !adj.isPlayerControlled() && adj.getID() != actor.getID() && adj.isAlive() && adj.getPleasureMax() > 0)
								{
									adj.addPleasure(splashAmount);
									this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(adj) + " receives " + splashAmount + " splash pleasure!");
								}
							}
						}
					}
				}
			}
		}
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local hasTranscendence = actor.getSkills().hasSkill("perk.lewd_transcendence");

		if (hasTranscendence)
		{
			// Transcendence: no AP/MelDef penalties, +10 Allure instead
			_properties.Initiative += ::Lewd.Const.ClimaxInitiativePenalty;
			_properties.Bravery += ::Lewd.Const.ClimaxResolveBonus;
			_properties.Allure += ::Lewd.Const.TranscendenceClimaxAllure;
		}
		else
		{
			_properties.ActionPoints += ::Lewd.Const.ClimaxAPPenalty;
			_properties.MeleeDefense += ::Lewd.Const.ClimaxMeleeDefensePenalty;
			_properties.Initiative += ::Lewd.Const.ClimaxInitiativePenalty;
			_properties.Bravery += ::Lewd.Const.ClimaxResolveBonus;
			_properties.Allure += ::Lewd.Const.ClimaxAllureBonus;
		}
	}

	function onTurnEnd()
	{
		this.m.TurnsLeft -= 1;
		if (this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

	function onCombatFinished()
	{
		this.removeSelf();
	}

	function removeSelf()
	{
		local actor = this.getContainer().getActor();
		actor.getSkills().removeByID(this.m.ID);
	}
});
