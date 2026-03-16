this.lewd_tentacle_mound <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Corruption Mound";
	}

	function getDescription()
	{
		return "A heap of fleshy corruption teeming with small tentacles.";
	}

	function onInit()
	{
		local flip = this.Math.rand(0, 1) == 1;

		local body = this.addSprite("body");
		body.setBrush("lewd_tentacle_mound_01");
		body.setHorizontalFlipping(flip);
		body.varyColor(0.05, 0.03, 0.05);
		this.setSpriteOcclusion("body", 1, -1, -1);
		this.setBlockSight(false);
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
