this.hazeem <- this.inherit("scripts/entity/tactical/player", {
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
		this.m.Type = this.Const.EntityType.Peasant;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Councilman.XP;
		this.m.IsGuest = true;
		this.player.create();

		this.m.Bodies = this.Const.Bodies.AfricanMale;
		this.m.Faces = ["bust_head_african_01"];
		this.m.Hairs = ["southern_03"];
		this.m.HairColors = ["black"];
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 0;

		this.m.Name = "Hazeem";
		this.m.Title = "the Master";
		this.m.AIAgent = this.new("scripts/ai/tactical/player_agent");
		this.m.AIAgent.setActor(this);

	}

	function onInit()
	{
		this.player.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Envoy);
		b.TargetAttractionMult = 2.0;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.Talents.resize(this.Const.Attributes.COUNT, 0);
		this.m.Attributes.resize(this.Const.Attributes.COUNT, [
			0
		]);
		this.getSprite("socket").setBrush("bust_base_military");
		this.setAppearance();
		this.assignRandomEquipment();

		// local sprite = this.getSprite("hair");
		// sprite.setBrush("hair_black_southern_02");

		local sprite = this.getSprite("body");
		sprite.setBrush("bust_naked_body_african_01");
		this.getSprite("surcoat").setBrush("bust_body_noble_11");
	}

	function assignRandomEquipment()
	{
		// this.m.Items.equip(this.Const.World.Common.pickArmor([
		// 		// [1, ::Legends.Armor.Southern.padded_mail_and_lamellar_hauberk],
		// 		// [1, ::Legends.Armor.Southern.mail_and_lamellar_plating],
		// 		[1, ::Legends.Armor.Southern.vizier_gear]
		// ]));
	}

});

