this.lewd_piercing_chains_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.lewd_piercing_chains";
		this.m.Type = this.Const.Items.ItemType.Armor;
		this.m.PreviewCraftable = this.new("scripts/items/legend_armor/lewd/lewd_piercing_chains");
		this.m.Cost = 250;
		local ingredients = [
			{
				Script = "scripts/items/loot/ancient_gold_coins_item",
				Num = 1
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
		if (!this.World.Flags.has("lewdRecipePiercingChains"))
			return false;
		return true;
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/legend_armor/lewd/lewd_piercing_chains"));
	}
});
