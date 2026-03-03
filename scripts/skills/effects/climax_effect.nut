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
		this.m.IsRemovedAfterBattle = true;
		this.m.SoundOnUse = ::Lewd.Const.SoundOrgasm;
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
			local soundPool = this.m.SoundOnUse;
			if (actor.getGender() == 0 && ::Lewd.Const.SoundMaleOrgasm.len() > 0)
				soundPool = ::Lewd.Const.SoundMaleOrgasm;
			this.Sound.play(soundPool[this.Math.rand(0, soundPool.len() - 1)], this.Const.Sound.Volume.Skill, actor.getPos());
			this.Tactical.spawnSpriteEffect("climax", this.createColor("#ffffff"), actor.getTile(),
				this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY,
				this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale,
				this.Const.Tactical.Settings.SkillOverlayStayDuration * 2, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " reaches climax!");

			// Shameless perk: make adjacent enemies horny and deal pleasure to sex partner on own climax
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
								this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(adj) + " is aroused by the shameless display!");
								if (adj.getSkills().hasSkill("effects.lewd_horny"))
								{
									adj.getSkills().getSkillByID("effects.lewd_horny").onRefresh();
								}
								else
								{
									adj.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
								}
							}
						}
					}
				}

				// Deal pleasure to mount partner on own climax
				local partner = null;
				local mountedEffect = actor.getSkills().getSkillByID("effects.lewd_mounted");
				local mountingEffect = actor.getSkills().getSkillByID("effects.lewd_mounting");
				if (mountedEffect != null)
					partner = this.Tactical.getEntityByID(mountedEffect.getMounterID());
				else if (mountingEffect != null)
					partner = this.Tactical.getEntityByID(mountingEffect.getTargetID());

				if (partner != null && partner.isAlive() && partner.getPleasureMax() > 0)
				{
					partner.addPleasure(::Lewd.Const.ShamelessClimaxPleasure, actor);
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(partner) + " receives " + ::Lewd.Const.ShamelessClimaxPleasure + " pleasure from the shameless climax!");
				}
			}

			// Insatiable perk: grant AP to whoever actively caused this climax
			if (actor.m.LastPleasureSourceID >= 0)
			{
				local source = this.Tactical.getEntityByID(actor.m.LastPleasureSourceID);
				if (source != null && source.isAlive() && source.getSkills().hasSkill("perk.lewd_insatiable"))
				{
					source.setActionPoints(this.Math.min(source.getActionPointsMax(), source.getActionPoints() + ::Lewd.Const.InsatiableAPGain));
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(source) + " gains +" + ::Lewd.Const.InsatiableAPGain + " AP from Insatiable!");
				}
			}

			// Cum facial: when male climaxes, chance to apply cum to sex partner's face
			if (actor.getGender() == 0)
			{
				local cumTarget = null;

				// Find sex partner: mounting effect first, then LastPleasureSourceID
				if (actor.getSkills().hasSkill("effects.lewd_mounting"))
				{
					local mounting = actor.getSkills().getSkillByID("effects.lewd_mounting");
					cumTarget = this.Tactical.getEntityByID(mounting.getTargetID());
				}
				else if (actor.m.LastPleasureSourceID >= 0)
				{
					cumTarget = this.Tactical.getEntityByID(actor.m.LastPleasureSourceID);
				}

				if (cumTarget != null && cumTarget.isAlive() && cumTarget.hasSprite("cum_facial"))
				{
					// Determine sex type from continuation flags
					local sexType = "";
					if (actor.getFlags().has("lewdCont_" + cumTarget.getID()))
						sexType = actor.getFlags().get("lewdCont_" + cumTarget.getID());

					local chance = ::Lewd.Const.CumFacialChanceDefault;
					if (sexType == "oral")        chance = ::Lewd.Const.CumFacialChanceOral;
					else if (sexType == "hands")   chance = ::Lewd.Const.CumFacialChanceHands;
					else if (sexType == "vaginal") chance = ::Lewd.Const.CumFacialChanceVaginal;
					else if (sexType == "anal")    chance = ::Lewd.Const.CumFacialChanceAnal;
					else if (sexType == "feet")    chance = ::Lewd.Const.CumFacialChanceFeet;

					if (this.Math.rand(1, 100) <= chance)
					{
						// Spawn ejaculation projectile from male to female
						local time = this.Tactical.spawnProjectileEffect(
							"effect_cum_01", actor.getTile(), cumTarget.getTile(),
							0.5, 1.5, false, false);

						// On arrival: apply cum facial sprite + visual effects
						local self = this;
						this.Time.scheduleEvent(this.TimeUnit.Virtual, time, function(_d) {
							if (!_d.Target.isAlive()) return;
							_d.Target.getSprite("cum_facial").setBrush("cum_head");
							_d.Target.getSprite("cum_facial").Visible = true;
							_d.Target.setDirty(true);
							// Overlay effect on target
							this.Tactical.spawnSpriteEffect("climax", this.createColor("#ffffff"), _d.Target.getTile(),
								this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY,
								this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale,
								this.Const.Tactical.Settings.SkillOverlayStayDuration, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
							// Camera quake on impact
							this.Tactical.getCamera().quake(_d.Source, _d.Target, 3.0, 0.12, 0.25);
						}.bindenv(self), { Target = cumTarget, Source = actor });

						this.Tactical.EventLog.log(
							this.Const.UI.getColorizedEntityName(actor) + " finishes on " +
							this.Const.UI.getColorizedEntityName(cumTarget) + "'s face!");
					}
				}
			}

			// Dom/Sub tracking: award points on climax
			local sourceID = actor.m.LastPleasureSourceID;
			if (sourceID >= 0 && sourceID != actor.getID())
			{
				// Someone else actively caused this climax
				// Actor shifts Sub (-1)
				::Lewd.Mastery.addDomSub(actor, -1);

				// Source shifts Dom (+1)
				local domSource = this.Tactical.getEntityByID(sourceID);
				if (domSource != null && domSource.isAlive())
				{
					::Lewd.Mastery.addDomSub(domSource, 1);
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

});
