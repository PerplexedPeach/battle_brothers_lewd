this.succubus_gheist <- this.inherit("scripts/entity/tactical/player", {
	m = {},
	function getPlaceInFormation()
	{
		return 21;
	}

	function isReallyKilled( _fatalityType )
	{
		return true;
	}

	function create()
	{
		this.m.Type = this.Const.EntityType.Ghost;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.XP = 0;
		this.m.IsGuest = true;
		this.player.create();

		this.m.Bodies = this.Const.Bodies.SouthernFemale;
		this.m.Faces = this.Const.Faces.SouthernFemale;
		this.m.Hairs = this.Const.Hair.SouthernFemale;
		this.m.HairColors = ["black"];
		this.m.Beards = [];
		this.m.BeardChance = 0;

		this.m.Name = "Lingering Gheist";
		this.m.Title = "";
		this.m.AIAgent = this.new("scripts/ai/tactical/player_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.player.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Envoy);
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.Talents.resize(this.Const.Attributes.COUNT, 0);
		this.m.Attributes.resize(this.Const.Attributes.COUNT, [
			0
		]);

		// Use custom succubus gheist sprite instead of generic appearance
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_undead");
		this.getSprite("body").setBrush("bust_succubus_gheist");
		this.m.Items.getAppearance().Body = "bust_succubus_gheist";

		// Hide layers that setAppearance populated
		local hideLayers = ["head", "hair", "beard", "tattoo_head", "tattoo_body",
			"armor", "helmet", "helmet_damage", "armor_upgrade_back",
			"armor_upgrade_front", "surcoat", "shield_icon", "dirt"];
		foreach (layer in hideLayers)
		{
			if (this.hasSprite(layer))
				this.getSprite(layer).Visible = false;
		}
	}
});
