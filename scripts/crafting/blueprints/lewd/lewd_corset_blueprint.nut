this.lewd_corset_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.lewd_corset";
		this.m.Type = this.Const.Items.ItemType.Armor;
		this.m.PreviewCraftable = this.new("scripts/items/legend_armor/lewd/lewd_corset");
		this.m.Cost = 150;
		local ingredients = [
			{
				Script = "scripts/items/misc/serpent_skin_item",
				Num = 2
			},
			{
				Script = "scripts/items/misc/spider_silk_item",
				Num = 2
			},
			{
				Script = "scripts/items/misc/lindwurm_bones_item",
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
		if (!this.World.Flags.has("lewdRecipeCorset"))
			return false;
		return true;
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/legend_armor/lewd/lewd_corset"));
	}
});
