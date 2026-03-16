this.lewd_tentacle_pillar <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Tentacle Growth";
	}

	function getDescription()
	{
		return "A thick mass of writhing tentacles rising from the corrupted ground.";
	}

	function onInit()
	{
		local variants = [
			"lewd_tentacle_pillar_01",
			"lewd_tentacle_cluster_01"
		];
		local brush = variants[this.Math.rand(0, variants.len() - 1)];
		local flip = this.Math.rand(0, 1) == 1;

		local body = this.addSprite("body");
		body.setBrush(brush);
		body.setHorizontalFlipping(flip);
		body.varyColor(0.05, 0.03, 0.05);
		this.setSpriteOcclusion("body", 1, -2, -2);
		this.setBlockSight(true);
	}

	function onSerialize( _out )
	{
		this.entity.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.entity.onDeserialize(_in);
	}
});
