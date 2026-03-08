// --- Perk Names ---
::Const.Strings.PerkName.LewdNimbleFingers <- "Nimble Fingers";
::Const.Strings.PerkName.LewdOralArts <- "Oral Arts";
::Const.Strings.PerkName.LewdFootTease <- "Foot Tease";
::Const.Strings.PerkName.LewdMounting <- "Mounting";
::Const.Strings.PerkName.LewdOffering <- "Offering";
::Const.Strings.PerkName.LewdSensualFocus <- "Sensual Focus";
::Const.Strings.PerkName.LewdAlluringPresence <- "Alluring Presence";
::Const.Strings.PerkName.LewdPracticedControl <- "Practiced Control";
::Const.Strings.PerkName.LewdInsatiable <- "Insatiable";
::Const.Strings.PerkName.LewdEmbracePain <- "Embrace Pain";
::Const.Strings.PerkName.LewdWillingVictim <- "Willing Victim";
::Const.Strings.PerkName.LewdPliantBody <- "Pliant Body";
::Const.Strings.PerkName.LewdPainFeedsPleasure <- "Pain Feeds Pleasure";
::Const.Strings.PerkName.LewdShameless <- "Shameless";
::Const.Strings.PerkName.LewdTranscendence <- "Transcendence";

// --- Perk Descriptions ---
// Uses Legends tooltip template variables: %positive%, %negative%, %passive%, %skill%, %status%
// These are resolved by ::Legends.tooltip() in afterHooks/perk_tooltips.nut

::Const.Strings.PerkDescription.LewdNimbleFingers <- "Deft hands that know where to linger and when to press. Even the most hardened warrior has nerve endings that betray them.\n\n[color=%passive%][u]Active:[/u][/color]\n• Unlocks the [color=%skill%]Clumsy Groping[/color] sex ability, using your hands to pleasure the target.\n• Pleasure scales with Melee Skill and Dominance.\n\n[color=%passive%][u]Passive:[/u][/color]\n• Mastery upgrades the ability to [color=%skill%]Handjob[/color] and then [color=%skill%]Skilled Handjob[/color] with use.";

::Const.Strings.PerkDescription.LewdOralArts <- "Words are not the only weapon a mouth can wield. With practiced lips and a knowing tongue, even the proudest knight can be brought to his knees.\n\n[color=%passive%][u]Active:[/u][/color]\n• Unlocks the [color=%skill%]Clumsy Oral[/color] sex ability, using your mouth to pleasure the target.\n• Pleasure scales with Resolve and Allure.\n\n[color=%passive%][u]Passive:[/u][/color]\n• Mastery upgrades the ability to [color=%skill%]Oral Service[/color] and then [color=%skill%]Deepthroat[/color] with use.";

::Const.Strings.PerkDescription.LewdFootTease <- "A sharp heel pressing into just the right place can make a man forget his sword arm entirely. Why fight fair when you can fight beautifully?\n\n[color=%passive%][u]Active:[/u][/color]\n• Unlocks the [color=%skill%]Foot Tease[/color] sex ability, using your feet to pleasure the target.\n• Pleasure scales with Heel Skill.\n\n[color=%passive%][u]Passive:[/u][/color]\n• Mastery upgrades the ability to [color=%skill%]Footjob[/color] and then [color=%skill%]Heel Domination[/color] with use.";

::Const.Strings.PerkDescription.LewdMounting <- "Why swing a sword when you can climb on top and let gravity do the work? From above, you set the pace, and they have no choice but to keep up.\n\n[color=%passive%][u]Active:[/u][/color]\n• Unlocks the [color=%skill%]Straddle[/color] sex ability, climbing on top of the target to establish a mount and deal pleasure.\n• Pleasure scales with Initiative.\n• At mastery tier 3, [color=%skill%]Cowgirl[/color] always hits.\n\n[color=%passive%][u]Passive:[/u][/color]\n• Mastery upgrades the ability to [color=%skill%]Riding[/color] and then [color=%skill%]Cowgirl[/color] with use.\n\n[color=%negative%]Requires the Delicate trait.[/color]";

::Const.Strings.PerkDescription.LewdOffering <- "There is a strange power in surrender. To offer yourself completely and feel the enemy lose themselves in the act. The one on the bottom is not always the one who loses.\n\n[color=%passive%][u]Active:[/u][/color]\n• Unlocks the [color=%skill%]Bend Over[/color] sex ability, letting the enemy mount you through anal.\n• Deals high pleasure scaling with submission and masochism, but causes [color=%negative%]hitpoint damage[/color] and [color=%negative%]self-pleasure[/color].\n• At mastery tier 3, [color=%skill%]Breaking Point[/color] deals massive bonus pleasure if you climax during the act.\n\n[color=%passive%][u]Passive:[/u][/color]\n• Mastery upgrades the ability to [color=%skill%]Rough It[/color] and then [color=%skill%]Breaking Point[/color] with use.\n\n[color=%negative%]Requires Masochism and Delicate traits.[/color]";

::Const.Strings.PerkDescription.LewdSensualFocus <- "Every motion is deliberate, every touch calculated. Where others fumble and rush, you have learned to channel sensation like a blade: precise, focused, and devastating.\n\n[color=%passive%][u]Passive:[/u][/color]\n• All sex abilities deal [color=%positive%]+10%[/color] more pleasure.\n\n[color=%passive%][u]Active:[/u][/color]\n• Unlocks the [color=%skill%]Open Invitation[/color] toggle ability.\n• While active, sex abilities deal an additional [color=%positive%]+15%[/color] pleasure, but enemy sex abilities [color=%negative%]auto-hit[/color] you.\n• Bringing enemies to climax while active does [color=%negative%]not increase Dominance[/color].";

::Const.Strings.PerkDescription.LewdAlluringPresence <- "You do not need to lift a finger. The way you stand, the way you breathe, it all radiates something primal that makes enemies falter before you even act.\n\n[color=%passive%][u]Passive:[/u][/color]\n• [color=%positive%]+" + ::Lewd.Const.AlluringPresenceAllure + "[/color] Allure and [color=%positive%]+" + ::Lewd.Const.AlluringPresencePleasureMax + "[/color] Pleasure Max.\n• Adjacent enemies take [color=%positive%]" + ::Lewd.Const.AlluringPresenceAuraPleasure + "[/color] passive pleasure at the start of their turn.\n• The first sex ability used each turn has [color=%positive%]+" + ::Lewd.Const.AlluringPresenceHitBonus + "%[/color] chance to hit.";

::Const.Strings.PerkDescription.LewdPracticedControl <- "Through iron discipline and countless encounters, you have learned to keep your own body in check while driving others to the brink.\n\n[color=%passive%][u]Passive:[/u][/color]\n• Self-pleasure from sex abilities is reduced by [color=%positive%]-50%[/color].\n• Sex abilities cost [color=%positive%]-25%[/color] Fatigue.\n• [color=%positive%]+" + ::Lewd.Const.OrgasmThresholdPracticedControl + "[/color] orgasm threshold before defeat.";

::Const.Strings.PerkDescription.LewdInsatiable <- "One is never enough. The hunger only grows with each conquest, a craving that turns every climax into an appetizer for the next.\n\n[color=%passive%][u]Passive:[/u][/color]\n• Gain [color=%positive%]+" + ::Lewd.Const.InsatiableAPGain + "[/color] AP whenever you bring a target to climax.\n• The target\'s pleasure [color=%positive%]overflows[/color] instead of resetting, keeping them on the edge.\n• [color=%positive%]+" + ::Lewd.Const.OrgasmThresholdInsatiable + "[/color] orgasm threshold before defeat.";

::Const.Strings.PerkDescription.LewdEmbracePain <- "Where others flinch from the sting of a blade, you lean into it. Pain sharpens the senses and quickens the blood, and with the right mindset, every wound becomes fuel.\n\n[color=%passive%][u]Passive:[/u][/color]\n• [color=%positive%]+" + ::Lewd.Const.EmbracePainPleasureMax + "[/color] Pleasure Max.\n• Self-pleasure restores [color=%positive%]" + ::Lewd.Const.EmbracePainFatigueRestore + "[/color] Fatigue per point.\n• Taking hitpoint damage restores [color=%positive%]" + ::Lewd.Const.EmbracePainFatiguePerHit + "[/color] Fatigue and has a [color=%positive%]" + ::Lewd.Const.EmbracePainHornyBaseChance + "%[/color] base chance to make the attacker [color=%status%]Horny[/color], scaling with submission.";

::Const.Strings.PerkDescription.LewdWillingVictim <- "To be taken is not always to be defeated. By offering yourself willingly, you draw the enemy in, and while they are busy with you, they are not fighting your allies.\n\n[color=%passive%][u]Passive:[/u][/color]\n• [color=%positive%]+" + ::Lewd.Const.WillingVictimPleasureMax + "[/color] Pleasure Max.\n• [color=%positive%]+" + ::Lewd.Const.WillingVictimAllure + "[/color] Allure while grappled or mounted.\n• When enemies use sex abilities on you, deal [color=%positive%]" + ::Lewd.Const.WillingVictimCounterPleasure + "[/color] pleasure in return.\n• [color=%status%]Horny[/color] enemies prioritize you as a target.\n• [color=%positive%]+" + ::Lewd.Const.OrgasmThresholdWillingVictim + "[/color] orgasm threshold before defeat.";

::Const.Strings.PerkDescription.LewdPliantBody <- "Soft where it matters, yielding without breaking. Your body has learned to move with whatever is done to it, turning every rough encounter into something that exhausts the other side more than you.\n\n[color=%passive%][u]Passive:[/u][/color]\n• Enemies receive [color=%positive%]+50%[/color] more self-pleasure when using sex abilities on you.\n• While mounted, drains [color=%positive%]" + ::Lewd.Const.PliantBodyFatigueDrain + "[/color] Fatigue from your mounter each turn.\n• Recover [color=%positive%]" + ::Lewd.Const.PliantBodyFatigueRecovery + "[/color] Fatigue when an enemy uses a sex ability on you.\n• Your own sex abilities cost [color=%positive%]-25%[/color] less Fatigue.";

::Const.Strings.PerkDescription.LewdPainFeedsPleasure <- "The line between agony and ecstasy has blurred beyond recognition. Every cut, every bruise sends a shiver that others would not understand, and your body has grown tougher for it.\n\n[color=%passive%][u]Passive:[/u][/color]\n• Masochism damage-to-pleasure conversion rate increased by [color=%positive%]+50%[/color].\n• Injury threshold increased by [color=%positive%]+33%[/color].";

::Const.Strings.PerkDescription.LewdShameless <- "Let them watch. Let them hear. Your cries of ecstasy are not weakness but a weapon that stirs something primal in anyone close enough to witness.\n\n[color=%passive%][u]Passive:[/u][/color]\n• When you climax, adjacent enemies are made [color=%status%]Horny[/color] by the spectacle.\n• Your climax deals [color=%positive%]" + ::Lewd.Const.ShamelessClimaxPleasure + "[/color] pleasure to your current sex partner.";

::Const.Strings.PerkDescription.LewdTranscendence <- "Where others crumble, you ascend. The peak of pleasure that would leave most shattered only makes you more radiant, a being who has mastered the body so completely that even climax becomes a source of power.\n\n[color=%passive%][u]Passive:[/u][/color]\n• Climax no longer applies [color=%negative%]AP[/color] or [color=%negative%]Melee Defense[/color] penalties.\n• Gain [color=%positive%]+" + ::Lewd.Const.TranscendenceClimaxAllure + "[/color] Allure during Climax instead.\n• Pleasure [color=%positive%]overflows[/color] instead of resetting after climax.\n• [color=%positive%]+" + ::Lewd.Const.OrgasmThresholdTranscendence + "[/color] orgasm threshold before defeat.";

// --- Perk Definitions ---
local perkDefObjects = [
	// Seduction Arts tree — ability perks
	{
		ID = "perk.lewd_nimble_fingers",
		Script = "scripts/skills/perks/perk_lewd_nimble_fingers",
		Name = ::Const.Strings.PerkName.LewdNimbleFingers,
		Tooltip = ::Const.Strings.PerkDescription.LewdNimbleFingers,
		Icon = "ui/perks/lewd_nimble_fingers.png",
		IconDisabled = "ui/perks/lewd_nimble_fingers_sw.png",
		Const = "LewdNimbleFingers"
	},
	{
		ID = "perk.lewd_oral_arts",
		Script = "scripts/skills/perks/perk_lewd_oral_arts",
		Name = ::Const.Strings.PerkName.LewdOralArts,
		Tooltip = ::Const.Strings.PerkDescription.LewdOralArts,
		Icon = "ui/perks/lewd_oral_arts.png",
		IconDisabled = "ui/perks/lewd_oral_arts_sw.png",
		Const = "LewdOralArts"
	},
	{
		ID = "perk.lewd_foot_tease",
		Script = "scripts/skills/perks/perk_lewd_foot_tease",
		Name = ::Const.Strings.PerkName.LewdFootTease,
		Tooltip = ::Const.Strings.PerkDescription.LewdFootTease,
		Icon = "ui/perks/lewd_foot_tease.png",
		IconDisabled = "ui/perks/lewd_foot_tease_sw.png",
		Const = "LewdFootTease"
	},
	{
		ID = "perk.lewd_mounting",
		Script = "scripts/skills/perks/perk_lewd_mounting",
		Name = ::Const.Strings.PerkName.LewdMounting,
		Tooltip = ::Const.Strings.PerkDescription.LewdMounting,
		Icon = "ui/perks/lewd_mounting.png",
		IconDisabled = "ui/perks/lewd_mounting_sw.png",
		Const = "LewdMounting"
	},
	// Seduction Arts tree — passive perks
	{
		ID = "perk.lewd_sensual_focus",
		Script = "scripts/skills/perks/perk_lewd_sensual_focus",
		Name = ::Const.Strings.PerkName.LewdSensualFocus,
		Tooltip = ::Const.Strings.PerkDescription.LewdSensualFocus,
		Icon = "ui/perks/lewd_sensual_focus.png",
		IconDisabled = "ui/perks/lewd_sensual_focus_sw.png",
		Const = "LewdSensualFocus"
	},
	{
		ID = "perk.lewd_alluring_presence",
		Script = "scripts/skills/perks/perk_lewd_alluring_presence",
		Name = ::Const.Strings.PerkName.LewdAlluringPresence,
		Tooltip = ::Const.Strings.PerkDescription.LewdAlluringPresence,
		Icon = "ui/perks/lewd_alluring_presence.png",
		IconDisabled = "ui/perks/lewd_alluring_presence_sw.png",
		Const = "LewdAlluringPresence"
	},
	{
		ID = "perk.lewd_practiced_control",
		Script = "scripts/skills/perks/perk_lewd_practiced_control",
		Name = ::Const.Strings.PerkName.LewdPracticedControl,
		Tooltip = ::Const.Strings.PerkDescription.LewdPracticedControl,
		Icon = "ui/perks/lewd_practiced_control.png",
		IconDisabled = "ui/perks/lewd_practiced_control_sw.png",
		Const = "LewdPracticedControl"
	},
	{
		ID = "perk.lewd_insatiable",
		Script = "scripts/skills/perks/perk_lewd_insatiable",
		Name = ::Const.Strings.PerkName.LewdInsatiable,
		Tooltip = ::Const.Strings.PerkDescription.LewdInsatiable,
		Icon = "ui/perks/lewd_insatiable.png",
		IconDisabled = "ui/perks/lewd_insatiable_sw.png",
		Const = "LewdInsatiable"
	},
	// Submission tree
	{
		ID = "perk.lewd_embrace_pain",
		Script = "scripts/skills/perks/perk_lewd_embrace_pain",
		Name = ::Const.Strings.PerkName.LewdEmbracePain,
		Tooltip = ::Const.Strings.PerkDescription.LewdEmbracePain,
		Icon = "ui/perks/lewd_embrace_pain.png",
		IconDisabled = "ui/perks/lewd_embrace_pain_sw.png",
		Const = "LewdEmbracePain"
	},
	{
		ID = "perk.lewd_willing_victim",
		Script = "scripts/skills/perks/perk_lewd_willing_victim",
		Name = ::Const.Strings.PerkName.LewdWillingVictim,
		Tooltip = ::Const.Strings.PerkDescription.LewdWillingVictim,
		Icon = "ui/perks/lewd_willing_victim.png",
		IconDisabled = "ui/perks/lewd_willing_victim_sw.png",
		Const = "LewdWillingVictim"
	},
	{
		ID = "perk.lewd_offering",
		Script = "scripts/skills/perks/perk_lewd_offering",
		Name = ::Const.Strings.PerkName.LewdOffering,
		Tooltip = ::Const.Strings.PerkDescription.LewdOffering,
		Icon = "ui/perks/lewd_offering.png",
		IconDisabled = "ui/perks/lewd_offering_sw.png",
		Const = "LewdOffering"
	},
	{
		ID = "perk.lewd_pliant_body",
		Script = "scripts/skills/perks/perk_lewd_pliant_body",
		Name = ::Const.Strings.PerkName.LewdPliantBody,
		Tooltip = ::Const.Strings.PerkDescription.LewdPliantBody,
		Icon = "ui/perks/lewd_pliant_body.png",
		IconDisabled = "ui/perks/lewd_pliant_body_sw.png",
		Const = "LewdPliantBody"
	},
	{
		ID = "perk.lewd_pain_feeds_pleasure",
		Script = "scripts/skills/perks/perk_lewd_pain_feeds_pleasure",
		Name = ::Const.Strings.PerkName.LewdPainFeedsPleasure,
		Tooltip = ::Const.Strings.PerkDescription.LewdPainFeedsPleasure,
		Icon = "ui/perks/lewd_pain_feeds_pleasure.png",
		IconDisabled = "ui/perks/lewd_pain_feeds_pleasure_sw.png",
		Const = "LewdPainFeedsPleasure"
	},
	{
		ID = "perk.lewd_shameless",
		Script = "scripts/skills/perks/perk_lewd_shameless",
		Name = ::Const.Strings.PerkName.LewdShameless,
		Tooltip = ::Const.Strings.PerkDescription.LewdShameless,
		Icon = "ui/perks/lewd_shameless.png",
		IconDisabled = "ui/perks/lewd_shameless_sw.png",
		Const = "LewdShameless"
	},
	{
		ID = "perk.lewd_transcendence",
		Script = "scripts/skills/perks/perk_lewd_transcendence",
		Name = ::Const.Strings.PerkName.LewdTranscendence,
		Tooltip = ::Const.Strings.PerkDescription.LewdTranscendence,
		Icon = "ui/perks/lewd_transcendence.png",
		IconDisabled = "ui/perks/lewd_transcendence_sw.png",
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
		[::Const.Perks.PerkDefs.LewdNimbleFingers, ::Const.Perks.PerkDefs.LewdFootTease], // T1: pick body parts
		[::Const.Perks.PerkDefs.LewdNimbleFingers, ::Const.Perks.PerkDefs.LewdFootTease], // T2: pick more body parts
		[::Const.Perks.PerkDefs.LewdMounting, ::Const.Perks.PerkDefs.LewdOralArts], // T3: advanced abilities
		[::Const.Perks.PerkDefs.LewdSensualFocus], // T4
		[::Const.Perks.PerkDefs.LewdAlluringPresence], // T5
		[::Const.Perks.PerkDefs.LewdPracticedControl], // T6
		[::Const.Perks.PerkDefs.LewdInsatiable] // T7
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
		[::Const.Perks.PerkDefs.LewdPliantBody], // T4
		[::Const.Perks.PerkDefs.LewdPainFeedsPleasure], // T5
		[::Const.Perks.PerkDefs.LewdShameless], // T6
		[::Const.Perks.PerkDefs.LewdTranscendence] // T7
	]
};
