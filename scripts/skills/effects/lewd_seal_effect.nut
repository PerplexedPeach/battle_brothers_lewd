// Lewd Seal -- permanent curse applied by an incubus quest
// 4 progressive stages, each climax during the quest advances the stage
// Stage 1: faint sigil, +5% received pleasure
// Stage 2: brighter, +10% received, +1 self-pleasure/turn
// Stage 3: pulsing, +15% received, +2 self-pleasure/turn, permanently confident
// Stage 4: complete, +25% received, +2 self-pleasure/turn, permanently confident,
//          permanently horny (with partial offset), +allure, +pleasure reflection
this.lewd_seal_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Stage = 1
	},
	function create()
	{
		this.m.ID = "effects.lewd_seal";
		this.m.Name = "Lewd Seal";
		this.m.Icon = "skills/lewd_seal_1.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsSerialized = true;
	}

	function setStage( _stage )
	{
		this.m.Stage = this.Math.min(4, this.Math.max(1, _stage));
		this.updateVisuals();
	}

	function getStage()
	{
		return this.m.Stage;
	}

	function advance()
	{
		if (this.m.Stage < 4)
		{
			this.m.Stage++;
			this.updateVisuals();
		}
	}

	function updateVisuals()
	{
		this.m.Icon = "skills/lewd_seal_" + this.m.Stage + ".png";

		local actor = this.getContainer().getActor();
		if (actor != null && actor.hasSprite("lewd_seal"))
		{
			actor.getSprite("lewd_seal").setBrush("bust_lewd_seal_" + this.m.Stage);
			actor.getSprite("lewd_seal").Visible = true;
			actor.setDirty(true);
		}
	}

	function getStageName()
	{
		switch (this.m.Stage)
		{
			case 1: return "Lewd Seal (Faint)";
			case 2: return "Lewd Seal (Growing)";
			case 3: return "Lewd Seal (Pulsing)";
			case 4: return "Lewd Seal (Complete)";
		}
		return "Lewd Seal";
	}

	function getName()
	{
		return this.getStageName();
	}

	function getDescription()
	{
		switch (this.m.Stage)
		{
			case 1: return "A faint pink sigil flickers on your forehead. You can almost ignore it.";
			case 2: return "The sigil glows brighter now, seeping warmth through your skull. Your thoughts keep drifting.";
			case 3: return "The seal pulses in time with your heartbeat. Fear has become a distant memory, replaced by something warmer.";
			case 4: return "The seal is complete. A glowing pink brand that fills your mind with indecent thoughts and makes your body ache for touch. You are fearless, but hopelessly vulnerable.";
		}
		return "";
	}

	function getTooltip()
	{
		local C = ::Lewd.Const;
		local pos = this.Const.UI.Color.PositiveValue;
		local neg = this.Const.UI.Color.NegativeValue;

		local result = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() }
		];

		// Stage-dependent effects
		local receivedPct = 0;
		local selfP = 0;

		switch (this.m.Stage)
		{
			case 1:
				receivedPct = 5;
				result.push({ id = 10, type = "text", icon = "ui/icons/special.png",
					text = "[color=" + neg + "]+5%[/color] pleasure received" });
				break;

			case 2:
				receivedPct = 10;
				selfP = 1;
				result.push({ id = 10, type = "text", icon = "ui/icons/special.png",
					text = "[color=" + neg + "]+10%[/color] pleasure received" });
				result.push({ id = 11, type = "text", icon = "ui/icons/special.png",
					text = "[color=" + neg + "]+1[/color] self-pleasure per turn" });
				break;

			case 3:
				receivedPct = 15;
				selfP = 2;
				result.push({ id = 10, type = "text", icon = "ui/icons/bravery.png",
					text = "[color=" + pos + "]Permanently Confident[/color]" });
				result.push({ id = 11, type = "text", icon = "ui/icons/special.png",
					text = "[color=" + neg + "]+15%[/color] pleasure received" });
				result.push({ id = 12, type = "text", icon = "ui/icons/special.png",
					text = "[color=" + neg + "]+2[/color] self-pleasure per turn" });
				break;

			case 4:
				result.push({ id = 10, type = "text", icon = "ui/icons/bravery.png",
					text = "[color=" + pos + "]Permanently Confident[/color]" });
				result.push({ id = 11, type = "text", icon = "ui/icons/special.png",
					text = "[color=" + neg + "]Permanently Horny[/color]" });
				result.push({ id = 12, type = "text", icon = "ui/icons/allure.png",
					text = "Allure [color=" + pos + "]+" + C.LewdSealAllure + "[/color]" });
				result.push({ id = 13, type = "text", icon = "ui/icons/special.png",
					text = "[color=" + neg + "]+" + this.Math.floor((C.LewdSealReceivedPleasureMult - 1.0) * 100) + "%[/color] pleasure received" });
				result.push({ id = 14, type = "text", icon = "ui/icons/special.png",
					text = "[color=" + neg + "]+" + this.Math.floor((C.LewdSealPleasureReflectionMult - 1.0) * 100) + "%[/color] pleasure reflected to mounter" });
				result.push({ id = 15, type = "text", icon = "ui/icons/special.png",
					text = "[color=" + neg + "]+" + C.LewdSealSelfPleasurePerTurn + "[/color] self-pleasure per turn" });
				break;
		}

		return result;
	}

	function onAdded()
	{
		this.updateVisuals();

		local actor = this.getContainer().getActor();
		if (this.m.Stage >= 3 && actor.getMoraleState() != this.Const.MoraleState.Ignore)
			actor.setMoraleState(this.Const.MoraleState.Confident);
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("lewd_seal"))
			actor.getSprite("lewd_seal").Visible = false;
		actor.setDirty(true);
	}

	function onUpdate( _properties )
	{
		switch (this.m.Stage)
		{
			case 1:
				_properties.ReceivedPleasureMult *= 1.05;
				break;

			case 2:
				_properties.ReceivedPleasureMult *= 1.10;
				break;

			case 3:
				_properties.ReceivedPleasureMult *= 1.15;
				break;

			case 4:
				_properties.Allure += ::Lewd.Const.LewdSealAllure;
				_properties.ReceivedPleasureMult *= ::Lewd.Const.LewdSealReceivedPleasureMult;
				_properties.PleasureReflectionMult *= ::Lewd.Const.LewdSealPleasureReflectionMult;

				// Horny-equivalent debuffs, partially offset by seal's power
				_properties.InitiativeMult *= ::Lewd.Const.HornyInitiativeMult;
				_properties.InitiativeMult *= 1.15;
				_properties.MeleeDefense += ::Lewd.Const.HornyMeleeDefPenalty;
				_properties.MeleeDefense += 5;
				break;
		}
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();

		// Enforce Confident morale at stage 3+
		if (this.m.Stage >= 3
			&& actor.getMoraleState() != this.Const.MoraleState.Ignore
			&& actor.getMoraleState() != this.Const.MoraleState.Confident)
			actor.setMoraleState(this.Const.MoraleState.Confident);

		// Self-pleasure from lewd thoughts
		local selfP = 0;
		if (this.m.Stage == 2) selfP = 1;
		else if (this.m.Stage >= 3) selfP = 2;

		if (selfP > 0 && actor.isAlive() && actor.getPleasureMax() > 0)
		{
			actor.addPleasure(selfP);
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + "'s lewd seal fills their mind with indecent thoughts (+" + selfP + " pleasure)");
		}
	}

	// Sex abilities auto-hit sealed targets at stage 4 (same as horny)
	function onBeingAttacked( _attacker, _skill, _properties )
	{
		if (this.m.Stage >= 4 && _skill != null && "SexType" in _skill.m)
			_properties.MeleeDefense -= 999;
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU8(this.m.Stage);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.Stage = _in.readU8();
		this.updateVisuals();
	}
});
