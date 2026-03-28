this.lewd_o_ring_gag_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.lewd_o_ring_gag";
		this.m.Type = this.Const.Items.ItemType.Helmet;
		this.m.PreviewCraftable = this.new("scripts/items/legend_helmets/lewd/lewd_o_ring_gag");
		this.m.Cost = 150;
		local ingredients = [
			{
				Script = "scripts/items/trade/legend_silver_ingots_item",
				Num = 1
			},
			{
				Script = "scripts/items/trade/furs_item",
				Num = 1
			}
		];
		this.init(ingredients);
		local skills = [
			{
				Scripts = [
					"scripts/skills/backgrounds/legend_blacksmith_background",
					"scripts/skills/backgrounds/legend_runesmith_background"
				]
			}
		];
		this.initSkills(skills);
	}

	function isQualified()
	{
		if (!this.World.Flags.has("lewdRecipeHeadwear"))
			return false;
		return true;
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/legend_helmets/lewd/lewd_o_ring_gag"));
	}
});
