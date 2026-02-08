::Lewd.Transform <- {
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