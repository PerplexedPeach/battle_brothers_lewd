this.lewd_info_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.lewd_info";
		this.m.Name = "Lewd Info";
		this.m.Description = "Shows allure and pleasure information.";
		this.m.Icon = "skills/lewd_info.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

	function isHidden()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlayerControlled()) return true;
		return actor.getCurrentProperties().getAllure() <= 0 && actor.getPleasureMax() <= 0;
	}

	function onCombatStarted()
	{
		// Reset pleasure at battle start (same pattern as fatigue resetting in onCombatFinished)
		this.getContainer().getActor().m.Pleasure = 0;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();

		// allureBase from flags (set by events)
		_properties.Allure += actor.getFlags().getAsInt("allureBase");

		// melee defense contributes half (safe at VeryLast order since MeleeDefense is accumulated)
		_properties.Allure += _properties.getMeleeDefense() * ::Lewd.Const.AllureMeleeDefenseMultiplier;

		// armor penalties
		_properties.Allure -= ::Lewd.Allure.penaltyFromHead(actor);
		_properties.Allure -= ::Lewd.Allure.penaltyFromBody(actor);
		_properties.Allure -= ::Lewd.Allure.penaltyFromOffhand(actor);

		// external trait bonuses/penalties (traits we don't own)
		local skills = actor.getSkills();
		if (skills.hasSkill("trait.legend_seductive"))
		{
			_properties.Allure += ::Lewd.Const.AllureFromSeductive;
		}
		if (skills.hasSkill("trait.athletic"))
		{
			_properties.Allure += ::Lewd.Const.AllureFromAthletic;
		}
		if (skills.hasSkill("trait.gluttonous"))
		{
			_properties.Allure += ::Lewd.Const.AllureFromGluttonous;
		}
		if (skills.hasSkill("trait.fat"))
		{
			_properties.Allure += ::Lewd.Const.AllureFromFat;
		}
		if (skills.hasSkill("trait.ailing"))
		{
			_properties.Allure += ::Lewd.Const.AllureFromAiling;
		}
		if (skills.hasSkill("trait.old"))
		{
			_properties.Allure += ::Lewd.Const.AllureFromOld;
		}
	}

	function getTooltip()
	{
		local actor = this.getContainer().getActor();
		local allure = actor.allure();
		local result = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		// --- Allure section ---
		if (allure != 0)
		{
			result.push({
				id = 10,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "Total Allure: [color=" + this.Const.UI.Color.PositiveValue + "]" + allure + "[/color]"
			});

			result.push({
				id = 11,
				type = "text",
				icon = "ui/icons/allure.png",
				text = "Allure increases with melee defense as it represents your agility. It also is influenced by various traits and items. Events can also influence your base allure (" + actor.getFlags().getAsInt("allureBase") + "). Wearing armor and a shield will reduce allure."
			});

			// armor penalties
			local headPenalty = ::Lewd.Allure.penaltyFromHead(actor);
			local bodyPenalty = ::Lewd.Allure.penaltyFromBody(actor);
			local offhandPenalty = ::Lewd.Allure.penaltyFromOffhand(actor);

			if (headPenalty > 0)
			{
				result.push({
					id = 18,
					type = "hint",
					icon = "ui/icons/warning.png",
					text = "Allure penalty from head: [color=" + this.Const.UI.Color.NegativeValue + "]" + headPenalty + "[/color] (every point of fatigue reduces allure by " + ::Lewd.Const.AllurePenaltyHeadFatigue + ")"
				});
			}
			if (bodyPenalty > 0)
			{
				result.push({
					id = 19,
					type = "hint",
					icon = "ui/icons/warning.png",
					text = "Allure penalty from body: [color=" + this.Const.UI.Color.NegativeValue + "]" + bodyPenalty + "[/color] (every point of fatigue reduces allure by " + ::Lewd.Const.AllurePenaltyBodyFatigue + ")"
				});
			}
			if (offhandPenalty > 0)
			{
				result.push({
					id = 20,
					type = "hint",
					icon = "ui/icons/warning.png",
					text = "Allure penalty from offhand: [color=" + this.Const.UI.Color.NegativeValue + "]" + offhandPenalty + "[/color] (every point of fatigue reduces allure by " + ::Lewd.Const.AllurePenaltyOffhandFatigue + ")"
				});
			}

			// trait bonuses/penalties
			local skills = actor.getSkills();
			if (skills.hasSkill("trait.legend_seductive"))
			{
				result.push({
					id = 21,
					type = "text",
					icon = "ui/traits/trait_seductive.png",
					text = "Seductive allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.AllureFromSeductive + "[/color]"
				});
			}
			if (skills.hasSkill("trait.athletic"))
			{
				result.push({
					id = 22,
					type = "text",
					icon = "ui/traits/trait_icon_21.png",
					text = "Athletic allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.AllureFromAthletic + "[/color]"
				});
			}
			if (skills.hasSkill("trait.dainty"))
			{
				result.push({
					id = 23,
					type = "text",
					icon = "ui/traits/dainty_trait.png",
					text = "Dainty allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.AllureFromDainty + "[/color]"
				});
			}
			if (skills.hasSkill("trait.delicate"))
			{
				result.push({
					id = 24,
					type = "text",
					icon = "ui/traits/delicate_trait.png",
					text = "Delicate allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.AllureFromDelicate + "[/color]"
				});
			}
			if (skills.hasSkill("trait.masochism_first"))
			{
				result.push({
					id = 25,
					type = "text",
					icon = "ui/traits/masochism_first_trait.png",
					text = "Likes pain allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.AllureFromMasochismFirst + "[/color]"
				});
			}
			if (skills.hasSkill("trait.masochism_second"))
			{
				result.push({
					id = 26,
					type = "text",
					icon = "ui/traits/masochism_second_trait.png",
					text = "Masochism allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.AllureFromMasochismSecond + "[/color]"
				});
			}
			if (skills.hasSkill("trait.masochism_third"))
			{
				result.push({
					id = 27,
					type = "text",
					icon = "ui/traits/masochism_third_trait.png",
					text = "Pain slut allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]" + ::Lewd.Const.AllureFromMasochismThird + "[/color]"
				});
			}

			// heel skill bonus
			local heelSkillBonus = actor.getFlags().getAsInt("heelSkill") * ::Lewd.Const.HeelAllureMultiplier;
			if (heelSkillBonus > 0)
			{
				result.push({
					id = 28,
					type = "text",
					icon = "ui/perks/heels_effect.png",
					text = "Heel skill strut bonus: [color=" + this.Const.UI.Color.PositiveValue + "]" + heelSkillBonus + "[/color]"
				});
			}

			// heel allure from item
			local heelAllure = actor.getFlags().getAsInt("allureHeels");
			if (heelAllure > 0)
			{
				result.push({
					id = 29,
					type = "text",
					icon = "ui/perks/heels_effect.png",
					text = "Heel allure bonus: [color=" + this.Const.UI.Color.PositiveValue + "]" + heelAllure + "[/color]"
				});
			}

			if (skills.hasSkill("trait.gluttonous"))
			{
				result.push({
					id = 50,
					type = "text",
					icon = "ui/traits/trait_icon_07.png",
					text = "Gluttonous allure penalty: [color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.AllureFromGluttonous + "[/color]"
				});
			}
			if (skills.hasSkill("trait.fat"))
			{
				result.push({
					id = 51,
					type = "text",
					icon = "ui/traits/trait_icon_10.png",
					text = "Fat allure penalty: [color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.AllureFromFat + "[/color]"
				});
			}
			if (skills.hasSkill("trait.ailing"))
			{
				result.push({
					id = 52,
					type = "text",
					icon = "ui/traits/trait_icon_59.png",
					text = "Ailing allure penalty: [color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.AllureFromAiling + "[/color]"
				});
			}
			if (skills.hasSkill("trait.old"))
			{
				result.push({
					id = 53,
					type = "text",
					icon = "skills/status_effect_60.png",
					text = "Old allure penalty: [color=" + this.Const.UI.Color.NegativeValue + "]" + ::Lewd.Const.AllureFromOld + "[/color]"
				});
			}

			if (skills.hasSkill("effects.pheromones"))
			{
				result.push({
					id = 60,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Pheromones active: [color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Lewd.Const.PheromonesAllureBonus + "[/color] daze chance bonus"
				});
			}
		}

		// --- Pleasure section ---
		local pleasureMax = actor.getPleasureMax();
		if (pleasureMax > 0)
		{
			local pleasure = actor.getPleasure();
			local pct = (pleasure * 100 / pleasureMax).tointeger();
			local barColor = pct >= 75 ? this.Const.UI.Color.NegativeValue : this.Const.UI.Color.PositiveValue;

			result.push({
				id = 70,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Pleasure: [color=" + barColor + "]" + pleasure + " / " + pleasureMax + "[/color]"
			});

			if (pct >= 75)
			{
				result.push({
					id = 71,
					type = "hint",
					icon = "ui/icons/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Close to climax![/color]"
				});
			}
		}

		return result;
	}
});
