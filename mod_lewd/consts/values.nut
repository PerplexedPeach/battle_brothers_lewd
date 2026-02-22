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