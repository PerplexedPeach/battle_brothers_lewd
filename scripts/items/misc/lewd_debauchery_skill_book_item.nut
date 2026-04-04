this.lewd_debauchery_skill_book_item <- ::inherit("scripts/items/misc/legend_skill_book", {
	m = {
		PerkGroups = [::Const.Perks.DebaucheryTree],
		Cooldown = 50,
		BookName = "Manual of"
	},
	function create()
	{
		this.legend_skill_book.create();
		this.m.ID = "misc.lewd_debauchery_skill_book";
		this.m.Name = "Manual of Debauchery";
		this.m.Description = "A crude but detailed guidebook favored among outlaws, describing techniques of domination and control. Will teach the [color=%negative%]Debauchery[/color] perk group to the character that uses it.";
		this.m.Icon = "misc/inventory_ledger_item.png";
		this.m.SlotType = ::Const.ItemSlot.None;
		this.m.ItemType = ::Const.Items.ItemType.Usable;
		this.m.IsDroppedAsLoot = true;
		this.m.IsUsable = true;
		this.m.Value = 1500;
		this.m.PerkGroupSelection = this.m.PerkGroups[0].Name;
	}

	function isAbleToUseScroll( _actor )
	{
		if (_actor.getGender() != 0)
			return "This manual is written for a male audience.";
		return this.legend_skill_book.isAbleToUseScroll(_actor);
	}

	function addScrollCounter( _actor )
	{
		_actor.getFlags().set("LegendsSkillBookCount", 1);
	}
});
