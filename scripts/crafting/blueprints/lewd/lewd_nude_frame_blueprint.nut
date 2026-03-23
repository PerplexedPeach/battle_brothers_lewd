this.lewd_nude_frame_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.lewd_nude_frame";
		this.m.Type = this.Const.Items.ItemType.Armor;
		this.m.PreviewCraftable = this.new("scripts/items/legend_armor/lewd/lewd_nude_frame");
		this.m.Cost = 0;
	}

	function isQualified()
	{
		if (!this.World.Flags.has("lewdClothingRecipesUnlocked"))
			return false;
		return this.blueprint.isQualified();
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/legend_armor/lewd/lewd_nude_frame"));
	}
});
