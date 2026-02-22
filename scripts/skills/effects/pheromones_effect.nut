this.pheromones_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 0,
		isActive = false,
		triPhaseA = 0.00,
		triPhaseB = 0.00,
		triPhaseC = 0.00,
		triPhaseD = 0.00,
		triPhaseE = 0.00
	},
	function create()
	{
		this.m.ID = "effects.pheromones";
		this.m.Name = "Pheromones";
		this.m.Description = "Releasing intoxicating pheromones that enhance your alluring presence, making it harder for enemies to resist your beauty.";
		this.m.Icon = "skills/seduce.png";
		this.m.IconMini = "";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Releasing intoxicating pheromones for [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.TurnsLeft + "[/color] more turn(s). Entrancing Beauty daze chance is increased by [color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.PheromonesAllureBonus + "[/color].";
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Entrancing Beauty daze chance boosted by [color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.PheromonesAllureBonus + "[/color]"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/turns.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.TurnsLeft + "[/color] turn(s) remaining"
			}
		];
	}

	triggerRender = function()
	{
		if (!this.m.isActive) return;

		local actor = this.getContainer().getActor();
		if (actor == null || !actor.hasSprite("lewd_glow")) return;

		local spr = actor.getSprite("lewd_glow");
		local t = this.Time.getVirtualTimeF();

		function triWave(speed, phase)
		{
			local v = (t * speed + phase) % 2.0;
			return v < 1.0 ? v : (2.0 - v);
		}

		// Scale: gentle pulse 0.85 - 1.0
		local scaleBase = 0.85;
		local scaleAmp  = 0.15;
		spr.Scale = scaleBase + triWave(0.40, this.m.triPhaseA) * scaleAmp;

		// Rotation: gentle sway +/- 4 degrees
		spr.Rotation = (-4.0 + triWave(0.20, this.m.triPhaseB) * 8.0);

		// Horizontal drift: subtle -2..+4px
		local ox = -2.0 + triWave(0.18, this.m.triPhaseC) * 6.0;

		// Vertical drift: upward bias -18..-10px
		local oy = -18.0 + triWave(0.35, this.m.triPhaseD) * 8.0;

		actor.setSpriteOffset("lewd_glow", this.createVec(ox, oy));

		// Alpha pulse: shimmer between 90 and 255
		local alphaMin = 90;
		local alphaMax = 255;
		spr.Alpha = alphaMin + triWave(0.45, this.m.triPhaseE) * (alphaMax - alphaMin);

		// Saturation wobble
		spr.Saturation = 0.2 + triWave(0.30, this.m.triPhaseE) * 0.4;
	}

	function onAdded()
	{
		this.m.TurnsLeft = ::Lewd.Const.PheromonesDuration;

		// Randomize phase offsets for visual variety
		this.m.triPhaseA = this.Math.rand(0, 150) * 0.01;
		this.m.triPhaseB = this.Math.rand(0, 150) * 0.01;
		this.m.triPhaseC = this.Math.rand(0, 150) * 0.01;
		this.m.triPhaseD = this.Math.rand(0, 150) * 0.01;
		this.m.triPhaseE = this.Math.rand(0, 150) * 0.01;

		local actor = this.getContainer().getActor();
		if (actor.hasSprite("lewd_glow"))
		{
			local glow = actor.getSprite("lewd_glow");
			glow.setBrush("lewd_pheromone_glow");
			glow.Color = this.createColor("#ff69b4");
			glow.Saturation = 0.8;
			glow.Scale = 0.85;
			glow.varyColor(0.05, 0.05, 0.05);
			glow.Visible = true;

			actor.setRenderCallbackEnabled(true);
			actor.setAlwaysApplySpriteOffset(true);
			this.m.isActive = true;
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		if (actor != null && actor.hasSprite("lewd_glow"))
		{
			actor.getSprite("lewd_glow").Visible = false;
		}
		this.m.isActive = false;
	}

	function onTurnStart()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}
});
