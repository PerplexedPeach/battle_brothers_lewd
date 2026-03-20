// Orc Claimed Effect -- debuff on targets marked by an orc's claim
// Steadily increases pleasure (orc musk), reduces stats, chance to become horny
// Removed when the claiming orc dies; cum sprites persist independently until combat end
this.orc_claimed_effect <- this.inherit("scripts/skills/skill", {
	m = {
		ClaimerID = -1
	},
	function create()
	{
		this.m.ID = "effects.orc_claimed";
		this.m.Name = "Claimed";
		this.m.Description = "Marked by an orc. Their overwhelming musk clouds your senses.";
		this.m.Icon = "skills/lewd_orc_claimed.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function setClaimerID( _id )
	{
		this.m.ClaimerID = _id;
	}

	function getClaimerID()
	{
		return this.m.ClaimerID;
	}

	function getTooltip()
	{
		local neg = this.Const.UI.Color.NegativeValue;
		local pct = this.Math.floor((::Lewd.Const.OrcClaimedReceivedPleasureMult - 1.0) * 100);
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
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + neg + "]+" + ::Lewd.Const.OrcClaimedPleasurePerTurn + "[/color] pleasure per turn"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + neg + "]" + ::Lewd.Const.OrcClaimedInitPenalty + "[/color] Initiative"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + neg + "]" + ::Lewd.Const.OrcClaimedMeleeSkillPenalty + "[/color] Melee Skill"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + neg + "]" + ::Lewd.Const.OrcClaimedMeleeDefPenalty + "[/color] Melee Defense"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + neg + "]" + ::Lewd.Const.OrcClaimedRangedDefPenalty + "[/color] Ranged Defense"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + neg + "]+" + pct + "%[/color] pleasure received"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + neg + "]" + ::Lewd.Const.OrcClaimedHornyChance + "%[/color] chance to become aroused each turn"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Other enemies are less likely to target you"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Initiative += ::Lewd.Const.OrcClaimedInitPenalty;
		_properties.MeleeSkill += ::Lewd.Const.OrcClaimedMeleeSkillPenalty;
		_properties.MeleeDefense += ::Lewd.Const.OrcClaimedMeleeDefPenalty;
		_properties.RangedDefense += ::Lewd.Const.OrcClaimedRangedDefPenalty;
		_properties.ReceivedPleasureMult *= ::Lewd.Const.OrcClaimedReceivedPleasureMult;
		// Reduce AI targeting priority -- claimed targets are "spoken for"
		_properties.TargetAttractionMult *= ::Lewd.Const.OrcClaimedTargetAttractionMult;
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isAlive()) return;

		// Validate claimer is still alive
		local claimer = this.Tactical.getEntityByID(this.m.ClaimerID);
		if (claimer == null || !claimer.isAlive())
		{
			::logInfo("[orc_claimed] " + actor.getName() + " claim released -- claimer dead");
			this.removeSelf();
			return;
		}

		// Distance check: claim expires if claimer is too far away
		if (actor.isPlacedOnMap() && claimer.isPlacedOnMap())
		{
			local dist = actor.getTile().getDistanceTo(claimer.getTile());
			if (dist > ::Lewd.Const.OrcClaimMaxDistance)
			{
				::logInfo("[orc_claimed] " + actor.getName() + " claim released -- " + claimer.getName() + " too far (" + dist + " > " + ::Lewd.Const.OrcClaimMaxDistance + ")");
				this.removeSelf();
				return;
			}
		}

		// Orc musk: passive pleasure per turn
		actor.addPleasure(::Lewd.Const.OrcClaimedPleasurePerTurn, claimer);
		::logInfo("[orc_claimed] " + actor.getName() + " receives " + ::Lewd.Const.OrcClaimedPleasurePerTurn + " musk pleasure from " + claimer.getName());

		// Chance to become horny
		if (!actor.getSkills().hasSkill("effects.lewd_horny"))
		{
			local roll = this.Math.rand(1, 100);
			if (roll <= ::Lewd.Const.OrcClaimedHornyChance)
			{
				::logInfo("[orc_claimed] " + actor.getName() + " becomes horny from orc musk (roll:" + roll + " <= " + ::Lewd.Const.OrcClaimedHornyChance + ")");
				actor.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));
			}
		}
	}

	function onDeath( _fatalityType )
	{
		// Claimed target died -- free the claiming orc
		this.clearClaimerFlag();
	}

	function onRemoved()
	{
		this.clearClaimerFlag();
	}

	function clearClaimerFlag()
	{
		if (this.m.ClaimerID < 0) return;

		local claimer = this.Tactical.getEntityByID(this.m.ClaimerID);
		if (claimer != null && claimer.isAlive() && claimer.getFlags().has("lewdOrcClaimTarget"))
		{
			local claimedID = claimer.getFlags().getAsInt("lewdOrcClaimTarget");
			local actor = this.getContainer().getActor();
			// Only clear if the claimer's flag points to us
			if (claimedID == actor.getID())
			{
				::logInfo("[orc_claimed] clearing claim flag on " + claimer.getName() + " (target: " + actor.getName() + ")");
				claimer.getFlags().set("lewdOrcClaimTarget", -1);
				claimer.getSkills().removeByID("effects.orc_claiming");
			}
		}
	}
});
