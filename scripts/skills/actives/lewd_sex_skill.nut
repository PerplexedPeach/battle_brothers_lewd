// Base class for all lewd sex abilities (hands, oral, feet, vaginal, anal)
// Children set m.MasteryID, m.PerkID, m.ScalingText, m.T3Debuff, m.Tiers in create()
this.lewd_sex_skill <- this.inherit("scripts/skills/skill", {
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
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/hexe_charm_kiss_01.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_02.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_03.wav",
			"sounds/enemies/dlc2/hexe_charm_kiss_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTierConfig()
	{
		return this.m.Tiers[this.getTier() - 1];
	}

	function getTier()
	{
		return ::Lewd.Mastery.getMasteryTier(this.getContainer().getActor(), this.m.MasteryID);
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
		return this.getTierConfig().Fatigue;
	}

	function getBaseHitChance()
	{
		return this.getTierConfig().BaseHitChance;
	}

	function getHitChanceAgainst( _target )
	{
		// Open Invitation: target with this effect is auto-hit by sex abilities
		if (_target.getSkills().hasSkill("effects.open_invitation"))
			return 100;

		local user = this.getContainer().getActor();
		local allure = user.allure();
		local resolve = _target.getBravery();
		local chance = this.getBaseHitChance() + (allure - resolve) * ::Lewd.Const.SexHitChanceAllureResolveScale;
		return this.Math.max(::Lewd.Const.SexHitChanceMin, this.Math.min(::Lewd.Const.SexHitChanceMax, chance));
	}

	function isHidden()
	{
		return !this.getContainer().getActor().getSkills().hasSkill(this.m.PerkID) || this.skill.isHidden();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
		local target = _targetTile.getEntity();
		if (target == null) return false;
		if (this.m.Container.getActor().isAlliedWith(target)) return false;
		if (target.getPleasureMax() <= 0) return false;
		return true;
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
		local result = [
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Deals pleasure to the target (scales with " + this.m.ScalingText + ")"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Hit chance scales with Allure vs target Resolve"
			}
		];
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

	// --- onUse for simple skills (hands, oral, feet) ---

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;

		this.playSound(_user);

		local hitResult = this.rollHit(_user, target);
		if (!hitResult.hit)
		{
			this.logMiss(_user, target, hitResult.chance, hitResult.roll);
			return true;
		}

		local pleasure = this.calculatePleasure(target);
		target.addPleasure(pleasure, _user);
		this.logHit(_user, target, pleasure, hitResult.chance, hitResult.roll);
		this.onHit(_user, target);
		return true;
	}

	// Post-hit hook — base applies T3 debuff + self-pleasure
	function onHit( _user, _target )
	{
		this.applyT3Debuff(_target);
		this.applySelfPleasure(_user, _target);
	}

	function applyT3Debuff( _target )
	{
		if (this.m.T3Debuff == null) return;
		if (this.getTier() < 3) return;
		if (_target.getSkills().hasSkill("effects.lewd_sex_debuff")) return;

		local debuff = this.new("scripts/skills/effects/lewd_sex_debuff_effect");
		debuff.setDebuffs(this.m.T3Debuff);
		_target.getSkills().add(debuff);
	}

	function applySelfPleasure( _user, _target = null )
	{
		local selfP = this.getSelfPleasure();
		if (selfP <= 0 || _user.getPleasureMax() <= 0)
			return;

		// Practiced Control: user receives less reflection
		if (_user.getSkills().hasSkill("perk.lewd_practiced_control"))
			selfP = this.Math.floor(selfP * ::Lewd.Const.PracticedControlReflectionMult);

		// Pliant Body: target's body gives more pleasure back to user
		if (_target != null && _target.getSkills().hasSkill("perk.lewd_pliant_body"))
			selfP = this.Math.floor(selfP * ::Lewd.Const.PliantBodyReflectionMult);

		if (selfP > 0)
			_user.addPleasure(selfP);
	}

	// --- Helpers ---

	function playSound( _user )
	{
		if (this.m.SoundOnUse.len() != 0)
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
	}

	function rollHit( _user, _target )
	{
		local chance = this.getHitChanceAgainst(_target);
		local roll = this.Math.rand(1, 100);
		return { chance = chance, roll = roll, hit = roll <= chance };
	}

	function logMiss( _user, _target, _chance, _roll )
	{
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + "'s " + this.getName() + " misses " + this.Const.UI.getColorizedEntityName(_target) + " (Chance: " + _chance + "%, Rolled: " + _roll + ")");
	}

	function logHit( _user, _target, _pleasure, _chance, _roll )
	{
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " on " + this.Const.UI.getColorizedEntityName(_target) + " for " + _pleasure + " pleasure (Chance: " + _chance + "%, Rolled: " + _roll + ")");
	}
});
