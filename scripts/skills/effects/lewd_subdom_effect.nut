this.lewd_subdom_effect <- this.inherit("scripts/skills/skill", {
	m = {
		CurrentTier = 0,
		IsDom = true
	},
	function create()
	{
		this.m.ID = "effects.lewd_subdom";
		this.m.Name = "";
		this.m.Description = "";
		this.m.Icon = "skills/lewd_dom.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = false;
	}

	function getScore()
	{
		return ::Lewd.Mastery.getDomSub(this.getContainer().getActor());
	}

	function getDomSubTier()
	{
		local abs = this.Math.abs(this.getScore());
		if (abs >= ::Lewd.Const.DomSubTier4) return 4;
		if (abs >= ::Lewd.Const.DomSubTier3) return 3;
		if (abs >= ::Lewd.Const.DomSubTier2) return 2;
		if (abs >= 1) return 1;
		return 0;
	}

	function isHidden()
	{
		local actor = this.getContainer().getActor();
		return this.getScore() == 0 || !actor.isPlayerControlled();
	}

	function getName()
	{
		local score = this.getScore();
		local tier = this.getDomSubTier();
		if (tier == 0) return "Neutral";

		local name;
		if (score > 0)
		{
			switch (tier)
			{
				case 1: name = "Assertive"; break;
				case 2: name = "Commanding"; break;
				case 3: name = "Dominant"; break;
				case 4: name = "Mistress"; break;
			}
			return name + " (+" + score + ")";
		}
		else
		{
			switch (tier)
			{
				case 1: name = "Yielding"; break;
				case 2: name = "Submissive"; break;
				case 3: name = "Obedient"; break;
				case 4: name = "Tamed"; break;
			}
			return name + " (" + score + ")";
		}
	}

	function getDescription()
	{
		local score = this.getScore();
		local tier = this.getDomSubTier();
		if (tier == 0) return "";

		if (score > 0)
		{
			switch (tier)
			{
				case 1: return "Beginning to take charge in intimate encounters.";
				case 2: return "Taking command of intimate encounters with growing confidence.";
				case 3: return "Total dominance comes naturally. Few can resist your control.";
				case 4: return "Complete authority over others. Your touch commands absolute obedience.";
			}
		}
		else
		{
			switch (tier)
			{
				case 1: return "Finding pleasure in yielding to others.";
				case 2: return "Craving submission, deriving deep satisfaction from being used.";
				case 3: return "Obediently following every command. Resistance feels unnatural.";
				case 4: return "Fully tamed. Submission comes as naturally as breathing.";
			}
		}
		return "";
	}

	function onAfterUpdate( _properties )
	{
		local score = this.getScore();
		local tier = this.getDomSubTier();
		local isDom = score >= 0;

		if (tier != this.m.CurrentTier || isDom != this.m.IsDom)
		{
			this.m.CurrentTier = tier;
			this.m.IsDom = isDom;
			if (isDom)
				this.m.Icon = "skills/lewd_dom.png";
			else
				this.m.Icon = "skills/lewd_sub.png";
		}
	}

	function getTooltip()
	{
		local score = this.getScore();
		local tier = this.getDomSubTier();
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

		// Score display
		local scoreColor = score > 0 ? this.Const.UI.Color.PositiveValue : this.Const.UI.Color.NegativeValue;
		if (score == 0) scoreColor = this.Const.UI.Color.PositiveValue;
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Dom/Sub Score: [color=" + scoreColor + "]" + score + "[/color]"
		});

		// Scaling info
		if (score > 0)
		{
			local domScore = ::Lewd.Mastery.getDomScore(this.getContainer().getActor());
			result.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Hands abilities deal [color=" + this.Const.UI.Color.PositiveValue + "]bonus pleasure[/color] from dominance"
			});
		}
		else if (score < 0)
		{
			result.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Anal abilities deal [color=" + this.Const.UI.Color.PositiveValue + "]bonus pleasure[/color] from submission"
			});
		}

		result.push({
			id = 20,
			type = "hint",
			icon = "ui/icons/special.png",
			text = "Shift toward Dominant by causing climaxes with sex abilities"
		});
		result.push({
			id = 21,
			type = "hint",
			icon = "ui/icons/special.png",
			text = "Shift toward Submissive when enemies cause your climax"
		});

		return result;
	}
});
