# TODOS
- create random events
	- based on allure
	- based on seduce ability used in battle
	- create graph with sub/dom sex events with bros
		- body modification and piercings could actually be tied into being too submissive to one of your bros
- monster taming - if you use the seduce ability on them then at the end of the battle you'll get an event popup related to that for taming them
- increase barter skill based on allure (doesn't seem to work for some reason)
- make enemies horny (similar to the daze/stun effect, larger range)
	- set AI agent on horny
- body modification corruption series (separate boobs and ass traits)
- sexy armor
- sub/dom relation with bros
- sadism
- create sprites for the corruption event characters
- custom starting scenarios
- animation fading in/out backside showing ass when molested/targeted by specific abilities

# Useful to User Code Snippets
Get `mod_dev_console` [https://www.nexusmods.com/battlebrothers/mods/380](mod), drop it in `Battle Brothers\data` and you can press `Ctrl + G` to bring up the console in game.

Trigger first event
```js
local eventName = "event.lewd_heels_first";
this.World.Events.fire(eventName);
```

Trigger heel skillup event
```js
local eventName = "event.lewd_heels_skillup";
this.World.Events.fire(eventName);
```

Trigger second heel event (need heel skill >= 1)
```js
local eventName = "event.lewd_heels_second";
this.World.Events.fire(eventName);
```

Trigger third heel event (need heel skill >= 3)
```js
local eventName = "event.lewd_heels_third";
this.World.Events.fire(eventName);
```

Remove cursed heels
```js
// remove heels (should work for cursed as well)
local w = ::Lewd.Transform.target();
local items = w.getItems();
local previousHeels = items.getItemAtSlot(this.Const.ItemSlot.Accessory);
if (previousHeels)
{
	previousHeels.getFlags().remove("cursed");
	previousHeels.removeSelf();
}
```

Remove equipped item (not deleted)
```js
		if (oldWeapon != null)
		{
			_entity.getItems().unequip(oldWeapon);
		}
```

Remove delicate trait (use "trait.dainty" for dainty)
```js
local w = ::Lewd.Transform.target();
local skills = w.getSkills();
skills.removeByID("trait.delicate");
```

Check and print event score (0 means it won't ever fire, hire number = more weight to fire compared to other events)
```js
local eventName = "event.lewd_heels_skillup";
local e = ::World.Events.getEvent(eventName);
e.onUpdateScore()
::logInfo(e.getID() + " score = " + e.m.Score)
```


# Snipets
Swap world party graphic (or is this actually player in battle)
```js
		this.World.State.m.Player.getSprite("body").setBrush("figure_vampire_01"); // World map look, could be 02.
```

Change buying/selling prices
```js
		this.World.Assets.m.BuyPriceMult = 1.3; //+30%
		this.World.Assets.m.SellPriceMult = 0.7; //-30%
```

Filtering one liner
```js
		local candidates_gunner = ::World.getPlayerRoster().getAll().filter(@(_idx, _bro) _bro.getMainhandItem() != null && ::Legends.S.oneOf(_bro.getMainhandItem(), "weapon.handgonne", "weapon.named_handgonne"));
```

Check avatar
```js
bro.getFlags().has("IsPlayerCharacter")
```

Gender (female == 1, male == 0/else)
```js
bro.getGender()
bro.setGender(1)
```

Voice related
```js
				this.m.VoiceSet = this.Math.rand(0, this.Const.WomanSounds.len() - 1);
				this.m.Body = this.Math.rand(0, this.m.Bodies.len() - 1);
			

			this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = this.Const.WomanSounds[this.m.VoiceSet].NoDamageReceived;
			this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = this.Const.WomanSounds[this.m.VoiceSet].DamageReceived;
			this.m.Sound[this.Const.Sound.ActorEvent.Death] = this.Const.WomanSounds[this.m.VoiceSet].Death;
			this.m.Sound[this.Const.Sound.ActorEvent.Flee] = this.Const.WomanSounds[this.m.VoiceSet].Flee;
			this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = this.Const.WomanSounds[this.m.VoiceSet].Fatigue;
			this.m.SoundPitch = this.Math.rand(105, 115) * 0.01;
```

Skill on equipment
```js
	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}
```

Adding skills
```js
				local w = ::Lewd.Transform.target();
				local skills = w.getSkills();
				{
					local skill = this.new("scripts/skills/traits/dainty_trait");
					skills.add(skill);
					this.List.push({
						id = 11,
						icon = skill.getIcon(),
						text = w.getName() + " is now " + skill.getName()
					});
				}
```

On movement athletic (athletic_trait)
```js
	o.m.HasMoved <- false;

	o.onUpdate = function ( _properties )
	{
		local actor = this.getContainer().getActor();				
		if (this.m.HasMoved == false && this.getContainer().getActor().m.IsMoving)
		{
			this.m.HasMoved = true;
			local myTile = actor.getTile();			
			actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + this.Math.max(0, actor.getActionPointCosts()[myTile.Type] * _properties.MovementAPCostMult)));
			actor.setFatigue(this.Math.max(0, actor.getFatigue() - this.Math.max(0, actor.getFatigueCosts()[myTile.Type] * _properties.MovementFatigueCostMult)));			
		}		
	
	}
```

Movement costs hook `actor.onMovementStep` introduce actor.heelHeight and heelSkill. If height > skill the addition is added to fatigue cost per tile.

Look at cursed crystal skull for reducing resolve in melee, also add onMovementStep for skill that gets added by the item onEquip
see legends
```js
	o.onEquip = function ()
	{
		onEquip();
		::Legends.Actives.grant(this, ::Legends.Active.LegendBucklerBash, function (_skill) {
			this.m.PrimaryOffhandAttack = ::MSU.asWeakTableRef(_skill);
		}.bindenv(this));
		::Legends.Effects.grant(this, ::Legends.Effect.LegendBuckler, function(_effect) {
			_effect.m.Order = this.Const.SkillOrder.UtilityTargeted + 1;
			_effect.setItem(this);
			this.m.SkillPtrs.push(_effect);
		}.bindenv(this));
	}
```

Look at effects.distracted

Use the tactical log

				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " shook off being dazed thanks to his unnatural physiology");

Hexen transformation fadein
```js
			sprite = this.getSprite("charm_body");
			sprite.Visible = true;
			sprite.fadeIn(t);
```

Movement sound (actor.onMovementFinish) but can add this to the accessories themselves
```js
			if (this.m.IsEmittingMovementSounds && this.Const.Tactical.TerrainMovementSound[_tile.Subtype].len() != 0)
			{
				local sound = this.Const.Tactical.TerrainMovementSound[_tile.Subtype][this.Math.rand(0, this.Const.Tactical.TerrainMovementSound[_tile.Subtype].len() - 1)];
				this.Sound.play("sounds/" + sound.File, sound.Volume * this.Const.Sound.Volume.TacticalMovement * this.Math.rand(90, 100) * 0.01, this.getPos(), sound.Pitch * this.Math.rand(95, 105) * 0.01);
			}
```

Setting related to tracking who was responsible for setting a status effect that led to death
```js
addNCSetting(config, ::MSU.Class.BooleanSetting("BleedKiller", true, "Effects Count As Kills", "If enabled, kills by bleeding out, poisoned to death or consecrated are granted to the actor who caused the relevant effect."));
```

Modern way of using settings to change constants via callback
```js
::ModFindLegendaryMaps <- {
    ID = "mod_find_legendary_maps",
    Name = "Find Legendary Location Maps",
    Version = "0.5.2",
    OnlySpawned = true,
    BlackMarket = false,
    // other mods compat
    hasLegends = false,
    hasSSU = false,
    hasStronghold = false,
}

...
// in queue
    local page = ::ModFindLegendaryMaps.Mod.ModSettings.addPage("General");
    local settingOnlySpawned = page.addBooleanSetting(
        "EnableSpawning",
        false,
        "[EXPERIMENTAL] Attempt to spawn",
        "Blah blah blah."
    );

    settingOnlySpawned.addCallback(function(_value) { ::ModFindLegendaryMaps.OnlySpawned = _value; });
```


Event battle

What is determined start? (kraken_cult_destroyed_event)
```js
	function onDetermineStartScreen()
	{
		return "A";
	}
```

See legend_swordmaster_fav_enemy_event, wildman_causes_havoc_event for generated enemies
```js
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.BarbarianTracks;
						properties.Entities = [];
						properties.Entities.push({
							ID = this.Const.EntityType.BarbarianChampion,
							Variant = 1,
							Row = 0,
							Name = name,
							Script = "scripts/entity/tactical/humans/barbarian_champion",
							Faction = this.Const.Faction.Enemy,
							function Callback( _entity, _tag )
							{
								_entity.setName(name);
							}

						});

						if (_event.m.Champion.isInReserves())
						{
							_event.m.WasInReserves.push(_event.m.Champion);
							_event.m.Champion.setInReserves(false);

						}

						properties.Players.push(_event.m.Champion);
						properties.IsUsingSetPlayers = true;
						properties.IsFleeingProhibited = true;
						properties.IsAttackingLocation = true;
						properties.BeforeDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();

							for( local x = 0; x < size.X; x = x )
							{
								for( local y = 0; y < size.Y; y = y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									tile.Level = this.Math.min(1, tile.Level);
									y = ++y;
								}

								x = ++x;
							}
						};
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(properties, false, false, false);
```

See NPC protection quest legend_hunting_coven_leader_contract

Use spawnlist to generate a list