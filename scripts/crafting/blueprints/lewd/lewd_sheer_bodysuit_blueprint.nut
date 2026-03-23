this.lewd_sheer_bodysuit_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.lewd_sheer_bodysuit";
		this.m.Type = this.Const.Items.ItemType.Armor;
		this.m.PreviewCraftable = this.new("scripts/items/legend_armor/lewd/lewd_sheer_bodysuit");
		this.m.Cost = 100;
		local ingredients = [
			{
				Script = "scripts/items/misc/spider_silk_item",
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
		if (!this.World.Flags.has("lewdClothingRecipesUnlocked"))
			return false;
		return this.blueprint.isQualified();
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/legend_armor/lewd/lewd_sheer_bodysuit"));
	}
});
