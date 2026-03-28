this.lewd_bare_head_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.lewd_bare_head";
		this.m.Type = this.Const.Items.ItemType.Helmet;
		this.m.PreviewCraftable = this.new("scripts/items/legend_helmets/lewd/lewd_bare_head");
		this.m.Cost = 1;
	}

	function isQualified()
	{
		if (!this.World.Flags.has("lewdRecipeCorset")
			&& !this.World.Flags.has("lewdRecipeLatexHarness")
			&& !this.World.Flags.has("lewdRecipeSheerBodysuit")
			&& !this.World.Flags.has("lewdRecipeFishnets")
			&& !this.World.Flags.has("lewdRecipePiercingChains")
			&& !this.World.Flags.has("lewdRecipeHeadwear"))
			return false;
		return true;
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/legend_helmets/lewd/lewd_bare_head"));
	}
});
