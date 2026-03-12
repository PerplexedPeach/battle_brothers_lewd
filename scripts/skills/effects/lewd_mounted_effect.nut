// Applied to the TARGET being mounted (the one underneath)
this.lewd_mounted_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 0,
		MounterIDs = [],
		IsRemoving = false
	},
	function create()
	{
		this.m.ID = "effects.lewd_mounted";
		this.m.Name = "Mounted";
		this.m.Description = "Someone is on top of you, restricting your movement and making you vulnerable.";
		this.m.Icon = "skills/lewd_mounted.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getMounterID()
	{
		if (this.m.MounterIDs.len() > 0)
			return this.m.MounterIDs[0];
		return 0;
	}

	function getMounterCount()
	{
		return this.m.MounterIDs.len();
	}

	function hasMounter( _entityID )
	{
		foreach (id in this.m.MounterIDs)
			if (id == _entityID) return true;
		return false;
	}

	function addMounter( _entityID )
	{
		foreach (id in this.m.MounterIDs)
			if (id == _entityID) return;
		this.m.MounterIDs.push(_entityID);
		this.updateSilhouettes();
	}

	function removeMounter( _entityID )
	{
		if (this.m.IsRemoving) return;
		for (local i = this.m.MounterIDs.len() - 1; i >= 0; i--)
		{
			if (this.m.MounterIDs[i] == _entityID)
			{
				this.m.MounterIDs.remove(i);
				break;
			}
		}
		this.updateSilhouettes();
		if (this.m.MounterIDs.len() == 0)
			this.removeSelf();
	}

	function updateSilhouettes()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return;

		local count = this.m.MounterIDs.len();
		if (actor.hasSprite("lewd_silhouette_back"))
		{
			actor.getSprite("lewd_silhouette_back").setBrush("lewd_silhouette_back");
			actor.getSprite("lewd_silhouette_back").Visible = count >= 1;
		}
		if (actor.hasSprite("lewd_silhouette_front"))
		{
			actor.getSprite("lewd_silhouette_front").setBrush("lewd_silhouette_front");
			actor.getSprite("lewd_silhouette_front").Visible = count >= 2;
		}
		actor.setDirty(true);
	}

	function setTurns( _turns )
	{
		this.m.TurnsLeft = _turns;
	}

	function getTooltip()
	{
		local count = this.m.MounterIDs.len();
		local desc = count > 1
			? "Multiple enemies are on top of you, restricting your movement and making you extremely vulnerable."
			: this.getDescription();
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = desc
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.MountMeleeDefPenalty + "[/color] Melee Defense"
			},
			{
				id = 18,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.MountMeleeSkillPenalty + "[/color] Melee Skill"
			},
			{
				id = 19,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.MountRangedSkillPenalty + "[/color] Ranged Skill"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] Initiative"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/pleasure.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]10%[/color] more pleasure received"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Cannot move (rooted)"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "Enemy sex abilities have [color=" + this.Const.UI.Color.NegativeValue + "]+" + ::Lewd.Const.MaleSexMountedHitBonus + "%[/color] chance to hit"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Turns remaining: [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color]"
			}
		];

		result.push({
			id = 20,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Dealing [color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.MountingDamageBreakThreshold + "[/color] or more hitpoint damage to a mounter will break their mount"
		});

		if (count > 1)
		{
			result.push({
				id = 15,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Mounted by [color=" + this.Const.UI.Color.NegativeValue + "]" + count + "[/color] enemies"
			});
		}

		// Pliant Body: horny lock indicator
		local actor = this.getContainer().getActor();
		if (actor.getSkills().hasSkill("perk.lewd_pliant_body"))
		{
			result.push({
				id = 21,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Mounters cannot lose [color=" + this.Const.UI.Color.PositiveValue + "]Horny[/color] status (Pliant Body)"
			});
		}

		// Sub-gated defensive bonuses
		local subScore = ::Lewd.Mastery.getSubScore(actor);
		if (subScore > 0)
		{
			local resolveBonus = this.Math.floor(subScore * ::Lewd.Const.MountedSubResolveScale);
			local rangedDefBonus = this.Math.floor(subScore * ::Lewd.Const.MountedSubRangedDefScale);
			if (resolveBonus > 0)
			{
				result.push({
					id = 16,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + resolveBonus + "[/color] Resolve (from submission)"
				});
			}
			if (rangedDefBonus > 0)
			{
				result.push({
					id = 17,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + rangedDefBonus + "[/color] Ranged Defense (from submission)"
				});
			}
		}

		return result;
	}

	function onAdded()
	{
		this.m.TurnsLeft = ::Lewd.Const.MountDuration;
		local actor = this.getContainer().getActor();

		// Swap icon for male actors — show female-on-top perspective
		if (actor.getGender() != 1)
		{
			this.m.Icon = "skills/lewd_mounting.png";
		}

		if (actor.isPlacedOnMap())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " is mounted!");
		}

		// Note: silhouettes are updated by addMounter() which is called after add()
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense += ::Lewd.Const.MountMeleeDefPenalty;
		_properties.MeleeSkill += ::Lewd.Const.MountMeleeSkillPenalty;
		_properties.RangedSkill += ::Lewd.Const.MountRangedSkillPenalty;
		_properties.InitiativeMult *= ::Lewd.Const.MountInitiativeMult;
		_properties.IsRooted = true;

		// Sub-gated defensive bonuses while mounted
		local actor = this.getContainer().getActor();
		local subScore = ::Lewd.Mastery.getSubScore(actor);
		if (subScore > 0)
		{
			_properties.RangedDefense += this.Math.floor(subScore * ::Lewd.Const.MountedSubRangedDefScale);
			_properties.Bravery += this.Math.floor(subScore * ::Lewd.Const.MountedSubResolveScale);
		}
	}

	function onTurnEnd()
	{
		this.m.TurnsLeft -= 1;

		if (this.m.MounterIDs.len() == 0 || this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
		else
		{
			// Pliant Body: drain fatigue from all mounters each turn
			local actor = this.getContainer().getActor();
			if (actor.getSkills().hasSkill("perk.lewd_pliant_body"))
			{
				foreach (mounterID in this.m.MounterIDs)
				{
					local mounter = this.Tactical.getEntityByID(mounterID);
					if (mounter != null && mounter.isAlive())
						mounter.m.Fatigue = this.Math.min(mounter.getFatigueMax(), mounter.m.Fatigue + ::Lewd.Const.PliantBodyFatigueDrain);
				}
			}
		}
	}

	function onDeath( _fatalityType )
	{
		// Mounted target died — remove mounting effect from all mounters
		foreach (mounterID in this.m.MounterIDs)
		{
			local mounter = this.Tactical.getEntityByID(mounterID);
			if (mounter != null && mounter.isAlive())
			{
				mounter.getSkills().removeByID("effects.lewd_mounting");
			}
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("lewd_silhouette_back"))
		{
			actor.getSprite("lewd_silhouette_back").Visible = false;
		}
		if (actor.hasSprite("lewd_silhouette_front"))
		{
			actor.getSprite("lewd_silhouette_front").Visible = false;
		}
		actor.setDirty(true);
	}

	function removeSelf()
	{
		if (this.m.IsRemoving) return;
		this.m.IsRemoving = true;

		local actor = this.getContainer().getActor();

		// Remove the mounting effect from all mounters
		foreach (mounterID in this.m.MounterIDs)
		{
			local mounter = this.Tactical.getEntityByID(mounterID);
			if (mounter != null && mounter.isAlive())
			{
				mounter.getSkills().removeByID("effects.lewd_mounting");
			}
		}

		if (actor.isPlacedOnMap())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " is no longer mounted.");
		}

		this.skill.removeSelf();
	}
});
