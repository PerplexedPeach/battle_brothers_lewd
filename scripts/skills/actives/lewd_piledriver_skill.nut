// Piledriver: Unhold boss grabs a target, carries them one tile, and penetrates.
// Combines fling_back's grab-and-carry with vaginal penetration mechanics.
// Only targets females with allure > 0 and PleasureMax > 0.
this.lewd_piledriver_skill <- this.inherit("scripts/skills/skill", {
	m = {
		BasePleasure = 18,
		MeleeSkillScale = 0.15,
		BaseHitChance = 60,
		SelfPleasure = 3
	},
	function create()
	{
		this.m.ID = "actives.lewd_piledriver";
		this.m.Name = "Piledriver";
		this.m.Description = "Grab a target and slam them into the ground, mounting and penetrating in one brutal motion.";
		this.m.Icon = "skills/active_110.png";
		this.m.IconDisabled = "skills/active_110.png";
		this.m.Overlay = "active_110";
		this.m.SoundOnUse = [
			"sounds/enemies/unhold_swipe_hit_01.wav",
			"sounds/enemies/unhold_swipe_hit_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingActorPitch = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().getActor().getCurrentProperties().IsRooted;
	}

	function isHidden()
	{
		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsOccupiedByActor)
			return false;

		local target = _targetTile.getEntity();
		if (target == null)
			return false;

		local user = this.getContainer().getActor();
		if (target.isAlliedWith(user))
			return false;

		// Only target females with pleasure capacity
		if (target.getGender() != 1)
			return false;

		if (target.getPleasureMax() <= 0)
			return false;

		// Target must not be immune to grab
		if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
			return false;

		// Need a tile behind the target to knock them to
		if (this.findKnockTile(_originTile, _targetTile) == null)
			return false;

		return true;
	}

	function findKnockTile( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);

		if (_targetTile.hasNextTile(dir))
		{
			local tile = _targetTile.getNextTile(dir);
			if (tile.IsEmpty && this.Math.abs(tile.Level - _targetTile.Level) <= 1)
				return tile;
		}

		// Try adjacent directions
		local altdir = dir - 1 >= 0 ? dir - 1 : 5;
		if (_targetTile.hasNextTile(altdir))
		{
			local tile = _targetTile.getNextTile(altdir);
			if (tile.IsEmpty && this.Math.abs(tile.Level - _targetTile.Level) <= 1)
				return tile;
		}

		altdir = dir + 1 <= 5 ? dir + 1 : 0;
		if (_targetTile.hasNextTile(altdir))
		{
			local tile = _targetTile.getNextTile(altdir);
			if (tile.IsEmpty && this.Math.abs(tile.Level - _targetTile.Level) <= 1)
				return tile;
		}

		return null;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		if (target == null) return false;

		local knockTile = this.findKnockTile(_user.getTile(), _targetTile);
		if (knockTile == null) return false;

		// Strip defensive stances
		local skills = target.getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");

		// Knock target back
		target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		local tag = {
			Skill = this,
			User = _user,
			Target = target,
			OldTargetTile = _targetTile
		};
		this.Tactical.getNavigator().teleport(target, knockTile, this.onTargetKnocked, tag, true);
		return true;
	}

	function onTargetKnocked( _entity, _tag )
	{
		// Move unhold to where target was standing
		local user = _tag.User;
		local targetOldTile = _tag.OldTargetTile;

		if (!user.isAlive() || !_entity.isAlive()) return;

		user.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		local tag2 = {
			Skill = _tag.Skill,
			User = user,
			Target = _entity
		};
		this.Tactical.getNavigator().teleport(user, targetOldTile, this.onUserArrived, tag2, false);
	}

	function onUserArrived( _entity, _tag )
	{
		local user = _tag.User;
		local target = _tag.Target;

		if (!user.isAlive() || !target.isAlive()) return;

		// Now roll for penetration hit
		local hitChance = this.calculateHitChance(user, target);
		local roll = this.Math.rand(1, 100);
		local hit = roll <= hitChance;

		if (hit)
		{
			// Apply mount
			this.applyMount(user, target);

			// Deal pleasure
			local pleasure = this.calculatePleasure(user, target);
			local actualPleasure = target.addPleasure(pleasure, user);

			// Self pleasure
			if (this.m.SelfPleasure > 0 && user.getPleasureMax() > 0)
				user.addPleasure(this.m.SelfPleasure);

			// Always apply horny
			if (!target.getSkills().hasSkill("effects.lewd_horny"))
			{
				local horny = this.new("scripts/skills/effects/lewd_horny_effect");
				target.getSkills().add(horny);
			}

			if (target.getTile().IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " slams " + this.Const.UI.getColorizedEntityName(target) + " into the ground and penetrates (+" + actualPleasure + " pleasure)");
			}
		}
		else
		{
			if (target.getTile().IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " slams " + this.Const.UI.getColorizedEntityName(target) + " but fails to penetrate");
			}
		}
	}

	function calculateHitChance( _user, _target )
	{
		local p = _user.getCurrentProperties();
		local tp = _target.getCurrentProperties();

		// Auto-hit horny targets
		if (_target.getSkills().hasSkill("effects.lewd_horny"))
			return 95;

		local chance = this.m.BaseHitChance + (p.getMeleeSkill() - tp.getMeleeDefense());
		return this.Math.max(20, this.Math.min(95, chance));
	}

	function calculatePleasure( _user, _target )
	{
		local p = _user.getCurrentProperties();
		local pleasure = this.m.BasePleasure + this.Math.floor(p.getMeleeSkill() * this.m.MeleeSkillScale);

		// Mounted bonus
		if (_target.getSkills().hasSkill("effects.lewd_mounted"))
			pleasure += 6;

		return this.Math.max(1, pleasure);
	}

	function applyMount( _user, _target )
	{
		if (!_target.getSkills().hasSkill("effects.lewd_mounted"))
		{
			local mounted = this.new("scripts/skills/effects/lewd_mounted_effect");
			_target.getSkills().add(mounted);
			mounted.addMounter(_user.getID());
			mounted.setTurns(::Lewd.Const.MountDuration);
		}
		else
		{
			local mounted = _target.getSkills().getSkillByID("effects.lewd_mounted");
			mounted.addMounter(_user.getID());
			mounted.setTurns(::Lewd.Const.MountDuration);
		}

		if (!_user.getSkills().hasSkill("effects.lewd_mounting"))
		{
			local mounting = this.new("scripts/skills/effects/lewd_mounting_effect");
			mounting.setTarget(_target.getID());
			_user.getSkills().add(mounting);
		}
		else
		{
			local mounting = _user.getSkills().getSkillByID("effects.lewd_mounting");
			mounting.setTarget(_target.getID());
		}
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
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
	}
});
