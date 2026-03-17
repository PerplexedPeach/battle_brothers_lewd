// Base class for all female sex abilities (hands, oral, feet, vaginal, anal)
// Children set m.MasteryID, m.PerkID, m.ScalingText, m.T3Debuff, m.Tiers in create()
this.female_sex_skill <- this.inherit("scripts/skills/actives/sex_skill_base", {
	m = {
		MasteryID = "",
		PerkID = "",
		ScalingText = "",
		T3Debuff = null,       // e.g. { Init = -5, Duration = 1 } or null
		CurrentTier = 0,
		Tiers = []             // array of 3 tier config tables
	},
	function create()
	{
		this.sex_skill_base.create();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.sex_skill_base.onVerifyTarget(_originTile, _targetTile)) return false;
		if (_targetTile.getEntity().getGender() == 1) return false;
		return true;
	}

	function getTierConfig()
	{
		return this.m.Tiers[this.getTier() - 1];
	}

	function getTier()
	{
		return this.Math.max(1, ::Lewd.Mastery.getMasteryTier(this.getContainer().getActor(), this.m.MasteryID));
	}

	function getMasteryPoints()
	{
		return ::Lewd.Mastery.getMasteryPoints(this.getContainer().getActor(), this.m.MasteryID);
	}

	function getName()
	{
		return this.getTierConfig().Name;
	}

	function getDescription()
	{
		return this.getTierConfig().Description;
	}

	function getAPCost()
	{
		return this.getTierConfig().AP;
	}

	function getFatigueCost()
	{
		local cost = this.getTierConfig().Fatigue;
		local actor = this.getContainer().getActor();
		cost = this.Math.ceil(cost * actor.getCurrentProperties().SexFatigueMult);
		return cost;
	}

	function getBaseHitChance()
	{
		return this.getTierConfig().BaseHitChance;
	}

	function getHitchance( _targetEntity )
	{
		if (!_targetEntity.isAttackable()) return 0;
		return this.getHitChanceAgainst(_targetEntity);
	}

	function getHitFactors( _targetTile )
	{
		local ret = [];
		local target = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
		if (target == null) return ret;

		local user = this.getContainer().getActor();
		local allure = user.allure();
		local resolve = target.getBravery();
		local diff = allure - resolve;

		ret.push({
			icon = "ui/icons/special.png",
			text = "Your Allure: [color=" + this.Const.UI.Color.PositiveValue + "]" + allure + "[/color]"
		});
		ret.push({
			icon = "ui/icons/bravery.png",
			text = "Target Resolve: [color=" + this.Const.UI.Color.NegativeValue + "]" + resolve + "[/color]"
		});

		if (diff >= 0)
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (diff * ::Lewd.Const.SexHitChanceAllureResolveScale) + "%[/color] from Allure advantage"
			});
		else
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + (diff * ::Lewd.Const.SexHitChanceAllureResolveScale) + "%[/color] from Resolve advantage"
			});

		if (user.getSkills().hasSkill("perk.lewd_alluring_presence") && user.getFlags().getAsInt("lewdAlluringUsed") == 0)
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.AlluringPresenceHitBonus + "%[/color] from Alluring Presence (first use)"
			});

		if (this.isAutoHit(target))
			ret.push({
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]Auto-hit[/color] (target is horny/open)"
			});

		return ret;
	}

	function getHitChanceAgainst( _target )
	{
		if (this.isAutoHit(_target)) return 100;

		local user = this.getContainer().getActor();
		local allure = user.allure();
		local resolve = _target.getBravery();
		local chance = this.getBaseHitChance() + (allure - resolve) * ::Lewd.Const.SexHitChanceAllureResolveScale;

		// Alluring Presence: +15% hit on first sex ability use per turn
		if (user.getSkills().hasSkill("perk.lewd_alluring_presence") && user.getFlags().getAsInt("lewdAlluringUsed") == 0)
			chance += ::Lewd.Const.AlluringPresenceHitBonus;

		return this.Math.max(::Lewd.Const.SexHitChanceMin, this.Math.min(::Lewd.Const.SexHitChanceMax, chance));
	}

	function isHidden()
	{
		return !this.getContainer().getActor().getSkills().hasSkill(this.m.PerkID) || this.skill.isHidden();
	}

	function onAfterUpdate( _properties )
	{
		this.m.ActionPointCost = this.getAPCost();
		this.m.FatigueCost = this.getFatigueCost();

		// dynamic tier icons
		local tier = this.getTier();
		if (tier != this.m.CurrentTier)
		{
			this.m.CurrentTier = tier;
			local cfg = this.getTierConfig();
			this.m.Icon = cfg.Icon;
			this.m.IconDisabled = cfg.IconDisabled;
			this.m.Overlay = cfg.Overlay;
		}
	}

	function getTooltip()
	{
		local pos = this.Const.UI.Color.PositiveValue;
		local neg = this.Const.UI.Color.NegativeValue;
		local result = this.sex_skill_base.getTooltip();

		// Pleasure info
		result.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Deals [color=" + pos + "]pleasure[/color] to the target (scales with " + this.m.ScalingText + ")"
		});

		// Hit chance
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Hit chance: [color=" + pos + "]" + this.getBaseHitChance() + "%[/color] base, modified by Allure vs target Resolve"
		});

		// Self-pleasure
		local selfP = this.getSelfPleasure();
		if (selfP > 0)
		{
			result.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Inflicts [color=" + neg + "]" + selfP + "[/color] pleasure on yourself"
			});
		}

		// Mount bonus
		local cfg = this.getTierConfig();
		if (cfg.MountBonus > 0)
		{
			result.push({
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + pos + "]+" + cfg.MountBonus + "[/color] bonus pleasure if target is mounted"
			});
		}

		// Horny chance
		result.push({
			id = 9,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + pos + "]" + ::Lewd.Const.HornyApplyChance + "%[/color] chance to inflict Horny on hit"
		});

		// Auto-hit conditions
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + pos + "]Auto-hit[/color] against Horny or Open Invitation targets"
		});

		// Mount AP discount indicator
		local actor = this.getContainer().getActor();
		local hasMountDiscount = (this.m.ID == "actives.lewd_vaginal" && actor.getSkills().hasSkill("effects.lewd_mounting"))
			|| (this.m.ID == "actives.lewd_anal" && actor.getSkills().hasSkill("effects.lewd_mounted"));
		if (hasMountDiscount)
		{
			result.push({
				id = 11,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + pos + "]-" + ::Lewd.Const.MountedAPDiscount + " AP[/color] (already mounted)"
			});
		}

		return result;
	}

	// --- Pleasure calculation ---

	function calculatePleasure( _target )
	{
		local user = this.getContainer().getActor();
		local cfg = this.getTierConfig();
		local pleasure = cfg.BasePleasure;
		pleasure += this.Math.floor(user.allure() * ::Lewd.Const.SexAllurePleasureScale);
		pleasure += this.calculateStatPleasure(_target);
		pleasure += this.calculateMasteryPleasureBonus();

		// mount bonus from tier config
		if (cfg.MountBonus > 0 && _target.getSkills().hasSkill("effects.lewd_mounted"))
			pleasure += cfg.MountBonus;

		// fatigue vulnerability
		pleasure += ::Lewd.Mastery.calcFatigueVulnerability(_target);

		// DealtPleasureMult (Sensual Focus, Open Invitation, etc.)
		pleasure = this.Math.floor(pleasure * user.getCurrentProperties().DealtPleasureMult);

		return this.Math.max(1, pleasure);
	}

	// Virtual — each child overrides
	function calculateStatPleasure( _target )
	{
		return 0;
	}

	// Virtual — each child overrides
	function calculateMasteryPleasureBonus()
	{
		return 0;
	}

	// Virtual — oral/vaginal/anal override
	function getSelfPleasure()
	{
		return 0;
	}

	// Post-hit hook — applies T3 debuff + self-pleasure + horny
	// Returns actual self-pleasure applied (for logging)
	function onHit( _user, _target )
	{
		this.applyT3Debuff(_target);
		local selfP = this.applySelfPleasure(_user, _target);
		this.tryApplyHorny(_target);
		return selfP;
	}

	function applyT3Debuff( _target )
	{
		// Disabled — Distracted debuff no longer applied by sex abilities
	}

	function applySelfPleasure( _user, _target = null )
	{
		local selfP = this.getSelfPleasure();
		if (selfP <= 0 || _user.getPleasureMax() <= 0)
			return 0;

		// SelfPleasureMult: user-side modifier (Practiced Control, etc.)
		selfP = this.Math.floor(selfP * _user.getCurrentProperties().SelfPleasureMult);

		// Target's PleasureReflectionMult (Pliant Body, Overwhelming Presence, etc.)
		if (_target != null)
			selfP = this.Math.floor(selfP * _target.getCurrentProperties().PleasureReflectionMult);

		if (selfP > 0)
			return _user.addPleasure(selfP, _target);
		return 0;
	}

	// --- Log overrides (read from tier config instead of m.HitText/m.MissText) ---

	function logMiss( _user, _target, _hitResult )
	{
		local cfg = this.getTierConfig();
		local verb = cfg.MissText[this.Math.rand(0, cfg.MissText.len() - 1)];
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " tries to " + verb + " " + this.Const.UI.getColorizedEntityName(_target) + " but fails (roll:" + _hitResult.roll + " chance:" + _hitResult.chance + ")");
	}

	function logHit( _user, _target, _pleasure, _hitResult, _selfPleasure = 0 )
	{
		local cfg = this.getTierConfig();
		local verb = cfg.HitText[this.Math.rand(0, cfg.HitText.len() - 1)];
		local selfStr = _selfPleasure > 0 ? " (self: " + _selfPleasure + ")" : "";
		::logInfo("[sex]   logHit: " + _user.getName() + " -> " + _target.getName() + " pleasure:" + _pleasure + " self:" + _selfPleasure);
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " " + verb + " " + this.Const.UI.getColorizedEntityName(_target) + " for " + _pleasure + " pleasure" + selfStr + " (roll:" + _hitResult.roll + " chance:" + _hitResult.chance + ")");
	}
});
