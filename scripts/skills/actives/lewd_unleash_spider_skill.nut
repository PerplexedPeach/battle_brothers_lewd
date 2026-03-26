// Unleash Spider Companion -- spawns a player-allied spider on an adjacent tile.
// Used by spider pet accessory items. Entity script is configurable via setEntityScript().
this.lewd_unleash_spider_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Entity = null,
		EntityName = "Spider",
		Script = "scripts/entity/tactical/lewd_spider_companion",
		Item = null
	},
	function create()
	{
		this.m.ID = "actives.lewd_unleash_spider";
		this.m.Name = "Unleash Spider";
		this.m.Description = "Release your spider companion onto the battlefield.";
		this.m.Icon = "skills/active_110.png";
		this.m.IconDisabled = "skills/active_110_bw.png";
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/spider_idle_0.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsStacking = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function setItem( _item )
	{
		this.m.Item = _item;
	}

	function setEntityScript( _script )
	{
		this.m.Script = _script;
	}

	function setEntityName( _name )
	{
		this.m.EntityName = _name;
	}

	function isUsable()
	{
		if (this.m.Entity != null)
			return false;
		return this.skill.isUsable();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		local entity = this.Tactical.spawnEntity(this.m.Script, _targetTile.Coords.X, _targetTile.Coords.Y);
		entity.setFaction(this.Const.Faction.PlayerAnimals);
		entity.setName(this.m.EntityName);
		entity.setMoraleState(this.Const.MoraleState.Confident);
		this.m.Entity = entity;
		return true;
	}

	function onCombatFinished()
	{
		this.m.Entity = null;
	}
});
