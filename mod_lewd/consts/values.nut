// --- Character Properties ---
::Const.CharacterProperties.Allure <- 0;
::Const.CharacterProperties.PleasureMax <- 0;
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
::Lewd.Const.AllureFromMasochismFirst <- 5;
::Lewd.Const.AllureFromMasochismSecond <- 10;
::Lewd.Const.AllureFromMasochismThird <- 15;
::Lewd.Const.AllureFromGluttonous <- -5;
::Lewd.Const.AllureFromFat <- -20;
::Lewd.Const.AllureFromAiling <- -10;
::Lewd.Const.AllureFromOld <- -20;
::Lewd.Const.AllureMeleeDefenseMultiplier <- 0.5;

// --- Pleasure & Climax Constants ---
::Lewd.Const.PleasureMaxFromDainty <- 30;
::Lewd.Const.PleasureMaxFromDelicate <- 50;
::Lewd.Const.PleasureMaxFromMasochismFirst <- 10;
::Lewd.Const.PleasureMaxFromMasochismSecond <- 20;
::Lewd.Const.PleasureMaxFromMasochismThird <- 30;
::Lewd.Const.PleasureFromDamageMasochismFirst <- 0.1;
::Lewd.Const.PleasureFromDamageMasochismSecond <- 0.2;
::Lewd.Const.PleasureFromDamageMasochismThird <- 0.3;
::Lewd.Const.ClimaxDuration <- 2;
::Lewd.Const.ClimaxAPPenalty <- -2;
::Lewd.Const.ClimaxMeleeDefensePenalty <- -10;
::Lewd.Const.ClimaxInitiativePenalty <- -15;
::Lewd.Const.ClimaxResolveBonus <- 10;
::Lewd.Const.ClimaxAllureBonus <- 5;

// ability constants
::Lewd.Const.AllureToDazeBaseChance <- 60;
::Lewd.Const.AllureToDazeChanceMultiplier <- 2;
::Lewd.Const.AllureToDazeDistancePenalty <- 10; // daze chance is reduced by this much for every tile of distance from the target

::Lewd.Const.SeduceBaseChance <- 50;
::Lewd.Const.SeduceAllureChanceMultiplier <- 3;
::Lewd.Const.SeduceAllureBaseline <- 20; // compare against resolve - baseline
::Lewd.Const.SeduceDistancePenalty <- 3;

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
::Lewd.Const.PheromonesDuration <- 2; // turns
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
::Lewd.Const.MasteryLimitAnal <- 80;
::Lewd.Const.MasteryLimitFeet <- 100;

// mastery tier thresholds
::Lewd.Const.MasteryOralT2 <- 30;
::Lewd.Const.MasteryOralT3 <- 70;
::Lewd.Const.MasteryHandsT2 <- 20;
::Lewd.Const.MasteryHandsT3 <- 50;
::Lewd.Const.MasteryVaginalT2 <- 30;
::Lewd.Const.MasteryVaginalT3 <- 80;
::Lewd.Const.MasteryAnalT2 <- 20;
::Lewd.Const.MasteryAnalT3 <- 55;
::Lewd.Const.MasteryFeetT2 <- 25;
::Lewd.Const.MasteryFeetT3 <- 60;

// mastery passive bonus thresholds (body part: [threshold, ...])
// Oral: 15: -3 fatigue, 50: +3 pleasure dealt, 90: +5 Resolve
::Lewd.Const.MasteryOralFatigueThreshold <- 15;
::Lewd.Const.MasteryOralFatigueBonus <- -3;
::Lewd.Const.MasteryOralPleasureThreshold <- 50;
::Lewd.Const.MasteryOralPleasureBonus <- 3;
::Lewd.Const.MasteryOralResolveThreshold <- 90;
::Lewd.Const.MasteryOralResolveBonus <- 5;

// Hands: 10: +5% hit, 35: +2 pleasure dealt, 70: -1 AP
::Lewd.Const.MasteryHandsHitThreshold <- 10;
::Lewd.Const.MasteryHandsHitBonus <- 5;
::Lewd.Const.MasteryHandsPleasureThreshold <- 35;
::Lewd.Const.MasteryHandsPleasureBonus <- 2;
::Lewd.Const.MasteryHandsAPThreshold <- 70;
::Lewd.Const.MasteryHandsAPBonus <- -1;

// Vaginal: 20: -25% self-pleasure, 50: +4 pleasure dealt, 110: -2 fatigue
::Lewd.Const.MasteryVaginalSelfPleasureThreshold <- 20;
::Lewd.Const.MasteryVaginalSelfPleasureMult <- 0.75;
::Lewd.Const.MasteryVaginalPleasureThreshold <- 50;
::Lewd.Const.MasteryVaginalPleasureBonus <- 4;
::Lewd.Const.MasteryVaginalFatigueThreshold <- 110;
::Lewd.Const.MasteryVaginalFatigueBonus <- -2;

// Anal: 10: -20% self-pleasure, 35: +3 pleasure dealt, 70: climax splash
::Lewd.Const.MasteryAnalSelfPleasureThreshold <- 10;
::Lewd.Const.MasteryAnalSelfPleasureMult <- 0.8;
::Lewd.Const.MasteryAnalPleasureThreshold <- 35;
::Lewd.Const.MasteryAnalPleasureBonus <- 3;
::Lewd.Const.MasteryAnalSplashThreshold <- 70;

// Feet: 15: -2 fatigue, 40: +2 pleasure dealt, 85: ignore 20% Resolve
::Lewd.Const.MasteryFeetFatigueThreshold <- 15;
::Lewd.Const.MasteryFeetFatigueBonus <- -2;
::Lewd.Const.MasteryFeetPleasureThreshold <- 40;
::Lewd.Const.MasteryFeetPleasureBonus <- 2;
::Lewd.Const.MasteryFeetResolveIgnoreThreshold <- 85;
::Lewd.Const.MasteryFeetResolveIgnorePct <- 0.2;

// --- Sex Ability Constants ---
// universal allure scaling for pleasure dealt
::Lewd.Const.SexAllurePleasureScale <- 0.1; // floor(allure * this) added to pleasure dealt

// hit chance formula: baseChance + (userAllure - targetResolve) * multiplier, clamped 5-95
::Lewd.Const.SexHitChanceAllureResolveScale <- 2;
::Lewd.Const.SexHitChanceMin <- 5;
::Lewd.Const.SexHitChanceMax <- 95;

// fatigue vulnerability: floor(targetFatiguePct * this) bonus pleasure
::Lewd.Const.SexFatigueVulnerabilityBonus <- 5;

// --- Mount System ---
::Lewd.Const.MountDuration <- 3;
::Lewd.Const.MountMeleeDefPenalty <- -8;
::Lewd.Const.MountInitiativeMult <- 0.8; // 20% Initiative reduction
::Lewd.Const.MountPleasureVulnerability <- 1.25; // 25% more pleasure taken while mounted

// --- Oral Skill Tiers ---
::Lewd.Const.OralT1AP <- 5;
::Lewd.Const.OralT1Fatigue <- 12;
::Lewd.Const.OralT1BasePleasure <- 6;
::Lewd.Const.OralT1SelfPleasure <- 0;
::Lewd.Const.OralT1SelfPleasureChance <- 20; // 20% chance of 2 self-pleasure
::Lewd.Const.OralT1SelfPleasureAmount <- 2;
::Lewd.Const.OralT1ResolveScale <- 0.08;
::Lewd.Const.OralT1AllureScale <- 0.05; // bonus allure scaling (they see your face)
::Lewd.Const.OralT1BaseHitChance <- 60;

::Lewd.Const.OralT2AP <- 5;
::Lewd.Const.OralT2Fatigue <- 15;
::Lewd.Const.OralT2BasePleasure <- 10;
::Lewd.Const.OralT2SelfPleasure <- 0;
::Lewd.Const.OralT2ResolveScale <- 0.12;
::Lewd.Const.OralT2AllureScale <- 0.08;
::Lewd.Const.OralT2BaseHitChance <- 75;
::Lewd.Const.OralT2MountBonus <- 4;

::Lewd.Const.OralT3AP <- 6;
::Lewd.Const.OralT3Fatigue <- 20;
::Lewd.Const.OralT3BasePleasure <- 16;
::Lewd.Const.OralT3SelfPleasure <- 3;
::Lewd.Const.OralT3ResolveScale <- 0.15;
::Lewd.Const.OralT3AllureScale <- 0.12;
::Lewd.Const.OralT3BaseHitChance <- 85;
::Lewd.Const.OralT3MountBonus <- 6;
::Lewd.Const.OralT3ResolveDebuff <- -5;
::Lewd.Const.OralT3DebuffDuration <- 1;

// --- Hands Skill Tiers ---
::Lewd.Const.HandsT1AP <- 3;
::Lewd.Const.HandsT1Fatigue <- 8;
::Lewd.Const.HandsT1BasePleasure <- 4;
::Lewd.Const.HandsT1SelfPleasure <- 0;
::Lewd.Const.HandsT1MeleeSkillScale <- 0.06;
::Lewd.Const.HandsT1BaseHitChance <- 60;

::Lewd.Const.HandsT2AP <- 4;
::Lewd.Const.HandsT2Fatigue <- 10;
::Lewd.Const.HandsT2BasePleasure <- 8;
::Lewd.Const.HandsT2SelfPleasure <- 0;
::Lewd.Const.HandsT2MeleeSkillScale <- 0.1;
::Lewd.Const.HandsT2BaseHitChance <- 75;
::Lewd.Const.HandsT2MountBonus <- 3;

::Lewd.Const.HandsT3AP <- 4;
::Lewd.Const.HandsT3Fatigue <- 12;
::Lewd.Const.HandsT3BasePleasure <- 13;
::Lewd.Const.HandsT3SelfPleasure <- 0;
::Lewd.Const.HandsT3MeleeSkillScale <- 0.14;
::Lewd.Const.HandsT3BaseHitChance <- 85;
::Lewd.Const.HandsT3MountBonus <- 5;
::Lewd.Const.HandsT3InitDebuff <- -5;
::Lewd.Const.HandsT3DebuffDuration <- 1;

// --- Vaginal Skill Tiers ---
::Lewd.Const.VaginalT1AP <- 6;
::Lewd.Const.VaginalT1Fatigue <- 18;
::Lewd.Const.VaginalT1BasePleasure <- 10;
::Lewd.Const.VaginalT1SelfPleasure <- 5;
::Lewd.Const.VaginalT1InitiativeScale <- 0.06;
::Lewd.Const.VaginalT1BaseHitChance <- 60;

::Lewd.Const.VaginalT2AP <- 5;
::Lewd.Const.VaginalT2Fatigue <- 15;
::Lewd.Const.VaginalT2BasePleasure <- 14;
::Lewd.Const.VaginalT2SelfPleasure <- 6;
::Lewd.Const.VaginalT2InitiativeScale <- 0.1;
::Lewd.Const.VaginalT2BaseHitChance <- 75;

::Lewd.Const.VaginalT3AP <- 5;
::Lewd.Const.VaginalT3Fatigue <- 18;
::Lewd.Const.VaginalT3BasePleasure <- 20;
::Lewd.Const.VaginalT3SelfPleasure <- 8;
::Lewd.Const.VaginalT3InitiativeScale <- 0.14;
::Lewd.Const.VaginalT3BaseHitChance <- 100; // auto-success
::Lewd.Const.VaginalT3APDebuff <- -2;
::Lewd.Const.VaginalT3DebuffDuration <- 1;

// --- Anal Skill Tiers ---
::Lewd.Const.AnalT1AP <- 5;
::Lewd.Const.AnalT1Fatigue <- 15;
::Lewd.Const.AnalT1BasePleasure <- 8;
::Lewd.Const.AnalT1SelfPleasure <- 8;
::Lewd.Const.AnalT1SelfDamage <- 4; // HP damage to self
::Lewd.Const.AnalT1BaseHitChance <- 60;

::Lewd.Const.AnalT2AP <- 4;
::Lewd.Const.AnalT2Fatigue <- 12;
::Lewd.Const.AnalT2BasePleasure <- 12;
::Lewd.Const.AnalT2SelfPleasure <- 10;
::Lewd.Const.AnalT2SelfDamage <- 6;
::Lewd.Const.AnalT2BaseHitChance <- 75;
::Lewd.Const.AnalT2MasoTierBonus <- 3; // bonus per maso tier

::Lewd.Const.AnalT3AP <- 5;
::Lewd.Const.AnalT3Fatigue <- 20;
::Lewd.Const.AnalT3BasePleasure <- 18;
::Lewd.Const.AnalT3SelfPleasure <- 15;
::Lewd.Const.AnalT3SelfDamage <- 10;
::Lewd.Const.AnalT3BaseHitChance <- 85;
::Lewd.Const.AnalT3MasoTierBonus <- 5;
::Lewd.Const.AnalT3KamikazePleasure <- 10; // bonus pleasure to target if user climaxes

// --- Feet Skill Tiers --- (high fatigue cost is the tradeoff for being safe)
::Lewd.Const.FeetT1AP <- 3;
::Lewd.Const.FeetT1Fatigue <- 12;
::Lewd.Const.FeetT1BasePleasure <- 4;
::Lewd.Const.FeetT1SelfPleasure <- 0;
::Lewd.Const.FeetT1HeelSkillScale <- 0.1;
::Lewd.Const.FeetT1BaseHitChance <- 60;

::Lewd.Const.FeetT2AP <- 4;
::Lewd.Const.FeetT2Fatigue <- 18;
::Lewd.Const.FeetT2BasePleasure <- 9;
::Lewd.Const.FeetT2SelfPleasure <- 0;
::Lewd.Const.FeetT2HeelSkillScale <- 0.15;
::Lewd.Const.FeetT2BaseHitChance <- 75;
::Lewd.Const.FeetT2MountBonus <- 3;

::Lewd.Const.FeetT3AP <- 5;
::Lewd.Const.FeetT3Fatigue <- 22;
::Lewd.Const.FeetT3BasePleasure <- 15;
::Lewd.Const.FeetT3SelfPleasure <- 0;
::Lewd.Const.FeetT3HeelSkillScale <- 0.2;
::Lewd.Const.FeetT3HeelHeightScale <- 0.5;
::Lewd.Const.FeetT3BaseHitChance <- 85;
::Lewd.Const.FeetT3MountBonus <- 5;
::Lewd.Const.FeetT3MelDefDebuff <- -3;
::Lewd.Const.FeetT3DebuffDuration <- 1;

// --- Perk Constants ---
::Lewd.Const.SensualFocusPleasureMult <- 1.1; // +10% pleasure dealt
::Lewd.Const.AlluringPresenceAllure <- 5;
::Lewd.Const.AlluringPresencePleasureMax <- 10;
::Lewd.Const.SensualFocusOpenInvitationMult <- 1.15; // +15% additional pleasure when Open Invitation active (stacks with base 10%)
::Lewd.Const.PracticedControlReflectionMult <- 0.5; // -50% self-pleasure (reflection) from sex abilities
::Lewd.Const.InsatiableAPGain <- 3; // AP gained when actively bringing someone to climax
::Lewd.Const.EmbracePainPleasureMax <- 5;
::Lewd.Const.EmbracePainFatigueRestore <- 1; // per self-pleasure point
::Lewd.Const.WillingVictimAllure <- 10; // while grappled/mounted (was 5)
::Lewd.Const.PliantBodyReflectionMult <- 1.5; // +50% pleasure reflection dealt to partner
::Lewd.Const.PainFeedsPleasureMult <- 1.5; // masochism damage-to-pleasure +50%
::Lewd.Const.PainFeedsPleasureInjuryMult <- 1.33; // +33% injury threshold
::Lewd.Const.ShamelessClimaxPleasure <- 10; // pleasure dealt to sex partner on own climax
::Lewd.Const.TranscendenceClimaxAllure <- 10; // allure bonus during Climax (replaces penalties)

// --- Horny Effect ---
::Lewd.Const.HornyDuration <- 2;
::Lewd.Const.HornyApplyChance <- 50;      // % on sex ability hit
::Lewd.Const.HornyResolvePenalty <- -15;
::Lewd.Const.HornyInitiativeMult <- 0.85; // -15%
::Lewd.Const.HornyMeleeDefPenalty <- -5;

// --- Dom/Sub System ---
::Lewd.Const.DomSubCap <- 30;
::Lewd.Const.DomSubTier2 <- 10;
::Lewd.Const.DomSubTier3 <- 20;
::Lewd.Const.DomSubTier4 <- 30;

// Hands dom scaling (bonus pleasure per dom point, per tier)
::Lewd.Const.HandsT1DomScale <- 0.15;
::Lewd.Const.HandsT2DomScale <- 0.2;
::Lewd.Const.HandsT3DomScale <- 0.25;

// Anal sub scaling (bonus pleasure per sub point, per tier)
::Lewd.Const.AnalT1SubScale <- 0.3;
::Lewd.Const.AnalT2SubScale <- 0.4;
::Lewd.Const.AnalT3SubScale <- 0.5;

// --- Enemy PleasureMax ---
::Lewd.Const.EnemyPleasureMaxBase <- 20;
::Lewd.Const.EnemyPleasureMaxResolveScale <- 1.0; // PleasureMax = base + Resolve * this