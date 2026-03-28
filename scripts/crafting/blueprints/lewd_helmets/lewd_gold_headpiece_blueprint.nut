this.lewd_gold_headpiece_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.lewd_gold_headpiece";
		this.m.Type = this.Const.Items.ItemType.Helmet;
		this.m.PreviewCraftable = this.new("scripts/items/legend_helmets/lewd/lewd_gold_headpiece");
		this.m.Cost = 500;
		local ingredients = [
			{
				Script = "scripts/items/trade/lewd_gold_bar_item",
				Num = 2
			},
			{
				Script = "scripts/items/trade/uncut_gems_item",
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
		if (!this.World.Flags.has("lewdRecipeGoldHeadpiece"))
			return false;
		return true;
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/legend_helmets/lewd/lewd_gold_headpiece"));
	}
});
