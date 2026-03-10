::Lewd.Transform <- {
	function target ( ) {
		local t = null;
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if(bro.getGender() == 1 && bro.getFlags().get("IsPlayerCharacter")){
				if (bro.getFlags().get("IsPlayerCharacter")) {
					t = bro;
					break;
				} else {
					candidates.push(bro);
				}
			}
		}

		// TODO handle when you are not playing as avatar, but for now only support avatar due to narrative perspective
		// prefer avatar/player character if possible, otherwise randomly select a woman
		// if (t == null && candidates.len() > 0)
		// {
		// 	t = candidates[_this.Math.rand(0, candidates.len() - 1)];
		// }

		// also would need to check for heelSkill

		return t;
	}

	function clearScarsAndTattoos ( _actor ) {
		_actor.getSprite("tattoo_body").setBrush("");
		_actor.getSprite("scar_body").setBrush("");
		_actor.getSprite("tattoo_head").setBrush("");
		_actor.getSprite("scar_head").setBrush("");
	}

	function adaptROTUAppearance ( _actor ) {
		if (::HasROTU)
		{
			_actor.getSprite("tattoo_body").setBrush("");
			_actor.getSprite("tattoo_body").Visible = true;
			_actor.getSprite("tattoo_body").Saturation = 1.0;

			if (_actor.hasSprite("permanent_injury_xx1"))
			{
				_actor.getSprite("permanent_injury_xx1").setBrush("zombie_rage_eyes");
				_actor.getSprite("permanent_injury_xx1").Visible = true;
				_actor.getSprite("permanent_injury_xx1").Color = this.createColor("#DB5079");
				_actor.getSprite("permanent_injury_xx1").Saturation = 0.5;
			}

			_actor.getSprite("tattoo_head").setBrush("");
			_actor.getSprite("tattoo_head").Visible = true;

			local xhead = _actor.getSprite("head");
			local xbody = _actor.getSprite("body");
			xhead.Color = this.createColor("#FAE9F0");
			xhead.Saturation = 0.8;
			xbody.Color = this.createColor("#FAE9F0");
			xbody.Saturation = 0.8;
		}
	}

	function sexy_stage_1 ( _woman ) {
		local w = _woman;
		// change sprite
		w.getSprite("head").setBrush("bust_head_lewd_01");
		w.getSprite("body").setBrush("bust_body_lewd_01");
		// clear scars and tattoos
		this.clearScarsAndTattoos(w);
		// clear bust so accessories are visible
		w.getSprite("miniboss").setBrush("");
		w.setDirty(true);
	}

	function sexy_stage_2 ( _woman ) {

		local w = _woman;
		// change sprite
		w.getSprite("head").setBrush("bust_head_lewd_02");
		w.getSprite("body").setBrush("bust_body_lewd_02");
		// clear scars and tattoos
		this.clearScarsAndTattoos(w);
		w.getSprite("miniboss").setBrush("");
		w.setDirty(true);
	}

	function sexy_stage_3 ( _woman ) {
		local w = _woman;
		// change sprite — lewd_05 set with matching skin tone
		w.getSprite("head").setBrush("bust_head_lewd_05");
		w.getSprite("hair").setBrush("hair_lewd_5");
		w.getSprite("beard").setBrush("");
		w.getSprite("body").setBrush("bust_body_lewd_05");
		// clear scars and tattoos
		this.clearScarsAndTattoos(w);
		w.getSprite("miniboss").setBrush("");
		w.setDirty(true);
	}

	// Grant the succubus tail weapon to an actor.
	// Adds +1 bag slot and places the tail in it, flagged as a natural weapon (can swap but not remove).
	function grantTail( _actor )
	{
		local items = _actor.getItems();

		local slots = items.getUnlockedBagSlots();
		items.setUnlockedBagSlots(slots + 1);

		local tail = this.new("scripts/items/weapons/tail_whip");
		tail.getFlags().set("naturalWeapon", true);

		items.addToBag(tail, slots);
	}
};