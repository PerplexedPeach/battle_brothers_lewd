// --- Perk Names ---
::Const.Strings.PerkName.LewdNimbleFingers <- "Nimble Fingers";
::Const.Strings.PerkName.LewdOralArts <- "Oral Arts";
::Const.Strings.PerkName.LewdFootTease <- "Foot Tease";
::Const.Strings.PerkName.LewdMounting <- "Mounting";
::Const.Strings.PerkName.LewdOffering <- "Offering";
::Const.Strings.PerkName.LewdSensualFocus <- "Sensual Focus";
::Const.Strings.PerkName.LewdAlluringPresence <- "Alluring Presence";
::Const.Strings.PerkName.LewdExperiencedLover <- "Experienced Lover";
::Const.Strings.PerkName.LewdPleasureOverflow <- "Pleasure Overflow";
::Const.Strings.PerkName.LewdEmbracePain <- "Embrace Pain";
::Const.Strings.PerkName.LewdWillingVictim <- "Willing Victim";
::Const.Strings.PerkName.LewdResilientBody <- "Resilient Body";
::Const.Strings.PerkName.LewdPainFeedsPleasure <- "Pain Feeds Pleasure";
::Const.Strings.PerkName.LewdShameless <- "Shameless";
::Const.Strings.PerkName.LewdTranscendence <- "Transcendence";

// --- Perk Descriptions ---
local pos = ::Const.UI.Color.PositiveValue;
local neg = ::Const.UI.Color.NegativeValue;

::Const.Strings.PerkDescription.LewdNimbleFingers <- "Unlocks [color=" + pos + "]Clumsy Groping[/color], a hands-based sex ability that scales with Melee Skill. Mastery upgrades to Handjob and Skilled Handjob.";
::Const.Strings.PerkDescription.LewdOralArts <- "Unlocks [color=" + pos + "]Clumsy Oral[/color], an oral sex ability that scales with Resolve and Allure. Mastery upgrades to Oral Service and Deepthroat.";
::Const.Strings.PerkDescription.LewdFootTease <- "Unlocks [color=" + pos + "]Foot Tease[/color], a feet-based sex ability that scales with Heel Skill. Mastery upgrades to Footjob and Heel Domination.";
::Const.Strings.PerkDescription.LewdMounting <- "Unlocks [color=" + pos + "]Straddle[/color], a vaginal sex ability that establishes a mount on the target. Scales with Initiative. Mastery upgrades to Riding and Cowgirl. [color=" + neg + "]Requires Delicate trait.[/color]";
::Const.Strings.PerkDescription.LewdOffering <- "Unlocks [color=" + pos + "]Submit[/color], an anal ability where you let the enemy mount you. Deals high pleasure but causes health damage to yourself. Mastery upgrades to Take It and Pain is Pleasure. [color=" + neg + "]Requires Masochism and Delicate traits.[/color]";
::Const.Strings.PerkDescription.LewdSensualFocus <- "[color=" + pos + "]+10%[/color] pleasure dealt by all sex abilities.";
::Const.Strings.PerkDescription.LewdAlluringPresence <- "[color=" + pos + "]+5[/color] Allure and [color=" + pos + "]+10[/color] Pleasure Max.";
::Const.Strings.PerkDescription.LewdExperiencedLover <- "[color=" + pos + "]+50%[/color] mastery point gain rate for all body parts.";
::Const.Strings.PerkDescription.LewdPleasureOverflow <- "When an enemy climaxes, [color=" + pos + "]25%[/color] of their max pleasure splashes to adjacent enemies.";
::Const.Strings.PerkDescription.LewdEmbracePain <- "[color=" + pos + "]+5[/color] Pleasure Max. Self-pleasure restores [color=" + pos + "]1[/color] Fatigue per point.";
::Const.Strings.PerkDescription.LewdWillingVictim <- "[color=" + pos + "]+5[/color] Allure while grappled or mounted.";
::Const.Strings.PerkDescription.LewdResilientBody <- "[color=" + pos + "]-20%[/color] self-pleasure from all sex acts.";
::Const.Strings.PerkDescription.LewdPainFeedsPleasure <- "Masochism damage-to-pleasure conversion rate increased by [color=" + pos + "]+50%[/color].";
::Const.Strings.PerkDescription.LewdShameless <- "Own Climax [color=" + pos + "]dazes[/color] adjacent enemies (shared ecstasy).";
::Const.Strings.PerkDescription.LewdTranscendence <- "Own Climax [color=" + pos + "]removes AP and Melee Defense penalties[/color], and grants [color=" + pos + "]+10[/color] Allure during Climax instead.";

// --- Perk Definitions ---
local perkDefObjects = [
	// Seduction Arts tree — ability perks
	{
		ID = "perk.lewd_nimble_fingers",
		Script = "scripts/skills/perks/perk_lewd_nimble_fingers",
		Name = ::Const.Strings.PerkName.LewdNimbleFingers,
		Tooltip = ::Const.Strings.PerkDescription.LewdNimbleFingers,
		Icon = "ui/perks/lewd_nimble_fingers.png",
		IconDisabled = "ui/perks/lewd_nimble_fingers_bw.png",
		Const = "LewdNimbleFingers"
	},
	{
		ID = "perk.lewd_oral_arts",
		Script = "scripts/skills/perks/perk_lewd_oral_arts",
		Name = ::Const.Strings.PerkName.LewdOralArts,
		Tooltip = ::Const.Strings.PerkDescription.LewdOralArts,
		Icon = "ui/perks/lewd_oral_arts.png",
		IconDisabled = "ui/perks/lewd_oral_arts_bw.png",
		Const = "LewdOralArts"
	},
	{
		ID = "perk.lewd_foot_tease",
		Script = "scripts/skills/perks/perk_lewd_foot_tease",
		Name = ::Const.Strings.PerkName.LewdFootTease,
		Tooltip = ::Const.Strings.PerkDescription.LewdFootTease,
		Icon = "ui/perks/lewd_foot_tease.png",
		IconDisabled = "ui/perks/lewd_foot_tease_bw.png",
		Const = "LewdFootTease"
	},
	{
		ID = "perk.lewd_mounting",
		Script = "scripts/skills/perks/perk_lewd_mounting",
		Name = ::Const.Strings.PerkName.LewdMounting,
		Tooltip = ::Const.Strings.PerkDescription.LewdMounting,
		Icon = "ui/perks/lewd_mounting.png",
		IconDisabled = "ui/perks/lewd_mounting_bw.png",
		Const = "LewdMounting"
	},
	// Seduction Arts tree — passive perks
	{
		ID = "perk.lewd_sensual_focus",
		Script = "scripts/skills/perks/perk_lewd_sensual_focus",
		Name = ::Const.Strings.PerkName.LewdSensualFocus,
		Tooltip = ::Const.Strings.PerkDescription.LewdSensualFocus,
		Icon = "ui/perks/lewd_sensual_focus.png",
		IconDisabled = "ui/perks/lewd_sensual_focus_bw.png",
		Const = "LewdSensualFocus"
	},
	{
		ID = "perk.lewd_alluring_presence",
		Script = "scripts/skills/perks/perk_lewd_alluring_presence",
		Name = ::Const.Strings.PerkName.LewdAlluringPresence,
		Tooltip = ::Const.Strings.PerkDescription.LewdAlluringPresence,
		Icon = "ui/perks/lewd_alluring_presence.png",
		IconDisabled = "ui/perks/lewd_alluring_presence_bw.png",
		Const = "LewdAlluringPresence"
	},
	{
		ID = "perk.lewd_experienced_lover",
		Script = "scripts/skills/perks/perk_lewd_experienced_lover",
		Name = ::Const.Strings.PerkName.LewdExperiencedLover,
		Tooltip = ::Const.Strings.PerkDescription.LewdExperiencedLover,
		Icon = "ui/perks/lewd_experienced_lover.png",
		IconDisabled = "ui/perks/lewd_experienced_lover_bw.png",
		Const = "LewdExperiencedLover"
	},
	{
		ID = "perk.lewd_pleasure_overflow",
		Script = "scripts/skills/perks/perk_lewd_pleasure_overflow",
		Name = ::Const.Strings.PerkName.LewdPleasureOverflow,
		Tooltip = ::Const.Strings.PerkDescription.LewdPleasureOverflow,
		Icon = "ui/perks/lewd_pleasure_overflow.png",
		IconDisabled = "ui/perks/lewd_pleasure_overflow_bw.png",
		Const = "LewdPleasureOverflow"
	},
	// Submission tree
	{
		ID = "perk.lewd_embrace_pain",
		Script = "scripts/skills/perks/perk_lewd_embrace_pain",
		Name = ::Const.Strings.PerkName.LewdEmbracePain,
		Tooltip = ::Const.Strings.PerkDescription.LewdEmbracePain,
		Icon = "ui/perks/lewd_embrace_pain.png",
		IconDisabled = "ui/perks/lewd_embrace_pain_bw.png",
		Const = "LewdEmbracePain"
	},
	{
		ID = "perk.lewd_willing_victim",
		Script = "scripts/skills/perks/perk_lewd_willing_victim",
		Name = ::Const.Strings.PerkName.LewdWillingVictim,
		Tooltip = ::Const.Strings.PerkDescription.LewdWillingVictim,
		Icon = "ui/perks/lewd_willing_victim.png",
		IconDisabled = "ui/perks/lewd_willing_victim_bw.png",
		Const = "LewdWillingVictim"
	},
	{
		ID = "perk.lewd_offering",
		Script = "scripts/skills/perks/perk_lewd_offering",
		Name = ::Const.Strings.PerkName.LewdOffering,
		Tooltip = ::Const.Strings.PerkDescription.LewdOffering,
		Icon = "ui/perks/lewd_offering.png",
		IconDisabled = "ui/perks/lewd_offering_bw.png",
		Const = "LewdOffering"
	},
	{
		ID = "perk.lewd_resilient_body",
		Script = "scripts/skills/perks/perk_lewd_resilient_body",
		Name = ::Const.Strings.PerkName.LewdResilientBody,
		Tooltip = ::Const.Strings.PerkDescription.LewdResilientBody,
		Icon = "ui/perks/lewd_resilient_body.png",
		IconDisabled = "ui/perks/lewd_resilient_body_bw.png",
		Const = "LewdResilientBody"
	},
	{
		ID = "perk.lewd_pain_feeds_pleasure",
		Script = "scripts/skills/perks/perk_lewd_pain_feeds_pleasure",
		Name = ::Const.Strings.PerkName.LewdPainFeedsPleasure,
		Tooltip = ::Const.Strings.PerkDescription.LewdPainFeedsPleasure,
		Icon = "ui/perks/lewd_pain_feeds_pleasure.png",
		IconDisabled = "ui/perks/lewd_pain_feeds_pleasure_bw.png",
		Const = "LewdPainFeedsPleasure"
	},
	{
		ID = "perk.lewd_shameless",
		Script = "scripts/skills/perks/perk_lewd_shameless",
		Name = ::Const.Strings.PerkName.LewdShameless,
		Tooltip = ::Const.Strings.PerkDescription.LewdShameless,
		Icon = "ui/perks/lewd_shameless.png",
		IconDisabled = "ui/perks/lewd_shameless_bw.png",
		Const = "LewdShameless"
	},
	{
		ID = "perk.lewd_transcendence",
		Script = "scripts/skills/perks/perk_lewd_transcendence",
		Name = ::Const.Strings.PerkName.LewdTranscendence,
		Tooltip = ::Const.Strings.PerkDescription.LewdTranscendence,
		Icon = "ui/perks/lewd_transcendence.png",
		IconDisabled = "ui/perks/lewd_transcendence_bw.png",
		Const = "LewdTranscendence"
	}
];
::Const.Perks.addPerkDefObjects(perkDefObjects);

// --- Perk Tree: Seduction Arts (requires Dainty or Delicate) ---
::Const.Perks.SeductionArtsTree <- {
	ID = "SeductionArtsTree",
	Name = "Seduction Arts",
	Descriptions = [
		"Seduction Arts"
	],
	Tree = [
		[::Const.Perks.PerkDefs.LewdNimbleFingers, ::Const.Perks.PerkDefs.LewdOralArts, ::Const.Perks.PerkDefs.LewdFootTease], // T1: pick body parts
		[::Const.Perks.PerkDefs.LewdNimbleFingers, ::Const.Perks.PerkDefs.LewdOralArts, ::Const.Perks.PerkDefs.LewdFootTease], // T2: pick more body parts
		[::Const.Perks.PerkDefs.LewdMounting], // T3: mounting (requires Delicate)
		[::Const.Perks.PerkDefs.LewdSensualFocus], // T4
		[::Const.Perks.PerkDefs.LewdAlluringPresence], // T5
		[::Const.Perks.PerkDefs.LewdExperiencedLover], // T6
		[::Const.Perks.PerkDefs.LewdPleasureOverflow] // T7
	]
};

// --- Perk Tree: Endurance (requires Masochism + Delicate) ---
::Const.Perks.EnduranceTree <- {
	ID = "EnduranceTree",
	Name = "Endurance",
	Descriptions = [
		"Endurance"
	],
	Tree = [
		[::Const.Perks.PerkDefs.LewdEmbracePain], // T1
		[::Const.Perks.PerkDefs.LewdWillingVictim], // T2
		[::Const.Perks.PerkDefs.LewdOffering], // T3: anal ability
		[::Const.Perks.PerkDefs.LewdResilientBody], // T4
		[::Const.Perks.PerkDefs.LewdPainFeedsPleasure], // T5
		[::Const.Perks.PerkDefs.LewdShameless], // T6
		[::Const.Perks.PerkDefs.LewdTranscendence] // T7
	]
};
