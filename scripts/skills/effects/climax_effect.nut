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
			// Default: female orgasm sounds
			local soundPool = this.m.SoundOnUse;
			local pitch = 1.0;

			if (::Lewd.Const.SoundMaleOrgasm.len() > 0)
			{
				local gender = actor.getGender();
				local entityType = actor.getType();

				// Male humanoids: use male orgasm sounds at normal pitch
				if (gender == 0)
				{
					soundPool = ::Lewd.Const.SoundMaleOrgasm;
				}
				// Non-humanoids (gender -1 or undefined): use male orgasm sounds pitched by species
				// TODO: species-specific climax sounds for each creature type
				else if (gender != 1)
				{
					soundPool = ::Lewd.Const.SoundMaleOrgasm;

					if (entityType == this.Const.EntityType.Unhold || entityType == this.Const.EntityType.UnholdBog || entityType == this.Const.EntityType.UnholdFrost)
						pitch = 0.6; // deep, rumbling
					else if (entityType == this.Const.EntityType.OrcWarrior || entityType == this.Const.EntityType.OrcBerserker || entityType == this.Const.EntityType.OrcWarlord || entityType == this.Const.EntityType.OrcYoung)
						pitch = 0.75; // guttural
					else if (entityType == this.Const.EntityType.GoblinAmbusher || entityType == this.Const.EntityType.GoblinFighter || entityType == this.Const.EntityType.GoblinWolfrider || entityType == this.Const.EntityType.GoblinLeader || entityType == this.Const.EntityType.GoblinShaman)
						pitch = 1.4; // high-pitched
					else if (entityType == this.Const.EntityType.Direwolf || entityType == this.Const.EntityType.Wolf)
						pitch = 0.5; // bestial growl
					else
						pitch = 0.8; // generic non-humanoid fallback
				}
				// gender == 1 (female): keep default female sounds
			}

			this.Sound.play(soundPool[this.Math.rand(0, soundPool.len() - 1)], this.Const.Sound.Volume.Skill * ::Lewd.Const.SexSoundVolume, actor.getPos(), pitch);
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
					local insatiable = source.getSkills().getSkillByID("perk.lewd_insatiable");
					if (insatiable.canTrigger())
					{
						insatiable.recordTrigger();
						source.setActionPoints(this.Math.min(source.getActionPointsMax(), source.getActionPoints() + ::Lewd.Const.InsatiableAPGain));
						source.setDirty(true);
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(source) + " gains +" + ::Lewd.Const.InsatiableAPGain + " AP from Insatiable!");
					}
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
					::logInfo("[cum_facial] " + actor.getName() + " is mounting, target ID=" + mounting.getTargetID() + " resolved=" + (cumTarget != null ? cumTarget.getName() : "null"));
				}
				else if (actor.m.LastPleasureSourceID >= 0)
				{
					cumTarget = this.Tactical.getEntityByID(actor.m.LastPleasureSourceID);
					::logInfo("[cum_facial] " + actor.getName() + " using LastPleasureSourceID=" + actor.m.LastPleasureSourceID + " resolved=" + (cumTarget != null ? cumTarget.getName() : "null"));
				}
				else
				{
					::logInfo("[cum_facial] " + actor.getName() + " has no mount target and LastPleasureSourceID=" + actor.m.LastPleasureSourceID + ", skipping");
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

					local roll = this.Math.rand(1, 100);
					::logInfo("[cum_facial] " + actor.getName() + " -> " + cumTarget.getName() + " sexType=" + sexType + " chance=" + chance + " roll=" + roll);

					if (roll <= chance)
					{
						::logInfo("[cum_facial] HIT! Spawning projectile from " + actor.getName() + " tile=" + actor.getTile().ID + " to " + cumTarget.getName() + " tile=" + cumTarget.getTile().ID);

						// Spawn ejaculation projectile from male to female
						local time = this.Tactical.spawnProjectileEffect(
							"effect_cum_01", actor.getTile(), cumTarget.getTile(),
							0.5, 1.5, false, false);

						::logInfo("[cum_facial] Projectile spawned, arrival time=" + time + " scheduling sprite apply");

						// On arrival: apply cum facial sprite + visual effects
						local Tactical = this.Tactical;
						local Const = this.Const;
						this.Time.scheduleEvent(this.TimeUnit.Virtual, time, function(_d) {
							::logInfo("[cum_facial] Scheduled callback fired for " + _d.Target.getName() + " alive=" + _d.Target.isAlive());
							if (!_d.Target.isAlive()) return;
							_d.Target.getSprite("cum_facial").setBrush("cum_head");
							_d.Target.getSprite("cum_facial").Visible = true;
							_d.Target.setDirty(true);
							::logInfo("[cum_facial] Applied cum_head brush to " + _d.Target.getName() + ", sprite visible=true");
							// Camera quake on impact (source may be dead from orgasm defeat)
							if (_d.Source.isAlive())
								_d.Tactical.getCamera().quake(_d.Source, _d.Target, 3.0, 0.12, 0.25);
						}, { Target = cumTarget, Source = actor, Tactical = Tactical, Const = Const });

						this.Tactical.EventLog.log(
							this.Const.UI.getColorizedEntityName(actor) + " finishes on " +
							this.Const.UI.getColorizedEntityName(cumTarget) + "'s face!");
					}
				}
				else if (cumTarget != null)
				{
					::logInfo("[cum_facial] " + actor.getName() + " -> " + cumTarget.getName() + " SKIPPED: alive=" + cumTarget.isAlive() + " hasSprite=" + cumTarget.hasSprite("cum_facial"));
				}
			}

			// Dom/Sub tracking: award points on climax
			local sourceID = actor.m.LastPleasureSourceID;
			if (sourceID >= 0 && sourceID != actor.getID())
			{
				// Someone else actively caused this climax
				// Actor shifts Sub (-1)
				::Lewd.Mastery.addDomSub(actor, -1);

				// Source shifts Dom (+1), unless Open Invitation is active (submissive stance)
				local domSource = this.Tactical.getEntityByID(sourceID);
				if (domSource != null && domSource.isAlive())
				{
					if (domSource.getSkills().hasSkill("effects.open_invitation"))
					{
						// Open Invitation: submissive gesture, accumulate 0.1 sub per climax inflicted
						local accum = domSource.getFlags().getAsInt("lewdOISubAccum") + 1;
						if (accum >= 10)
						{
							::Lewd.Mastery.addDomSub(domSource, -1);
							accum = 0;
						}
						domSource.getFlags().set("lewdOISubAccum", accum);
					}
					else
						::Lewd.Mastery.addDomSub(domSource, 1);

					// Persistent partner-climax counter on the source player
					if (domSource.isPlayerControlled())
					{
						local cur = domSource.getFlags().getAsInt("lewdPartnerClimaxes");
						domSource.getFlags().set("lewdPartnerClimaxes", cur + 1);
					}

					// Ethereal stat absorption: source learns from enemies they make climax
					if (::Lewd.Const.EtherealStatAbsorptionEnabled
						&& domSource.isPlayerControlled()
						&& ::Lewd.Mastery.getLewdTier(domSource) >= ::Lewd.Const.EtherealStatAbsorptionMinTier)
					{
						local absorbed = ::Lewd.Mastery.absorbStat(domSource, actor, false);
						if (absorbed != null)
						{
							this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(domSource) + " absorbs +1 " + absorbed.label + " from " + this.Const.UI.getColorizedEntityName(actor));
							::Lewd.Mastery.playAbsorbEffect(domSource, this.Tactical, this.Const, this.Sound, this.Time);
						}
					}

					// Ethereal draining: when an Ethereal+ succubus makes an ally climax, drain them
					if (::Lewd.Mastery.getLewdTier(domSource) >= 3
						&& domSource.isAlliedWith(actor))
					{
						::Lewd.Mastery.drainTarget(domSource, actor, { Tactical = this.Tactical, Const = this.Const, Sound = this.Sound, Time = this.Time });
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
			_properties.Allure += ::Lewd.Const.TranscendenceClimaxAllure;
		}
		else
		{
			_properties.ActionPoints += ::Lewd.Const.ClimaxAPPenalty;
			_properties.MeleeDefense += ::Lewd.Const.ClimaxMeleeDefensePenalty;
			_properties.Initiative += ::Lewd.Const.ClimaxInitiativePenalty;
			_properties.Allure += ::Lewd.Const.ClimaxAllureBonus;
		}
	}

	function onTurnEnd()
	{
		local actor = this.getContainer().getActor();

		// Orgasm defeat: kill at end of their last turn
		if (actor.getFlags().has("lewdOrgasmDefeat"))
		{
			::logInfo("[climax] onTurnEnd killing " + actor.getName() + " via lewdOrgasmDefeat, OrgasmCount=" + actor.m.OrgasmCount);
			actor.getFlags().set("lewdPleasureDeath", true);
			local killer = null;
			if (actor.m.LastPleasureSourceID >= 0)
				killer = this.Tactical.getEntityByID(actor.m.LastPleasureSourceID);
			if (killer != null && !killer.isAlive())
				killer = null;
			actor.kill(killer, null, this.Const.FatalityType.None, true);
			return;
		}

		this.m.TurnsLeft -= 1;
		if (this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});
