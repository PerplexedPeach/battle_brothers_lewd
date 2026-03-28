this.lewd_gold_bar_chalice_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.lewd_gold_bar_chalice";
		this.m.Type = this.Const.Items.ItemType.Usable;
		this.m.PreviewCraftable = this.new("scripts/items/trade/lewd_gold_bar_item");
		this.m.Cost = 100;
		local ingredients = [
			{
				Script = "scripts/items/loot/golden_chalice_item",
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
		if (!this.World.Flags.has("lewdRecipePiercingChains"))
			return false;
		return true;
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/trade/lewd_gold_bar_item"));
	}
});
