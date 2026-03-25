this.lewd_latex_harness_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.lewd_latex_harness";
		this.m.Type = this.Const.Items.ItemType.Armor;
		this.m.PreviewCraftable = this.new("scripts/items/legend_armor/lewd/lewd_latex_harness");
		this.m.Cost = 200;
		local ingredients = [
			{
				Script = "scripts/items/misc/legend_demon_alp_skin_item",
				Num = 2
			},
			{
				Script = "scripts/items/misc/legend_masterwork_fabric",
				Num = 1
			}
		];
		this.init(ingredients);
		local skills = [
			{
				Scripts = [
					"scripts/skills/backgrounds/tailor_background",
					"scripts/skills/backgrounds/tailor_southern_background"
				]
			}
		];
		this.initSkills(skills);
	}

	function isQualified()
	{
		if (!this.World.Flags.has("lewdRecipeLatexHarness"))
			return false;
		return true;
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/legend_armor/lewd/lewd_latex_harness"));
	}
});
