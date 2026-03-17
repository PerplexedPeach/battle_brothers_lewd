// --- Character Properties ---
::Const.CharacterProperties.Allure <- 0;
::Const.CharacterProperties.PleasureMax <- 0;
::Const.CharacterProperties.PleasureReflectionMult <- 1.0;
::Const.CharacterProperties.getAllure <- function() { return this.Math.floor(this.Allure); };
::Const.CharacterProperties.getPleasureMax <- function() { return this.Math.floor(this.PleasureMax); };

// --- Allure Constants ---
::Lewd.Const.HeelFatigueMultiplier <- 2;
::Lewd.Const.HeelAllureMultiplier <- 2;
::Lewd.Const.CritChanceThreshold <- 50; // for some effects if the roll is this amount below the chance, a stronger effect gets applied

::Lewd.Const.AllurePenaltyHeadFatigue <- 2; // allure penalty per point of fatigue from head items
::Lewd.Const.AllurePenaltyBodyFatigue <- 1;
::Lewd.Const.AllurePenaltyOffhandFatigue <- 2;

// allure from traits
::Lewd.Const.AllureFromSeductive <- 10;
::Lewd.Const.AllureFromAthletic <- 5;
::Lewd.Const.AllureFromDainty <- 5;
::Lewd.Const.AllureFromDelicate <- 10;
::Lewd.Const.AllureFromEthereal <- 20;
::Lewd.Const.AllureFromMasochismFirst <- 5;
::Lewd.Const.AllureFromMasochismSecond <- 10;
::Lewd.Const.AllureFromMasochismThird <- 15;
::Lewd.Const.AllureFromGluttonous <- -5;
::Lewd.Const.AllureFromFat <- -20;
::Lewd.Const.AllureFromAiling <- -10;
::Lewd.Const.AllureFromOld <- -20;
::Lewd.Const.AllureMeleeDefenseMultiplier <- 0.5;

// --- Pleasure & Climax Constants ---
::Lewd.Const.PleasureMaxFromDainty <- 5;
::Lewd.Const.PleasureMaxFromDelicate <- 10;
::Lewd.Const.PleasureMaxFromEthereal <- 15;
::Lewd.Const.PleasureMaxFromMasochismFirst <- 0;
::Lewd.Const.PleasureMaxFromMasochismSecond <- 0;
::Lewd.Const.PleasureMaxFromMasochismThird <- 0;
::Lewd.Const.PleasureFromDamageMasochismFirst <- 0.2;
::Lewd.Const.PleasureFromDamageMasochismSecond <- 0.35;
::Lewd.Const.PleasureFromDamageMasochismThird <- 0.5;
::Lewd.Const.ClimaxDuration <- 2;
::Lewd.Const.ClimaxAPPenalty <- -2;
::Lewd.Const.ClimaxMeleeDefensePenalty <- -10;
::Lewd.Const.ClimaxInitiativePenalty <- -15;
::Lewd.Const.ClimaxResolveBonus <- 10;
::Lewd.Const.ClimaxAllureBonus <- 5;

// ability constants
::Lewd.Const.AllureToDazeBaseChance <- 40;
::Lewd.Const.AllureToDazeChanceMultiplier <- 0.8;
::Lewd.Const.AllureToDazeDistancePenalty <- 20; // effect chance is reduced by this much for every tile of distance from the target
::Lewd.Const.BeautyAllyResolveBonus <- 30; // allied males get +30 effective resolve vs Entrancing Beauty

// Tease ability (ranged horny induction, melee alternate: Grind)
::Lewd.Const.TeaseBaseChance <- 50;
::Lewd.Const.TeaseAllureBonus <- 20; // flat allure bonus for hit calc
::Lewd.Const.TeaseAllureScale <- 0.8; // (allure - resolve) * this
::Lewd.Const.TeaseDistancePenalty <- 10; // per tile of distance
::Lewd.Const.TeaseAP <- 5;
::Lewd.Const.TeaseFatigue <- 15;
::Lewd.Const.TeaseMaxRange <- 4;
::Lewd.Const.TeaseGrindMeleeScale <- 0.1; // bonus from melee skill when in melee range

// event occurance rates
::Lewd.Const.HeelFirstEventBaseScore <- 10;
::Lewd.Const.HeelFirstEventScoreRenownScale <- 0.05;

::Lewd.Const.HeelSkillUpCooldownDays <- 5;
::Lewd.Const.HeelSkillUpBaseScore <- 40;
::Lewd.Const.HeelSkillUpDifferenceMultiplier <- 30; // for every point of difference in heel height and skill, add this much
::Lewd.Const.HeelSkillUpLevelScale <- 5;
::Lewd.Const.HeelSkillUpNimbleBonus <- 40; // bonus score for being nimble, since that synergizes well with heel walking
::Lewd.Const.HeelSkillUpStudentBonus <- 10;

::Lewd.Const.HeelSecondEventBaseScore <- 100;

::Lewd.Const.HeelThirdEventBaseScore <- 150;

// masochism event
::Lewd.Const.MasochismDamageTakenMultScore <- 3;
::Lewd.Const.MasochismSouthernDistanceRequirement <- 10; // how many tiles within a southern city you need to be within for event to trigger

// pheromones ability
::Lewd.Const.PheromonesAllureBonus <- 25; // flat bonus to entrancing beauty chance while pheromones active
::Lewd.Const.PheromonesDuration <- 3; // turns (includes cast turn's onTurnEnd)
::Lewd.Const.PheromonesAPCost <- 3;
::Lewd.Const.PheromonesFatigueCost <- 10;

// --- Mastery System ---
::Lewd.Const.MasteryPointGainBaseChance <- 10; // base % chance to gain a point per skill use
::Lewd.Const.MasteryPointGainAPMultiplier <- 1.5; // chance += floor(AP^2 * this)
::Lewd.Const.MasteryCombatBonus <- 2; // bonus points per battle if associated skill used
// (MasteryPracticedControlMult removed — Practiced Control now reduces reflection instead)

// mastery limits per body part
::Lewd.Const.MasteryLimitOral <- 100;
::Lewd.Const.MasteryLimitHands <- 80;
::Lewd.Const.MasteryLimitVaginal <- 120;
::Lewd.Const.MasteryLimitAnal <- 100;
::Lewd.Const.MasteryLimitFeet <- 100;

// mastery tier thresholds
::Lewd.Const.MasteryOralT2 <- 30;
::Lewd.Const.MasteryOralT3 <- 70;
::Lewd.Const.MasteryHandsT2 <- 20;
::Lewd.Const.MasteryHandsT3 <- 50;
::Lewd.Const.MasteryVaginalT2 <- 30;
::Lewd.Const.MasteryVaginalT3 <- 80;
::Lewd.Const.MasteryAnalT2 <- 25;
::Lewd.Const.MasteryAnalT3 <- 65;
::Lewd.Const.MasteryFeetT2 <- 25;
::Lewd.Const.MasteryFeetT3 <- 60;

// mastery passive bonus thresholds (body part: [threshold, ...])
// Oral: 15: -3 fatigue, 50: +3 pleasure dealt, 90: +5 Resolve
::Lewd.Const.MasteryOralFatigueThreshold <- 15;
::Lewd.Const.MasteryOralFatigueBonus <- -3;
::Lewd.Const.MasteryOralPleasureThreshold <- 50;
::Lewd.Const.MasteryOralPleasureBonus <- 3;
::Lewd.Const.MasteryOralResolveThreshold <- 90;
::Lewd.Const.MasteryOralResolveBonus <- 10;

// Hands: 10: +5% hit, 35: +2 pleasure dealt, 70: +10% hit
::Lewd.Const.MasteryHandsHitThreshold <- 10;
::Lewd.Const.MasteryHandsHitBonus <- 5;
::Lewd.Const.MasteryHandsPleasureThreshold <- 35;
::Lewd.Const.MasteryHandsPleasureBonus <- 2;
::Lewd.Const.MasteryHandsHitT3Threshold <- 70;
::Lewd.Const.MasteryHandsHitT3Bonus <- 10;

// Vaginal: 20: -25% self-pleasure, 50: +4 pleasure dealt, 110: -1 AP
::Lewd.Const.MasteryVaginalSelfPleasureThreshold <- 20;
::Lewd.Const.MasteryVaginalSelfPleasureMult <- 0.75;
::Lewd.Const.MasteryVaginalPleasureThreshold <- 50;
::Lewd.Const.MasteryVaginalPleasureBonus <- 4;
::Lewd.Const.MasteryVaginalAPThreshold <- 110;
::Lewd.Const.MasteryVaginalAPBonus <- -1;

// Anal: 10: +5 resolve, 40: -1 AP, 85: climax splash
::Lewd.Const.MasteryAnalResolveThreshold <- 10;
::Lewd.Const.MasteryAnalResolveBonus <- 5;
::Lewd.Const.MasteryAnalAPThreshold <- 40;
::Lewd.Const.MasteryAnalAPBonus <- -1;
::Lewd.Const.MasteryAnalSplashThreshold <- 85;

// Feet: 15: -2 fatigue, 40: +2 pleasure dealt, 85: ignore 20% Resolve
::Lewd.Const.MasteryFeetFatigueThreshold <- 15;
::Lewd.Const.MasteryFeetFatigueBonus <- -2;
::Lewd.Const.MasteryFeetPleasureThreshold <- 40;
::Lewd.Const.MasteryFeetPleasureBonus <- 2;
::Lewd.Const.MasteryFeetResolveIgnoreThreshold <- 85;
::Lewd.Const.MasteryFeetResolveIgnorePct <- 0.2;

// mastery capstone bonuses (awarded at max mastery)
::Lewd.Const.MasteryCapstoneAllure <- 3;
::Lewd.Const.MasteryCapstoneHandsMeleeSkill <- 3;
::Lewd.Const.MasteryCapstoneOralResolve <- 5;
::Lewd.Const.MasteryCapstoneFeetInitiative <- 10;
::Lewd.Const.MasteryCapstoneVaginalStamina <- 10;
::Lewd.Const.MasteryCapstoneAnalHitpoints <- 8;

// --- Sex Ability Constants ---
::Lewd.Const.SexSoundVolume <- 1.0; // multiplier for sex sound volume (0.0 to 2.0, from settings slider)
::Lewd.Const.SexAbilityDelayDefault <- 400;
::Lewd.Const.SexFlashColor <- this.createColor("#ffffff");
::Lewd.Const.SexFlashHighlight <- this.createColor("#ff1493");
::Lewd.Const.SexFlashFactor <- 0.5;
::Lewd.Const.SexFlashSaturation <- 1.0;

// universal allure scaling for pleasure dealt
::Lewd.Const.SexAllurePleasureScale <- 0.15; // floor(allure * this) added to pleasure dealt

// hit chance formula: baseChance + (userAllure - targetResolve) * multiplier, clamped 5-95
::Lewd.Const.SexHitChanceAllureResolveScale <- 2;
::Lewd.Const.SexHitChanceMin <- 5;
::Lewd.Const.SexHitChanceMax <- 95;

// fatigue vulnerability: floor(targetFatiguePct * this) bonus pleasure
::Lewd.Const.SexFatigueVulnerabilityBonus <- 5;

// --- Mount System ---
::Lewd.Const.MountDuration <- 3;
::Lewd.Const.MountMeleeDefPenalty <- -8;
::Lewd.Const.MountMeleeSkillPenalty <- -10;
::Lewd.Const.MountRangedSkillPenalty <- -15;
::Lewd.Const.MountInitiativeMult <- 0.8; // 20% Initiative reduction
::Lewd.Const.MountPleasureVulnerability <- 1.10; // 10% more pleasure taken while mounted
::Lewd.Const.MountingMeleeSkillPenalty <- -5;
::Lewd.Const.MountingRangedSkillPenalty <- -10;
::Lewd.Const.MountingDamageBreakThreshold <- 15; // HP damage to mounter that breaks the mount

// --- Allied Harassment ---
::Lewd.Const.HarassmentAllureThreshold <- 20; // minimum allure on female to be eligible
::Lewd.Const.HarassmentChancePerAllure <- 2; // % chance per point of allure above threshold
::Lewd.Const.HarassmentResolveScale <- 1.0; // brother resolve reduces chance (subtracted)
::Lewd.Const.HarassmentDomSubScale <- 1; // target dom reduces harassment trigger chance
::Lewd.Const.HarassmentMinChance <- 5;
::Lewd.Const.HarassmentMaxChance <- 50;
::Lewd.Const.MaleSexMountedHitBonus <- 15; // +15% hit chance on mounted targets
::Lewd.Const.AlliedGropeAP <- 3;
::Lewd.Const.AlliedGropeFatigue <- 6;
::Lewd.Const.AlliedGropeBasePleasure <- 3;
::Lewd.Const.AlliedGropeMeleeSkillScale <- 0.03;

// --- Oral Skill Tiers ---
::Lewd.Const.OralT1AP <- 5;
::Lewd.Const.OralT1Fatigue <- 12;
::Lewd.Const.OralT1BasePleasure <- 6;
::Lewd.Const.OralT1SelfPleasure <- 0;
::Lewd.Const.OralT1SelfPleasureChance <- 20; // 20% chance of 2 self-pleasure
::Lewd.Const.OralT1SelfPleasureAmount <- 2;
::Lewd.Const.OralT1ResolveScale <- 0.08;
::Lewd.Const.OralT1AllureScale <- 0.05; // bonus allure scaling (they see your face)
::Lewd.Const.OralT1BaseHitChance <- 40;

::Lewd.Const.OralT2AP <- 5;
::Lewd.Const.OralT2Fatigue <- 15;
::Lewd.Const.OralT2BasePleasure <- 10;
::Lewd.Const.OralT2SelfPleasure <- 0;
::Lewd.Const.OralT2ResolveScale <- 0.12;
::Lewd.Const.OralT2AllureScale <- 0.08;
::Lewd.Const.OralT2BaseHitChance <- 55;
::Lewd.Const.OralT2MountBonus <- 4;

::Lewd.Const.OralT3AP <- 5;
::Lewd.Const.OralT3Fatigue <- 20;
::Lewd.Const.OralT3BasePleasure <- 14;
::Lewd.Const.OralT3SelfPleasure <- 3;
::Lewd.Const.OralT3ResolveScale <- 0.12;
::Lewd.Const.OralT3AllureScale <- 0.1;
::Lewd.Const.OralT3BaseHitChance <- 65;
::Lewd.Const.OralT3MountBonus <- 6;
::Lewd.Const.OralT3ResolveDebuff <- -5;
::Lewd.Const.OralT3DebuffDuration <- 1;

// --- Hands Skill Tiers ---
::Lewd.Const.HandsT1AP <- 3;
::Lewd.Const.HandsT1Fatigue <- 8;
::Lewd.Const.HandsT1BasePleasure <- 4;
::Lewd.Const.HandsT1SelfPleasure <- 0;
::Lewd.Const.HandsT1MeleeSkillScale <- 0.06;
::Lewd.Const.HandsT1BaseHitChance <- 40;

::Lewd.Const.HandsT2AP <- 3;
::Lewd.Const.HandsT2Fatigue <- 10;
::Lewd.Const.HandsT2BasePleasure <- 7;
::Lewd.Const.HandsT2SelfPleasure <- 0;
::Lewd.Const.HandsT2MeleeSkillScale <- 0.08;
::Lewd.Const.HandsT2BaseHitChance <- 55;
::Lewd.Const.HandsT2MountBonus <- 3;

::Lewd.Const.HandsT3AP <- 3;
::Lewd.Const.HandsT3Fatigue <- 12;
::Lewd.Const.HandsT3BasePleasure <- 10;
::Lewd.Const.HandsT3SelfPleasure <- 0;
::Lewd.Const.HandsT3MeleeSkillScale <- 0.1;
::Lewd.Const.HandsT3BaseHitChance <- 65;
::Lewd.Const.HandsT3MountBonus <- 5;
::Lewd.Const.HandsT3InitDebuff <- -5;
::Lewd.Const.HandsT3DebuffDuration <- 1;

// --- Vaginal Skill Tiers ---
::Lewd.Const.VaginalT1AP <- 6;
::Lewd.Const.VaginalT1Fatigue <- 18;
::Lewd.Const.VaginalT1BasePleasure <- 10;
::Lewd.Const.VaginalT1SelfPleasure <- 8;
::Lewd.Const.VaginalT1InitiativeScale <- 0.06;
::Lewd.Const.VaginalT1BaseHitChance <- 40;

::Lewd.Const.VaginalT2AP <- 5;
::Lewd.Const.VaginalT2Fatigue <- 15;
::Lewd.Const.VaginalT2BasePleasure <- 14;
::Lewd.Const.VaginalT2SelfPleasure <- 10;
::Lewd.Const.VaginalT2InitiativeScale <- 0.1;
::Lewd.Const.VaginalT2BaseHitChance <- 55;

::Lewd.Const.VaginalT3AP <- 5;
::Lewd.Const.VaginalT3Fatigue <- 18;
::Lewd.Const.VaginalT3BasePleasure <- 20;
::Lewd.Const.VaginalT3SelfPleasure <- 12;
::Lewd.Const.VaginalT3InitiativeScale <- 0.14;
::Lewd.Const.VaginalT3BaseHitChance <- 65;
::Lewd.Const.VaginalT3APDebuff <- -2;
::Lewd.Const.VaginalT3DebuffDuration <- 1;

// --- Anal Skill Tiers ---
::Lewd.Const.AnalT1AP <- 5;
::Lewd.Const.AnalT1Fatigue <- 15;
::Lewd.Const.AnalT1BasePleasure <- 8;
::Lewd.Const.AnalT1SelfPleasure <- 4;
::Lewd.Const.AnalT1SelfDamage <- 2; // HP damage to self
::Lewd.Const.AnalT1BaseHitChance <- 40;

::Lewd.Const.AnalT2AP <- 5;
::Lewd.Const.AnalT2Fatigue <- 12;
::Lewd.Const.AnalT2BasePleasure <- 11;
::Lewd.Const.AnalT2SelfPleasure <- 5;
::Lewd.Const.AnalT2SelfDamage <- 3;
::Lewd.Const.AnalT2BaseHitChance <- 55;
::Lewd.Const.AnalT2MasoTierBonus <- 3; // bonus per maso tier

::Lewd.Const.AnalT3AP <- 5;
::Lewd.Const.AnalT3Fatigue <- 20;
::Lewd.Const.AnalT3BasePleasure <- 15;
::Lewd.Const.AnalT3SelfPleasure <- 8;
::Lewd.Const.AnalT3SelfDamage <- 5;
::Lewd.Const.AnalT3BaseHitChance <- 65;
::Lewd.Const.AnalT3MasoTierBonus <- 5;
::Lewd.Const.AnalT3KamikazePleasure <- 10; // bonus pleasure to target if user climaxes

// --- Feet Skill Tiers --- (high fatigue cost is the tradeoff for being safe)
::Lewd.Const.FeetT1AP <- 4;
::Lewd.Const.FeetT1Fatigue <- 12;
::Lewd.Const.FeetT1BasePleasure <- 4;
::Lewd.Const.FeetT1SelfPleasure <- 0;
::Lewd.Const.FeetT1HeelSkillScale <- 0.1;
::Lewd.Const.FeetT1BaseHitChance <- 40;

::Lewd.Const.FeetT2AP <- 4;
::Lewd.Const.FeetT2Fatigue <- 18;
::Lewd.Const.FeetT2BasePleasure <- 7;
::Lewd.Const.FeetT2SelfPleasure <- 0;
::Lewd.Const.FeetT2HeelSkillScale <- 0.12;
::Lewd.Const.FeetT2BaseHitChance <- 55;
::Lewd.Const.FeetT2MountBonus <- 3;

::Lewd.Const.FeetT3AP <- 4;
::Lewd.Const.FeetT3Fatigue <- 22;
::Lewd.Const.FeetT3BasePleasure <- 11;
::Lewd.Const.FeetT3SelfPleasure <- 0;
::Lewd.Const.FeetT3HeelSkillScale <- 0.15;
::Lewd.Const.FeetT3HeelHeightScale <- 0.5;
::Lewd.Const.FeetT3BaseHitChance <- 65;
::Lewd.Const.FeetT3MountBonus <- 5;
::Lewd.Const.FeetT3MelDefDebuff <- -3;
::Lewd.Const.FeetT3DebuffDuration <- 1;

// --- Trait Perk Point Grants ---
::Lewd.Const.PerkPointsFromDainty <- 1;
::Lewd.Const.PerkPointsFromDelicate <- 2;
::Lewd.Const.PerkPointsFromEthereal <- 3;

// --- Perk Constants ---
::Lewd.Const.SensualFocusPleasureMult <- 1.1; // +10% pleasure dealt
::Lewd.Const.AlluringPresenceAllure <- 5;
::Lewd.Const.AlluringPresencePleasureMax <- 0;
::Lewd.Const.OrgasmThresholdAlluringPresence <- 1;
::Lewd.Const.AlluringPresenceAuraPleasure <- 3; // pleasure to adjacent enemies per turn / on move adjacent
::Lewd.Const.AlluringPresenceHitBonus <- 15; // +15% hit chance on first sex ability use per turn
::Lewd.Const.SensualFocusOpenInvitationMult <- 1.25; // +25% additional pleasure when Open Invitation active (stacks with base 10%)
::Lewd.Const.PracticedControlReflectionMult <- 0.5; // -50% self-pleasure (reflection) from sex abilities
::Lewd.Const.PracticedControlFatigueMult <- 0.75; // -25% fatigue cost on sex abilities
::Lewd.Const.InsatiableAPGain <- 3; // AP gained when actively bringing someone to climax
::Lewd.Const.InsatiableMaxTriggersPerTurn <- 1; // max AP grants per turn (0 = unlimited)
::Lewd.Const.EmbracePainPleasureMax <- 0;
::Lewd.Const.EmbracePainSexDamageFatigueRestore <- 2; // fatigue recovered per HP of sexual damage taken (e.g. anal)
::Lewd.Const.EmbracePainFatiguePerHit <- 3; // fatigue recovered per hit taken
::Lewd.Const.WillingVictimAllure <- 10; // while grappled/mounted (was 5)
::Lewd.Const.WillingVictimPleasureMax <- 5; // unconditional PleasureMax from mental resilience
::Lewd.Const.WillingVictimCounterPleasure <- 5; // pleasure dealt back to enemy when they sex you
::Lewd.Const.WillingVictimAIPriority <- 0.8; // AI targeting bonus for willing victim targets
::Lewd.Const.PliantBodyReflectionMult <- 1.5; // +50% pleasure reflection dealt to attacker when they sex you
::Lewd.Const.PliantBodyFatigueDrain <- 5; // fatigue added to mounter per turn while mounting you
::Lewd.Const.PliantBodyFatigueRecovery <- 5; // fatigue recovered when an enemy uses a sex ability on you
::Lewd.Const.PliantBodyFatigueMult <- 0.75; // 25% reduced fatigue cost on your own sex abilities
::Lewd.Const.PainFeedsPleasureMult <- 2.0; // masochism damage-to-pleasure +100%
::Lewd.Const.PainFeedsPleasureInjuryMult <- 1.33; // +33% injury threshold
::Lewd.Const.PainFeedsPleasureDamageReductionMult <- 0.8; // 20% damage reduction (multiplicative)
::Lewd.Const.ShamelessClimaxPleasure <- 10; // pleasure dealt to sex partner on own climax
::Lewd.Const.TranscendenceClimaxAllure <- 10; // allure bonus during Climax (replaces penalties)

// --- Horny Effect ---
::Lewd.Const.HornyDuration <- 2;
::Lewd.Const.HornyApplyChance <- 50;      // % on sex ability hit
::Lewd.Const.HornyResolvePenalty <- -15;
::Lewd.Const.HornyInitiativeMult <- 0.85; // -15%
::Lewd.Const.HornyMeleeDefPenalty <- -5;
::Lewd.Const.HornyDamageRemoveThreshold <- 10;

// --- Dom/Sub System ---
::Lewd.Const.DomSubCap <- 30;
::Lewd.Const.DomSubTier2 <- 10;
::Lewd.Const.DomSubTier3 <- 20;
::Lewd.Const.DomSubTier4 <- 30;

// Sub score -> PleasureMax bonus (more used to it = higher threshold)
::Lewd.Const.SubScorePleasureMaxScale <- 0.5; // PleasureMax += floor(subScore * this)

// Embrace Pain: chance to make attacker horny on hit
::Lewd.Const.EmbracePainHornyBaseChance <- 25; // base % chance per hit
::Lewd.Const.EmbracePainHornySubScale <- 2; // +this% per sub score point

// Surrender to Pleasure
::Lewd.Const.SurrenderToPleasureMinAP <- 1; // minimum AP to use
::Lewd.Const.SurrenderToPleasureFatigueCost <- 10;
::Lewd.Const.SurrenderToPleasureSubThreshold <- 5; // sub score needed (abs value)
// Scaling: bonus = (apSpent * subScore) / divisor
// 4 AP * 30 sub / 90 = 1.33 (133% bonus) -> 2.33x mounter self-pleasure
// 9 AP * 30 sub / 90 = 3.0 (300% bonus) -> 4.0x mounter self-pleasure
::Lewd.Const.SurrenderToPleasureMounterDivisor <- 90.0; // full scaling divisor
::Lewd.Const.SurrenderToPleasureSelfDivisor <- 180.0; // half scaling, self-vulnerability

// Mounted defensive bonuses (sub-gated)
::Lewd.Const.MountedSubResolveScale <- 0.5; // Resolve += floor(subScore * this)
::Lewd.Const.MountedSubRangedDefScale <- 0.3; // RangedDef += floor(subScore * this)

// Hands dom scaling (bonus pleasure per dom point, per tier)
::Lewd.Const.HandsT1DomScale <- 0.15;
::Lewd.Const.HandsT2DomScale <- 0.2;
::Lewd.Const.HandsT3DomScale <- 0.25;

// Anal sub scaling (bonus pleasure per sub point, per tier)
::Lewd.Const.AnalT1SubScale <- 0.3;
::Lewd.Const.AnalT2SubScale <- 0.4;
::Lewd.Const.AnalT3SubScale <- 0.5;

// --- Male Sex Abilities ---
::Lewd.Const.MaleGropeAP <- 3;
::Lewd.Const.MaleGropeFatigue <- 8;
::Lewd.Const.MaleGropeBasePleasure <- 4;
::Lewd.Const.MaleGropeMeleeSkillScale <- 0.06;
::Lewd.Const.MaleGropeBaseHitChance <- 25;

::Lewd.Const.MaleForceOralAP <- 5;
::Lewd.Const.MaleForceOralFatigue <- 15;
::Lewd.Const.MaleForceOralBasePleasure <- 1; // minimal — being forced isn't pleasurable
::Lewd.Const.MaleForceOralMeleeSkillScale <- 0.0; // no scaling to target
::Lewd.Const.MaleForceOralBaseHitChance <- 25;
::Lewd.Const.MaleForceOralResolveDebuff <- -5;
::Lewd.Const.MaleForceOralSelfPleasure <- 4; // base self-pleasure (being sucked)
::Lewd.Const.MaleForceOralOralMasteryScale <- 0.06; // bonus per target oral mastery point

// Male Penetrate (Vaginal) — easier, cheaper
::Lewd.Const.MalePenetrateVaginalAP <- 5;
::Lewd.Const.MalePenetrateVaginalFatigue <- 18;
::Lewd.Const.MalePenetrateVaginalBasePleasure <- 12;
::Lewd.Const.MalePenetrateVaginalMeleeSkillScale <- 0.12;
::Lewd.Const.MalePenetrateVaginalBaseHitChance <- 25;
::Lewd.Const.MalePenetrateVaginalMountedHitBonus <- 20;
::Lewd.Const.MalePenetrateVaginalMountedPleasureBonus <- 4;
::Lewd.Const.MalePenetrateVaginalSelfPleasure <- 6;

// Male Penetrate (Anal) — rougher, harder
::Lewd.Const.MalePenetrateAnalAP <- 6;
::Lewd.Const.MalePenetrateAnalFatigue <- 22;
::Lewd.Const.MalePenetrateAnalBasePleasure <- 9;
::Lewd.Const.MalePenetrateAnalMeleeSkillScale <- 0.10;
::Lewd.Const.MalePenetrateAnalBaseHitChance <- 25;
::Lewd.Const.MalePenetrateAnalMountedHitBonus <- 20;
::Lewd.Const.MalePenetrateAnalMountedPleasureBonus <- 4;
::Lewd.Const.MalePenetrateAnalSelfPleasure <- 2;
::Lewd.Const.MalePenetrateAnalMasoTierBonus <- 3;

// --- Horny AI ---
::Lewd.Const.HornyAIScore <- 400;
::Lewd.Const.HornyAIEngageScore <- 120;
::Lewd.Const.HornyAIEngageAllurePerTile <- 10; // allure penalty per tile of distance when scoring targets
::Lewd.Const.HornyAIEngageAllureNorm <- 30.0; // normalizer — 30 adjusted allure = 1.0x score
::Lewd.Const.AIBehaviorIDHorny <- 0; // set dynamically in mod_lewd.nut via Const.AI.Behavior.ID.COUNT
::Lewd.Const.AIBehaviorIDHornyEngage <- 0; // set dynamically in mod_lewd.nut via Const.AI.Behavior.ID.COUNT

// --- Piledriver (Unhold Boss) ---
::Lewd.Const.AIBehaviorIDPiledriver <- 0; // set dynamically in mod_lewd.nut via Const.AI.Behavior.ID.COUNT
::Lewd.Const.PiledriverAIScore <- 5000; // must outbid ai_horny which can score 2000+

// --- AI Continuation ---
::Lewd.Const.AIContinuationMap <- {
	vaginal = "actives.male_penetrate_vaginal",
	anal = "actives.male_penetrate_anal",
	oral = "actives.male_force_oral"
	// hands, feet — no preferred continuation
};
::Lewd.Const.AIContinuationChance <- 80; // % chance AI follows continuation instead of normal selection
::Lewd.Const.OpenInvitationReceivedPleasureMult <- 1.25; // +25% pleasure received from enemy sex abilities
::Lewd.Const.OpenInvitationAIPriority <- 2.0; // massive AI targeting bonus for Open Invitation targets

// --- Cum Facial Chances (% per sex type when male climaxes) ---
::Lewd.Const.CumFacialChanceOral <- 75;
::Lewd.Const.CumFacialChanceHands <- 50;
::Lewd.Const.CumFacialChanceVaginal <- 25;
::Lewd.Const.CumFacialChanceAnal <- 25;
::Lewd.Const.CumFacialChanceFeet <- 50;
::Lewd.Const.CumFacialChanceDefault <- 20;

// --- Enemy PleasureMax ---
::Lewd.Const.PleasureMaxBase <- 20;
::Lewd.Const.PleasureMaxResolveScale <- 0.5; // PleasureMax = base + Resolve * this

// --- Orgasm Defeat ---
::Lewd.Const.OrgasmDefeatEnabled <- true;
// Common base for all entities
::Lewd.Const.OrgasmThresholdBase <- 1;
::Lewd.Const.OrgasmThresholdResolveDivisor <- 40;  // +1 per 40 Resolve
::Lewd.Const.OrgasmThresholdHPDivisor <- 200; // +1 per 200 max HP

// Enemy-specific bonuses
::Lewd.Const.OrgasmThresholdMinibossBonus <- 2;
::Lewd.Const.OrgasmThresholdOrcBonus <- 1;

// --- Mount AP Discount ---
::Lewd.Const.MountedAPDiscount <- 1; // AP reduction for vaginal/anal when already mounted with target

// Player lewd trait bonuses (additive on top of common base)
::Lewd.Const.OrgasmThresholdDainty <- 1;
::Lewd.Const.OrgasmThresholdDelicate <- 2;
::Lewd.Const.OrgasmThresholdEthereal <- 3;
::Lewd.Const.OrgasmThresholdMasochismFirst <- 0;
::Lewd.Const.OrgasmThresholdMasochismSecond <- 0;
::Lewd.Const.OrgasmThresholdMasochismThird <- 1;

// Perk bonuses
::Lewd.Const.OrgasmThresholdPracticedControl <- 1;
::Lewd.Const.OrgasmThresholdTranscendence <- 1;
::Lewd.Const.OrgasmThresholdWillingVictim <- 1;
::Lewd.Const.OrgasmThresholdInsatiable <- 2;

// Drained Trait Tiers (consequence of succubus draining)
// Tier 1: Sapped
::Lewd.Const.DrainedFirstXPMult <- 0.85;       // -15% XP gain
::Lewd.Const.DrainedFirstMeleeSkill <- -3;
::Lewd.Const.DrainedFirstRangedSkill <- -3;
::Lewd.Const.DrainedFirstHitpoints <- 5;
::Lewd.Const.DrainedFirstBravery <- 5;
::Lewd.Const.DrainedFirstDailyWageMult <- 0.90; // -10% salary
// Tier 2: Drained
::Lewd.Const.DrainedSecondXPMult <- 0.65;      // -35% XP gain
::Lewd.Const.DrainedSecondMeleeSkill <- -7;
::Lewd.Const.DrainedSecondRangedSkill <- -7;
::Lewd.Const.DrainedSecondHitpoints <- 10;
::Lewd.Const.DrainedSecondBravery <- 10;
::Lewd.Const.DrainedSecondDailyWageMult <- 0.75; // -25% salary
// Tier 3: Enthralled (works for free, barely learns, but extremely tough and fearless)
::Lewd.Const.DrainedThirdXPMult <- 0.60;       // -40% XP gain
::Lewd.Const.DrainedThirdMeleeSkill <- -20;
::Lewd.Const.DrainedThirdRangedSkill <- -20;
::Lewd.Const.DrainedThirdHitpoints <- 30;
::Lewd.Const.DrainedThirdBravery <- 30;
::Lewd.Const.DrainedThirdDailyWageMult <- 0.0;   // -100% salary

// Ethereal Stat Absorption: gain +1 stat when causing enemy climax (if enemy's base > yours)
::Lewd.Const.EtherealStatAbsorptionEnabled <- true;
::Lewd.Const.EtherealStatAbsorptionMinTier <- 3; // minimum lewd tier required (3 = Ethereal)

// Drain Hunger Event (world event: succubus drains an ally)
::Lewd.Const.DrainHungerCooldownDays <- 7;
::Lewd.Const.DrainHungerBaseScore <- 100;
::Lewd.Const.DrainHungerAllureScale <- 2.0;     // score += allure * this

// Ethereal Progression Event Thresholds
::Lewd.Const.EtherealFirstEventThreshold <- 20;   // combined climaxes (self + partner) for foreshadowing
::Lewd.Const.EtherealSecondEventThreshold <- 40;  // combined climaxes for awakening
::Lewd.Const.EtherealFirstEventBaseScore <- 10;
::Lewd.Const.EtherealSecondEventBaseScore <- 15;

// Ethereal Quest Chain
::Lewd.Const.EtherealQuestClimaxThreshold <- 80;  // combined climaxes to trigger gheist encounter
::Lewd.Const.EtherealQuestSpawnMinDist <- 5;       // min tile distance for quest locations
::Lewd.Const.EtherealQuestSpawnMaxDist <- 10;      // max tile distance for quest locations

// Tail Growth Event
::Lewd.Const.TailGrowthEventThreshold <- 120;     // combined climaxes (self + partner) needed
::Lewd.Const.TailGrowthEventBaseScore <- 100;
::Lewd.Const.TailGrowthEventClimaxScale <- 5;      // score per climax over threshold
::Lewd.Const.TailGrowthEventCooldownDays <- 7;    // cooldown if rejected (event re-fires)

// --- Flight Awakening Event ---
::Lewd.Const.FlightEventThreshold <- 350;          // combined climaxes needed (higher than tail at 120)
::Lewd.Const.FlightEventBaseScore <- 80;
::Lewd.Const.FlightEventClimaxScale <- 3;

// --- Flight Skill ---
::Lewd.Const.FlightAP <- 3;
::Lewd.Const.FlightFatigue <- 15;
::Lewd.Const.FlightMinRange <- 1;
::Lewd.Const.FlightMaxRange <- 4;
::Lewd.Const.FlightMaxLevelDifference <- 4;
::Lewd.Const.FlightFadeOutDuration <- 350;
::Lewd.Const.FlightFadeInDuration <- 400;

// --- Tail Whip Weapon ---
::Lewd.Const.TailBaseDamageMin <- 10;
::Lewd.Const.TailBaseDamageMax <- 20;
::Lewd.Const.TailAllureDamageScale <- 0.5;         // bonus damage = floor(allure * this)
::Lewd.Const.TailArmorDamageMult <- 0.3;            // weak vs armor
::Lewd.Const.TailDirectDamageMultBase <- 0.2;       // base direct damage mult
::Lewd.Const.TailDirectDamageMultBonus <- 0.5;      // asymptotic bonus from climaxes (caps at 70%)
::Lewd.Const.TailDirectDamageClimaxHalf <- 50;      // climaxes needed for half of bonus (higher = slower scaling)
::Lewd.Const.TailHeadHitChanceBonus <- 30;          // asymptotic bonus to head hit chance from climaxes
::Lewd.Const.TailHeadHitClimaxHalf <- 40;           // climaxes needed for half of head hit bonus
::Lewd.Const.TailPleasureScale <- 0.05;             // pleasure dealt = floor(allure * this)
::Lewd.Const.TailHornyChance <- 20;                 // % chance to inflict horny on hit

// Tail Lash (attack ability)
::Lewd.Const.TailLashAP <- 4;
::Lewd.Const.TailLashFatigue <- 10;

// Whip Into Shape (ally morale ability)
::Lewd.Const.WhipIntoShapeAP <- 3;
::Lewd.Const.WhipIntoShapeFatigue <- 8;
::Lewd.Const.WhipIntoShapeHornyChance <- 15;        // % chance to make ally horny

// Playful Slap (low damage, high horny chance on enemies)
::Lewd.Const.PlayfulSlapAP <- 3;
::Lewd.Const.PlayfulSlapFatigue <- 5;
::Lewd.Const.PlayfulSlapBaseDamage <- 3;
::Lewd.Const.PlayfulSlapBaseDamageMax <- 8;
::Lewd.Const.PlayfulSlapHornyBaseChance <- 40;      // base % chance
::Lewd.Const.PlayfulSlapHornyAllureScale <- 0.5;    // + floor(allure * this) %
::Lewd.Const.PlayfulSlapHornyMaxChance <- 85;       // capped

// Hexen Curse / Male-to-Female Transformation
::Lewd.Const.HexenTransformFirstBaseScore <- 150;
::Lewd.Const.HexenTransformSecondBaseScore <- 200;

// --- Debauchery Perk Constants ---
::Lewd.Const.ExploitWeaknessArmorDamageMult <- 1.25; // +25% damage to armor vs female targets
::Lewd.Const.BrutalForcePleasureMult <- 1.25; // +25% pleasure dealt by male sex abilities
::Lewd.Const.BrutalForceOrgasmThreshold <- 1; // +1 orgasm threshold for perk owner
::Lewd.Const.ConquerorDomBonus <- 2; // bonus Dom score per enemy climax caused
::Lewd.Const.ConquerorMountedResolvePenalty <- -10; // additional Resolve penalty on mounted targets
::Lewd.Const.ConquerorFatigueRestorePct <- 0.5; // restore 50% of max fatigue on causing climax

// --- Restrain (Iron Grip) ---
::Lewd.Const.RestrainAP <- 2;
::Lewd.Const.RestrainFatigue <- 8;
::Lewd.Const.RestrainedMeleeDefPenalty <- -10;
::Lewd.Const.RestrainedRangedDefPenalty <- -10;
::Lewd.Const.RestrainedPleasureVulnerability <- 1.25; // +25% pleasure received
::Lewd.Const.RestrainedBreakFreeBaseChance <- -10; // harder than net (net is meleeSkill - 10)

// --- Allied Harassment Escalation ---
::Lewd.Const.AlliedForceOralAP <- 5;
::Lewd.Const.AlliedForceOralFatigue <- 12;
::Lewd.Const.AlliedForceOralBasePleasure <- 1;

::Lewd.Const.AlliedPenetrateVaginalAP <- 5;
::Lewd.Const.AlliedPenetrateVaginalFatigue <- 15;
::Lewd.Const.AlliedPenetrateVaginalBasePleasure <- 10;
::Lewd.Const.AlliedPenetrateVaginalMeleeSkillScale <- 0.08;

::Lewd.Const.AlliedPenetrateAnalAP <- 5;
::Lewd.Const.AlliedPenetrateAnalFatigue <- 18;
::Lewd.Const.AlliedPenetrateAnalBasePleasure <- 7;
::Lewd.Const.AlliedPenetrateAnalMeleeSkillScale <- 0.06;

::Lewd.Const.HarassmentEscalateBaseChance <- 20;
::Lewd.Const.HarassmentEscalateAllureScale <- 0.5;
::Lewd.Const.HarassmentEscalateResolveScale <- 0.5;

// --- Male Mastery System ---

// Grope mastery (Wandering Hands perk)
::Lewd.Const.MaleMasteryLimitGrope <- 60;
::Lewd.Const.MaleMasteryGropeT2 <- 15;
::Lewd.Const.MaleMasteryGropeT3 <- 40;
::Lewd.Const.MaleMasteryGropeHitThreshold <- 8;
::Lewd.Const.MaleMasteryGropeHitBonus <- 5;
::Lewd.Const.MaleMasteryGropePleasureThreshold <- 25;
::Lewd.Const.MaleMasteryGropePleasureBonus <- 2;
::Lewd.Const.MaleMasteryGropeHitT3Threshold <- 50;
::Lewd.Const.MaleMasteryGropeHitT3Bonus <- 5;

// Penetration mastery (Carnal Knowledge perk) — tracks vaginal + force oral
::Lewd.Const.MaleMasteryLimitPenetration <- 80;
::Lewd.Const.MaleMasteryPenetrationT2 <- 20;
::Lewd.Const.MaleMasteryPenetrationT3 <- 55;
::Lewd.Const.MaleMasteryPenetrationPleasureThreshold <- 10;
::Lewd.Const.MaleMasteryPenetrationPleasureBonus <- 3;
::Lewd.Const.MaleMasteryPenetrationHitThreshold <- 35;
::Lewd.Const.MaleMasteryPenetrationHitBonus <- 5;
::Lewd.Const.MaleMasteryPenetrationAPThreshold <- 65;
::Lewd.Const.MaleMasteryPenetrationAPBonus <- -1;

// Anal mastery (Forced Entry perk)
::Lewd.Const.MaleMasteryLimitAnal <- 80;
::Lewd.Const.MaleMasteryAnalT2 <- 25;
::Lewd.Const.MaleMasteryAnalT3 <- 60;
::Lewd.Const.MaleMasteryAnalHitThreshold <- 10;
::Lewd.Const.MaleMasteryAnalHitBonus <- 5;
::Lewd.Const.MaleMasteryAnalPleasureThreshold <- 40;
::Lewd.Const.MaleMasteryAnalPleasureBonus <- 3;
::Lewd.Const.MaleMasteryAnalAPThreshold <- 70;
::Lewd.Const.MaleMasteryAnalAPBonus <- -1;

// --- Succubus Perk Tree ---
::Lewd.Const.PredatoryInstinctHitBonus <- 10;         // +10% hit vs Horny
::Lewd.Const.PredatoryInstinctDamageMult <- 1.15;     // +15% damage vs Horny

::Lewd.Const.EssenceFeedRange <- 2;                   // tile range
::Lewd.Const.EssenceFeedAllurePerHorny <- 3;
::Lewd.Const.EssenceFeedInitiativePerHorny <- 5;
::Lewd.Const.EssenceFeedResolvePerHorny <- 3;

::Lewd.Const.SoulHarvestClimaxHealPct <- 0.10;        // 10% of target PleasureMax
::Lewd.Const.SoulHarvestKillHealPct <- 0.10;          // 10% of target max HP

::Lewd.Const.UnquenchableAllurePerClimax <- 3;