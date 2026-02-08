# TODOS
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