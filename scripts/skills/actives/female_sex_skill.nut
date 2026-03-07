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
		if (this.getContainer().getActor().getSkills().hasSkill("perk.lewd_practiced_control"))
			cost = this.Math.ceil(cost * ::Lewd.Const.PracticedControlFatigueMult);
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
		local result = this.sex_skill_base.getTooltip();
		result.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Deals pleasure to the target (scales with " + this.m.ScalingText + ")"
		});
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Hit chance scales with Allure vs target Resolve"
		});
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

		// Sensual Focus perk
		if (user.getSkills().hasSkill("perk.lewd_sensual_focus"))
		{
			pleasure = this.Math.floor(pleasure * ::Lewd.Const.SensualFocusPleasureMult);
			// Open Invitation: additional +15% pleasure when active
			if (user.getSkills().hasSkill("effects.open_invitation"))
				pleasure = this.Math.floor(pleasure * ::Lewd.Const.SensualFocusOpenInvitationMult);
		}

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
	function onHit( _user, _target )
	{
		this.applyT3Debuff(_target);
		this.applySelfPleasure(_user, _target);
		this.tryApplyHorny(_target);
	}

	function applyT3Debuff( _target )
	{
		// Disabled — Distracted debuff no longer applied by sex abilities
	}

	function applySelfPleasure( _user, _target = null )
	{
		local selfP = this.getSelfPleasure();
		if (selfP <= 0 || _user.getPleasureMax() <= 0)
			return;

		// Practiced Control: user receives less reflection
		if (_user.getSkills().hasSkill("perk.lewd_practiced_control"))
			selfP = this.Math.floor(selfP * ::Lewd.Const.PracticedControlReflectionMult);

		if (selfP > 0)
			_user.addPleasure(selfP);
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
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " " + verb + " " + this.Const.UI.getColorizedEntityName(_target) + " for " + _pleasure + " pleasure" + selfStr + " (roll:" + _hitResult.roll + " chance:" + _hitResult.chance + ")");
	}
});
