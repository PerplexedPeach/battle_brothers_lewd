::Lewd.Allure <- {
	function penaltyFromHead( _actor )
	{

		local head = _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		if (head != null)
		{
			return -head.getStaminaModifier() * ::Lewd.Const.AllurePenaltyHeadFatigue;
		}

		return 0;
	}

	function penaltyFromBody( _actor )
	{
		local body = _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		if (body != null)
		{
			return -body.getStaminaModifier() * ::Lewd.Const.AllurePenaltyBodyFatigue;
		}

		return 0;
	}

	function penaltyFromOffhand( _actor )
	{
		local offhand = _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		if (offhand != null)
		{
			return -offhand.getStaminaModifier() * ::Lewd.Const.AllurePenaltyOffhandFatigue;
		}

		return 0;
	}
};