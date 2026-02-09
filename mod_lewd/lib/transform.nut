::Lewd.Transform <- {
	function target ( _this ) {
		local t = null;
		local brothers = _this.World.getPlayerRoster().getAll();
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


	function sexy_stage_1 ( _woman ) {
		local w = _woman;
		// change sprite
		w.getSprite("head").setBrush("bust_head_lewd_01");
		w.getSprite("body").setBrush("bust_body_lewd_01");
		// clear scars and tattoos
		w.getSprite("tattoo_body").setBrush("");
		// clear bust so accessories are visible
		w.getSprite("miniboss").setBrush("");
	}

	function sexy_stage_2 ( _woman ) {

		local w = _woman;
		// change sprite
		w.getSprite("head").setBrush("bust_head_lewd_02");
		w.getSprite("body").setBrush("bust_body_lewd_02");
		// clear scars and tattoos
		w.getSprite("tattoo_body").setBrush("");
		// clear bust so accessories are visible
		w.getSprite("miniboss").setBrush("");
	}
};