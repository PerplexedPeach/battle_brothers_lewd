::Lewd <- {
	ID = "mod_lewd",
	Version = "1.10.1",
	Name = "Lewdness",
	IsStartingNewCampaign = false
};

::Lewd.Const <- {};

// ::mods_registerMod(::Lewd.ID, ::Lewd.Version, ::Lewd.Name);
local mod = ::Hooks.register(::Lewd.ID, ::Lewd.Version, ::Lewd.Name);

mod.require("mod_legends", "mod_msu");

// ::mods_queue(modID, "mod_legends,mod_msu", function()
mod.queue(">mod_legends", ">mod_msu", ">mod_ROTUC", function()
{
	::Lewd.Mod <- ::MSU.Class.Mod(::Lewd.ID, ::Lewd.Version, ::Lewd.Name);

	::Lewd.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, "https://github.com/PerplexedPeach/battle_brothers_lewd");
	::Lewd.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

	::HasROTU <- ::Hooks.hasMod("mod_ROTUC");
	::HasRedCourt <- ::Hooks.hasMod("mod_LuftVampiresOrigin");

	// TODO registery for updates

	// includes in order
	foreach (dir in [
		"mod_lewd/consts"
	]) {
		foreach (file in ::IO.enumerateFiles(dir))
			::include(file);
	}

	// Register AI behavior IDs for horny behaviors
	local count = ::Const.AI.Behavior.ID.COUNT;
	::Const.AI.Behavior.ID.LewdHorny <- count++;
	::Const.AI.Behavior.ID.LewdHornyEngage <- count++;
	::Const.AI.Behavior.ID.LewdPiledriver <- count++;
	::Const.AI.Behavior.ID.LewdGoblinHorny <- count++;
	::Const.AI.Behavior.ID.LewdGoblinRestrain <- count++;
	::Const.AI.Behavior.ID.LewdHornyIdle <- count++;
	::Const.AI.Behavior.ID.LewdOrcClaim <- count++;
	::Const.AI.Behavior.ID.LewdOrcHorny <- count++;
	::Const.AI.Behavior.ID.LewdUnholdHorny <- count++;
	::Const.AI.Behavior.ID.LewdSpiderHorny <- count++;
	::Const.AI.Behavior.ID.LewdFemaleHorny <- count++;
	::Const.AI.Behavior.ID.LewdFemaleHornyEngage <- count++;
	::Const.AI.Behavior.ID.COUNT = count;
	::Const.AI.Behavior.Name.push("LewdHorny");
	::Const.AI.Behavior.Name.push("LewdHornyEngage");
	::Const.AI.Behavior.Name.push("LewdPiledriver");
	::Const.AI.Behavior.Name.push("LewdGoblinHorny");
	::Const.AI.Behavior.Name.push("LewdGoblinRestrain");
	::Const.AI.Behavior.Name.push("LewdHornyIdle");
	::Const.AI.Behavior.Name.push("LewdOrcClaim");
	::Const.AI.Behavior.Name.push("LewdOrcHorny");
	::Const.AI.Behavior.Name.push("LewdUnholdHorny");
	::Const.AI.Behavior.Name.push("LewdSpiderHorny");
	::Const.AI.Behavior.Name.push("LewdFemaleHorny");
	::Const.AI.Behavior.Name.push("LewdFemaleHornyEngage");
	::Lewd.Const.AIBehaviorIDHorny = ::Const.AI.Behavior.ID.LewdHorny;
	::Lewd.Const.AIBehaviorIDHornyEngage = ::Const.AI.Behavior.ID.LewdHornyEngage;
	::Lewd.Const.AIBehaviorIDPiledriver = ::Const.AI.Behavior.ID.LewdPiledriver;
	::Lewd.Const.AIBehaviorIDGoblinHorny = ::Const.AI.Behavior.ID.LewdGoblinHorny;
	::Lewd.Const.AIBehaviorIDGoblinRestrain = ::Const.AI.Behavior.ID.LewdGoblinRestrain;
	::Lewd.Const.AIBehaviorIDHornyIdle = ::Const.AI.Behavior.ID.LewdHornyIdle;
	::Lewd.Const.AIBehaviorIDOrcClaim = ::Const.AI.Behavior.ID.LewdOrcClaim;
	::Lewd.Const.AIBehaviorIDOrcHorny = ::Const.AI.Behavior.ID.LewdOrcHorny;
	::Lewd.Const.AIBehaviorIDUnholdHorny = ::Const.AI.Behavior.ID.LewdUnholdHorny;
	::Lewd.Const.AIBehaviorIDSpiderHorny = ::Const.AI.Behavior.ID.LewdSpiderHorny;
	::Lewd.Const.AIBehaviorIDFemaleHorny = ::Const.AI.Behavior.ID.LewdFemaleHorny;
	::Lewd.Const.AIBehaviorIDFemaleHornyEngage = ::Const.AI.Behavior.ID.LewdFemaleHornyEngage;

	// --- Mod Settings ---
	local page = ::Lewd.Mod.ModSettings.addPage("General");
	local settingStatAbsorption = page.addElement(::MSU.Class.EnumSetting(
		"EtherealStatAbsorption",
		"On Death",
		["Disabled", "On Climax", "On Death"],
		"Succubus Stat Absorption",
		"Ethereal-tier characters absorb +1 to a stat lower than the enemy's. [Disabled] turns this off. [On Climax] triggers whenever you cause an enemy to climax. [On Death] triggers only when an enemy dies from climax."
	));
	settingStatAbsorption.addAfterChangeCallback(function(_oldValue) {
		local val = this.getValue();
		// Migration: old saves may have boolean 'true'/'false' from when this was a bool setting
		if (typeof val == "bool" || (typeof val == "string" && (val == "true" || val == "false")))
		{
			val = val == true || val == "true" ? "On Death" : "Disabled";
			this.set(val);
		}
		::Lewd.Const.EtherealStatAbsorptionMode = val;
	});

	local settingOrgasmDefeat = page.addBooleanSetting(
		"OrgasmDefeat",
		true,
		"Orgasm Defeat",
		"When enabled, characters that climax too many times in a battle are defeated. The threshold scales with Resolve and HP."
	);
	settingOrgasmDefeat.addAfterChangeCallback(function(_oldValue) {
		::Lewd.Const.OrgasmDefeatEnabled = this.getValue();
	});

	local settingHarassment = page.addBooleanSetting(
		"AlliedHarassment",
		true,
		"Allied Harassment",
		"When enabled, horny male allies may grope or use sex abilities on adjacent high-allure female characters during combat."
	);
	settingHarassment.addAfterChangeCallback(function(_oldValue) {
		::Lewd.Const.HarassmentEnabled = this.getValue();
	});

	local settingInsatiableLimit = page.addRangeSetting(
		"InsatiableMaxTriggersPerTurn",
		1, // default
		0, // min (0 = no limit)
		5, // max
		1, // step
		"Insatiable AP Triggers Per Turn"
	);
	settingInsatiableLimit.setDescription("Maximum number of times Insatiable can grant AP in a single turn. Set to 0 for no limit.");
	settingInsatiableLimit.addAfterChangeCallback(function(_oldValue) {
		::Lewd.Const.InsatiableMaxTriggersPerTurn = this.getValue();
	});

	local settingSexSoundVolume = page.addRangeSetting(
		"SexSoundVolume",
		100, // default
		0,   // min
		200, // max
		5,   // step
		"Sex Sound Volume"
	);
	settingSexSoundVolume.setDescription("Volume multiplier for sex-related sounds. 100% is default game volume. Set to 0% to mute.");
	settingSexSoundVolume.addAfterChangeCallback(function(_oldValue) {
		::Lewd.Const.SexSoundVolume = this.getValue() / 100.0;
	});

	// Restored female hairstyles from legends 19.1.0 (renamed to avoid conflict with current legends)
	// Only added to BarberFemale (barbershop) — not AllFemale/SouthernFemale to avoid spawning on random characters
	local lewdHairs = ["lewd_01", "lewd_02", "lewd_03", "lewd_04", "lewd_05", "lewd_06"];
	::Const.Hair.BarberFemale.extend(lewdHairs);

	// Fix Legends bug: setGender(0) doesn't restore face/body/hair pools after setGender(1).
	// human_gender.nut can call setGender(1) during create() (setting AllFemale pools),
	// then legend_randomized_unit_abstract.onInit() calls setGender(0) which resets m.Gender
	// but leaves pools pointing at AllFemale -- causing female sprites on male-gendered entities.
	// Save male pools before the female switch and restore them when switching back.
	mod.hook("scripts/entity/tactical/human", function(q)
	{
		q.m._savedMaleFaces <- null;
		q.m._savedMaleBodies <- null;
		q.m._savedMaleHairs <- null;
		q.m._savedMaleBeards <- null;

		q.setGender = @(__original) function(_v, _reroll = true)
		{
			if (_v == 1 && this.m._savedMaleFaces == null)
			{
				this.m._savedMaleFaces = this.m.Faces;
				this.m._savedMaleBodies = this.m.Bodies;
				this.m._savedMaleHairs = this.m.Hairs;
				this.m._savedMaleBeards = this.m.Beards;
			}

			__original(_v, _reroll);

			if (_v != 1 && this.m._savedMaleFaces != null)
			{
				this.m.Faces = this.m._savedMaleFaces;
				this.m.Bodies = this.m._savedMaleBodies;
				this.m.Hairs = this.m._savedMaleHairs;
				if (this.m._savedMaleBeards != null)
					this.m.Beards = this.m._savedMaleBeards;
				this.m._savedMaleFaces = null;
				this.m._savedMaleBodies = null;
				this.m._savedMaleHairs = null;
				this.m._savedMaleBeards = null;
			}
		};
	});

	mod.hook("scripts/entity/tactical/actor", function (q)
	{
		// Add Pleasure as a member variable on actor (same pattern as m.Fatigue)
		q.m.Pleasure <- 0;
		q.m.LastPleasureSourceID <- -1; // ID of actor who last dealt pleasure (for Insatiable perk)
		q.m.OrgasmCount <- 0;

		// Add lewd_glow sprite layer for pheromone visual effects, and add lewd_info_effect to all actors
		q.onInit = @(__original) function()
		{
			local self = this;
			local old_addSprite = self.addSprite;
			self.addSprite = function (_layerID)
			{
				// Add back silhouette BEFORE body layer (renders behind body)
				if (_layerID == "body")
				{
					local sil = old_addSprite("lewd_silhouette_back");
					sil.Visible = false;
				}

				local ret = old_addSprite(_layerID);

				// Add piercing_body right after body (renders under armor)
				if (_layerID == "body")
				{
					local pb = old_addSprite("piercing_body");
					pb.Visible = false;
				}

				// Add restrained overlay after shaft (above armor, below head)
				if (_layerID == "shaft")
				{
					local restrained = old_addSprite("lewd_restrained");
					restrained.Visible = false;
					local cumBody = old_addSprite("cum_body");
					cumBody.Visible = false;
				}

				// Add piercing_head right before helmet (renders under helmet)
				if (_layerID == "helmet")
				{
					local ph = old_addSprite("piercing_head");
					ph.Visible = false;
				}

				if (_layerID == "socket")
				{
					old_addSprite("lewd_glow");
				}
				else if (_layerID == "status_stunned")
				{
					local horny = old_addSprite("status_horny");
					horny.Visible = false;
					local lewdSeal = old_addSprite("lewd_seal");
					lewdSeal.Visible = false;
					local cum = old_addSprite("cum_facial");
					cum.Visible = false;
					// Front silhouette AFTER all other layers (renders in front of everything)
					local sil = old_addSprite("lewd_silhouette_front");
					sil.Visible = false;
				}

				return ret;
			};
			__original();
			this.getSkills().add(this.new("scripts/skills/effects/lewd_info_effect"));
			this.getSkills().add(this.new("scripts/skills/effects/lewd_subdom_effect"));
			this.getSkills().add(this.new("scripts/skills/actives/lewd_flight_skill"));

			// Goblin lewd racial — grants restrain behavior and horny trigger
			if (::Lewd.Mastery.isGoblin(this))
				this.getSkills().add(this.new("scripts/skills/racial/goblin_lewd_racial"));

			// Orc lewd racial — grants claim behavior and horny trigger
			if (::Lewd.Mastery.isOrc(this))
				this.getSkills().add(this.new("scripts/skills/racial/orc_lewd_racial"));

			// Unhold lewd racial — grants piledriver and horny trigger
			if (::Lewd.Mastery.isUnhold(this))
				this.getSkills().add(this.new("scripts/skills/racial/unhold_lewd_racial"));

			// Spider lewd racial — grants inject skill and horny trigger
			if (::Lewd.Mastery.isSpider(this))
				this.getSkills().add(this.new("scripts/skills/racial/spider_lewd_racial"));
		}

		// Render callback for animated effects
		q.onRender = @(__original) function()
		{
			__original();

			local pheromonesEffect = this.getSkills().getSkillByID("effects.pheromones");
			if (pheromonesEffect != null)
			{
				pheromonesEffect.triggerRender();
			}
		}

		// Allure now reads from CharacterProperties (accumulated by trait/item/effect onUpdate methods)
		q.allure <- function() {
			return this.getCurrentProperties().getAllure();
		}

		// --- Pleasure system (m.Pleasure on actor, same pattern as m.Fatigue) ---
		q.getPleasure <- function() {
			return this.m.Pleasure;
		}

		q.setPleasure <- function( _v ) {
			this.m.Pleasure = this.Math.max(0, this.Math.round(_v));
		}

		q.getPleasureMax <- function() {
			return this.getCurrentProperties().getPleasureMax();
		}

		q.getPleasurePct <- function() {
			return this.Math.minf(1.0, this.m.Pleasure / this.Math.maxf(1.0, this.getPleasureMax()));
		}

		q.addPleasure <- function( _amount, _source = null ) {
			if (_source != null)
				this.m.LastPleasureSourceID = _source.getID();
			else
				this.m.LastPleasureSourceID = -1;
			local max = this.getPleasureMax();
			if (max <= 0) return 0;
			local amount = _amount;
			// apply received pleasure multiplier (mounted, restrained, open invitation, etc.)
			if (amount > 0)
				amount = this.Math.floor(amount * this.getCurrentProperties().ReceivedPleasureMult);
			local sourceName = _source != null ? _source.getName() : "none";
			::logInfo("[pleasure] " + this.getName() + " +" + amount + " from " + sourceName + " [" + this.m.Pleasure + "->" + (this.m.Pleasure + amount) + "/" + max + "]");
			local cur = this.m.Pleasure + amount;
			if (cur >= max)
			{
				// Determine if pleasure should overflow instead of resetting
				local overflow = false;
				// Insatiable perk (offensive): source's perk causes target's pleasure to overflow
				if (_source != null && _source.getSkills().hasSkill("perk.lewd_insatiable"))
					overflow = true;
				// Transcendence perk (defensive): own pleasure persists through climax
				if (this.getSkills().hasSkill("perk.lewd_transcendence"))
					overflow = true;

				this.m.Pleasure = overflow ? this.Math.max(0, this.Math.round(cur - max)) : 0;
				this.onClimax();
			}
			else
			{
				this.m.Pleasure = this.Math.max(0, this.Math.round(cur));
			}
			return amount;
		}

		q.onClimax <- function() {
			this.m.OrgasmCount++;
			local staleFlag = this.getFlags().has("lewdOrgasmDefeat");
			::logInfo("[climax] " + this.getName() + " OrgasmCount=" + this.m.OrgasmCount + " staleOrgasmDefeat=" + staleFlag);

			// Persistent self-climax counter (world-map flag, survives across battles)
			if (this.isPlayerControlled())
			{
				local cur = this.getFlags().getAsInt("lewdSelfClimaxes");
				this.getFlags().set("lewdSelfClimaxes", cur + 1);
			}

			// Remove existing climax effect so onAdded() fires fresh (perk triggers)
			if (this.getSkills().hasSkill("effects.climax"))
				this.getSkills().removeByID("effects.climax");

			local effect = this.new("scripts/skills/effects/climax_effect");
			this.getSkills().add(effect);
			// onAdded() fires here: sound, overlay, Shameless, Insatiable, DomSub, cum facial

			// Notify skills about this climax -- creature-specific reactions
			// onOwnerClimax: called on the climaxing actor's skills
			// onTargetClimax: called on the source creature's skills
			local sourceEntity = this.m.LastPleasureSourceID >= 0
				? this.Tactical.getEntityByID(this.m.LastPleasureSourceID)
				: null;
			local skills = this.getSkills().m.Skills;
			for (local i = 0; i < skills.len(); i++)
			{
				if ("onOwnerClimax" in skills[i])
					skills[i].onOwnerClimax(this, sourceEntity);
			}
			if (sourceEntity != null && sourceEntity.isAlive())
			{
				local srcSkills = sourceEntity.getSkills().m.Skills;
				for (local i = 0; i < srcSkills.len(); i++)
				{
					if ("onTargetClimax" in srcSkills[i])
						srcSkills[i].onTargetClimax(sourceEntity, this);
				}
			}

			// Check defeat AFTER perks have fired
			if (::Lewd.Const.OrgasmDefeatEnabled)
			{
				local threshold = ::Lewd.Mastery.getOrgasmThreshold(this);
				::logInfo("[climax] " + this.getName() + " threshold=" + threshold + " count=" + this.m.OrgasmCount + " defeat=" + (threshold > 0 && this.m.OrgasmCount >= threshold));
				if (threshold > 0 && this.m.OrgasmCount >= threshold)
					this.onOrgasmDefeat();
			}
		}

		q.onOrgasmDefeat <- function() {
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " is overwhelmed by pleasure!");
			this.getFlags().set("lewdOrgasmDefeat", true);
			// Force horny so they spend their last turn doing something sexy
			if (this.getSkills().hasSkill("effects.lewd_horny"))
				this.getSkills().getSkillByID("effects.lewd_horny").onRefresh();
			else
				this.getSkills().add(this.new("scripts/skills/effects/lewd_horny_effect"));

			// Normal kill: climax_effect.onTurnEnd fires at end of this entity's turn.
			// But if the entity's turn already passed this round (e.g. AoE hit them
			// during a later entity's turn), onTurnEnd won't fire until next round.
			// Combat can end before then, leaving a zombie that corrupts the turn bar.
			// Schedule a deferred kill as safety net.
			if (this.m.IsTurnDone)
			{
				local actor = this;
				local Tactical = this.Tactical;
				local FatalityNone = this.Const.FatalityType.None;
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, function(_d) {
					if (!_d.Actor.isAlive()) return;
					if (!_d.Actor.getFlags().has("lewdOrgasmDefeat")) return;
					::logInfo("[climax] deferred kill for " + _d.Actor.getName() + " (turn already done when defeated)");
					_d.Actor.getFlags().set("lewdPleasureDeath", true);
					local killer = null;
					if (_d.Actor.m.LastPleasureSourceID >= 0)
						killer = _d.Tactical.getEntityByID(_d.Actor.m.LastPleasureSourceID);
					if (killer != null && !killer.isAlive()) killer = null;
					local killSkill = _d.Actor.getSkills().getSkillByID("effects.climax");
					_d.Actor.kill(killer, killSkill, _d.FatalityNone, true);
				}, { Actor = actor, Tactical = Tactical, FatalityNone = FatalityNone });
			}
		}

		// Add pleasure bar + orgasm count to tactical tooltip (enemies/NPCs)
		q.getTooltip = @(__original) function( _targetedWithSkill = null )
		{
			local tooltip = __original(_targetedWithSkill);

			if (this.getPleasureMax() > 0)
			{
				local insertIdx = tooltip.len();

				for (local i = tooltip.len() - 1; i >= 0; i--)
				{
					if ("type" in tooltip[i] && tooltip[i].type == "progressbar")
					{
						insertIdx = i + 1;
						break;
					}
				}

				tooltip.insert(insertIdx, {
					id = 50,
					type = "progressbar",
					icon = "ui/icons/pleasure.png",
					value = this.getPleasure(),
					valueMax = this.getPleasureMax(),
					text = "" + this.getPleasure() + " / " + this.getPleasureMax(),
					style = "pleasure-slim"
				});

				// Orgasm threshold bar (right after pleasure bar)
				if (::Lewd.Const.OrgasmDefeatEnabled)
				{
					local threshold = ::Lewd.Mastery.getOrgasmThreshold(this);
					if (threshold > 0 && threshold < 999)
					{
						tooltip.insert(insertIdx + 1, {
							id = 51,
							type = "progressbar",
							icon = "skills/climax.png",
							value = this.m.OrgasmCount,
							valueMax = threshold,
							text = "" + this.m.OrgasmCount + " / " + threshold,
							style = "orgasm-slim"
						});
					}
				}
			}

			return tooltip;
		};

		// Blood suppression for orgasm defeat (no gore on pleasure death)
		q.spawnBloodSplatters = @(__original) function( _tile, _amount ) {
			if (this.getFlags().has("lewdPleasureDeath")) return;
			__original(_tile, _amount);
		};

		q.spawnBloodPool = @(__original) function( _tile, _amount ) {
			if (this.getFlags().has("lewdPleasureDeath")) return;
			__original(_tile, _amount);
		};

		// Exploit Weakness: +25% armor damage against female targets
		// Predatory Instinct: +15% damage vs Horny targets
		q.onDamageReceived = @(__original) function( _attacker, _skill, _hitInfo )
		{
			if (_attacker != null && _attacker.getSkills().hasSkill("perk.lewd_exploit_weakness") && this.getGender() == 1)
			{
				_hitInfo.DamageArmor = this.Math.floor(_hitInfo.DamageArmor * ::Lewd.Const.ExploitWeaknessArmorDamageMult);
			}

			if (_attacker != null && _attacker.getSkills().hasSkill("perk.lewd_predatory_instinct")
				&& this.getSkills().hasSkill("effects.lewd_horny"))
			{
				_hitInfo.DamageRegular = this.Math.floor(_hitInfo.DamageRegular * ::Lewd.Const.PredatoryInstinctDamageMult);
			}

			local hpDamage = __original(_attacker, _skill, _hitInfo);

			// Pain-to-pleasure: convert fraction of HP damage to pleasure
			if (hpDamage > 0 && this.isAlive())
			{
				local rate = this.getCurrentProperties().PainToPleasureRate;
				if (rate > 0.0 && this.getPleasureMax() > 0)
				{
					local gain = this.Math.max(1, this.Math.floor(hpDamage * rate));
					this.addPleasure(gain);
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " converts pain to pleasure (+" + gain + ")");
				}
			}

			return hpDamage;
		};

		// Embrace Pain: auto-pass morale loss checks
		// _type default: 0 = Const.MoraleCheckType.Default (can't use `this.Const` here, LSP chokes on it)
		q.checkMorale = @(__original) function( _change, _difficulty, _type = 0, _showIconBeforeMoraleIcon = "", _noNewLine = false )
		{
			if (_change < 0 && this.getSkills().hasSkill("perk.lewd_embrace_pain"))
				return false;
			return __original(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
		};

	});

	// hook item container to care about items' cursed status
	mod.hook("scripts/items/item_container", function(q)
	{
		q.unequip = @(__original) function(_item) {
			if (_item != null && _item.getFlags().has("cursed"))
			{
				if ("onRemoveWhileCursed" in _item)
					_item.onRemoveWhileCursed();
				return false;
			}
			return __original(_item);
		};
	});

	// Merge stackable items when dragged onto each other in stash
	// Items opt in by setting m.IsStackable = true and implementing getAmount/setAmount
	mod.hook("scripts/items/stash_container", function(q)
	{
		q.swap = @(__original) function(_sourceIndex, _targetIndex) {
			if (_sourceIndex != _targetIndex && this.isValidSlot(_sourceIndex) && this.isValidSlot(_targetIndex))
			{
				local src = this.m.Items[_sourceIndex];
				local dst = this.m.Items[_targetIndex];
				if (src != null && dst != null
					&& "IsStackable" in src.m && src.m.IsStackable
					&& src.getID() == dst.getID())
				{
					dst.setAmount(dst.getAmount() + src.getAmount());
					this.m.Items[_sourceIndex] = null;
					return true;
				}
			}
			return __original(_sourceIndex, _targetIndex);
		};
	});

	// Block natural weapons from leaving the character (stash, ground, displaced by equip)
	mod.hook("scripts/ui/screens/character/character_screen", function(q)
	{
		// Helper: check if a natural weapon would be displaced by equipping into its slot
		q.hasNaturalWeaponTarget <- function(_targetItems)
		{
			if (_targetItems.firstItem != null && _targetItems.firstItem.getFlags().has("naturalWeapon"))
				return true;
			if (_targetItems.secondItem != null && _targetItems.secondItem.getFlags().has("naturalWeapon"))
				return true;
			return false;
		};

		// Block dragging natural weapons to stash
		q.general_onDropItemIntoStash = @(__original) function(_data) {
			local data = this.helper_queryEntityItemData(_data, true);
			if (!("error" in data) && data.sourceItem != null && data.sourceItem.getFlags().has("naturalWeapon"))
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromTargetSlot);
			return __original(_data);
		};

		// Block dropping natural weapons on ground (from paperdoll)
		q.tactical_onDropItemToGround = @(__original) function(_data) {
			local data = this.helper_queryEntityItemData(_data);
			if (!("error" in data) && data.sourceItem != null && data.sourceItem.getFlags().has("naturalWeapon"))
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromTargetSlot);
			return __original(_data);
		};

		// Block dragging natural weapons from bag to stash
		q.general_onDropBagItemIntoStash = @(__original) function(_data) {
			local data = this.helper_queryBagItemDataToInventory(_data);
			if (!("error" in data) && data.sourceItem != null && data.sourceItem.getFlags().has("naturalWeapon"))
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromTargetSlot);
			return __original(_data);
		};

		// Block dropping natural weapons from bag to ground
		q.tactical_onDropBagItemToGround = @(__original) function(_data) {
			local data = this.helper_queryBagItemDataToInventory(_data);
			if (!("error" in data) && data.sourceItem != null && data.sourceItem.getFlags().has("naturalWeapon"))
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromTargetSlot);
			return __original(_data);
		};

		// Block dropping a stash item onto a bag slot occupied by a natural weapon
		q.general_onDropStashItemIntoBag = @(__original) function(_data) {
			local data = this.helper_queryStashItemData(_data);
			if (!("error" in data) && data.targetItemIdx != null)
			{
				local targetItem = data.inventory.getItemAtBagSlot(data.targetItemIdx);
				if (targetItem != null && targetItem.getFlags().has("naturalWeapon"))
					return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromTargetSlot);
			}
			return __original(_data);
		};

		// Block equipping a stash item into a slot occupied by a natural weapon
		q.general_onEquipStashItem = @(__original) function(_data) {
			local data = this.helper_queryStashItemData(_data);
			if (!("error" in data))
			{
				local targetItems = this.helper_queryEquipmentTargetItems(data.inventory, data.sourceItem);
				if (this.hasNaturalWeaponTarget(targetItems))
					return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromTargetSlot);
			}
			return __original(_data);
		};

	});

	// Perk tree injection is handled by the traits themselves (dainty, delicate, masochism)
	// via onAdded() using Legends' addPerkGroup/hasPerkGroup API

	// Allied harassment skills for male player characters
	mod.hook("scripts/entity/tactical/player", function(q)
	{
		q.onInit = @(__original) function()
		{
			__original();
			if (this.getGender() == 1) return; // females skip all male-only setup

			// Allied harassment skills (hidden, used by horny male AI against female allies)
			this.getSkills().add(this.new("scripts/skills/actives/allied_grope_skill"));
			this.getSkills().add(this.new("scripts/skills/actives/allied_force_oral_skill"));
			this.getSkills().add(this.new("scripts/skills/actives/allied_penetrate_vaginal_skill"));
			this.getSkills().add(this.new("scripts/skills/actives/allied_penetrate_anal_skill"));
		};

		// Save-compat cleanup: remove lewd perk trees from characters who shouldn't have them
		// Fixes U16 index corruption from inserting PerkDefs in the middle of the array
		// PerkTree and PerkTreeMap are already built by background.onDeserialize -> buildPerkTree()
		q.onDeserialize = @(__original) function( _in )
		{
			__original(_in);

			local bg = this.getBackground();
			if (bg == null) return;

			// Inject Seduction Arts for innate backgrounds on existing saves
			local bgID = bg.getID();
			if (bgID == "background.legend_qiyan" || bgID == "background.belly_dancer")
			{
				if (!bg.hasPerkGroup(::Const.Perks.SeductionArtsTree))
				{
					bg.addPerkGroup(::Const.Perks.SeductionArtsTree.Tree);
					::logInfo("[mod_lewd] Injected Seduction Arts on load for " + this.getName() + " (bg: " + bg.getName() + ")");
				}
			}

			local skills = this.getSkills();
			local isFemale = this.getGender() == 1;
			local hasDainty = skills.hasSkill("trait.dainty");
			local hasDelicate = skills.hasSkill("trait.delicate");
			local hasEthereal = skills.hasSkill("trait.ethereal");
			local hasMasochism = skills.hasSkill("trait.masochism_first")
				|| skills.hasSkill("trait.masochism_second")
				|| skills.hasSkill("trait.masochism_third");

			// Build list of perk consts that should be removed from this character
			local toRemove = [];

			// SeductionArts: requires Dainty/Delicate/Ethereal, or innate background
			local bgID = bg.getID();
			local hasInnateSA = bgID == "background.legend_qiyan" || bgID == "background.belly_dancer";
			if (!hasDainty && !hasDelicate && !hasEthereal && !hasInnateSA)
			{
				toRemove.extend([
					::Const.Perks.PerkDefs.LewdNimbleFingers,
					::Const.Perks.PerkDefs.LewdOralArts,
					::Const.Perks.PerkDefs.LewdFootTease,
					::Const.Perks.PerkDefs.LewdMounting,
					::Const.Perks.PerkDefs.LewdOffering,
					::Const.Perks.PerkDefs.LewdSensualFocus,
					::Const.Perks.PerkDefs.LewdAlluringPresence,
					::Const.Perks.PerkDefs.LewdPracticedControl,
					::Const.Perks.PerkDefs.LewdInsatiable
				]);
			}

			// Endurance: requires (Masochism + Delicate) or Ethereal
			if (!(hasMasochism && hasDelicate) && !hasEthereal)
			{
				toRemove.extend([
					::Const.Perks.PerkDefs.LewdEmbracePain,
					::Const.Perks.PerkDefs.LewdWillingVictim,
					::Const.Perks.PerkDefs.LewdPliantBody,
					::Const.Perks.PerkDefs.LewdPainFeedsPleasure,
					::Const.Perks.PerkDefs.LewdShameless,
					::Const.Perks.PerkDefs.LewdTranscendence
				]);
			}

			// Succubus: requires Ethereal
			if (!hasEthereal)
			{
				toRemove.extend([
					::Const.Perks.PerkDefs.LewdPredatoryInstinct,
					::Const.Perks.PerkDefs.LewdEssenceFeed,
					::Const.Perks.PerkDefs.LewdSoulHarvest,
					::Const.Perks.PerkDefs.LewdUnquenchable
				]);
			}

			// Debauchery: requires male + Outlaw
			if (isFemale || !bg.isBackgroundType(::Const.BackgroundType.Outlaw))
			{
				toRemove.extend([
					::Const.Perks.PerkDefs.LewdWanderingHands,
					::Const.Perks.PerkDefs.LewdExploitWeakness,
					::Const.Perks.PerkDefs.LewdCarnalKnowledge,
					::Const.Perks.PerkDefs.LewdBrutalForce,
					::Const.Perks.PerkDefs.LewdForcedEntry,
					::Const.Perks.PerkDefs.LewdIronGrip,
					::Const.Perks.PerkDefs.LewdConqueror
				]);
			}

			if (toRemove.len() == 0) return;

			// Build lookup sets
			local constSet = {};
			local idSet = {};
			foreach (c in toRemove)
			{
				constSet[c] <- true;
				local def = ::Const.Perks.PerkDefObjects[c];
				idSet[def.ID] <- true;
			}

			// Remove from visual PerkTree
			local removed = 0;
			local perkTree = bg.getPerkTree();
			if (perkTree != null)
			{
				foreach (row in perkTree)
				{
					for (local i = row.len() - 1; i >= 0; i--)
					{
						if (row[i].ID in idSet)
						{
							row.remove(i);
							removed++;
						}
					}
				}
			}

			// Remove from CustomPerkTree (U16 consts)
			if (bg.m.CustomPerkTree != null)
			{
				foreach (row in bg.m.CustomPerkTree)
				{
					for (local i = row.len() - 1; i >= 0; i--)
					{
						if (row[i] in constSet)
							row.remove(i);
					}
				}
			}

			// Remove from PerkTreeMap
			if (bg.m.PerkTreeMap != null)
			{
				foreach (id, _ in idSet)
				{
					if (id in bg.m.PerkTreeMap)
						delete bg.m.PerkTreeMap[id];
				}
			}

			if (removed == 0) return;

			// Refund any learned perk skills
			local refunded = 0;
			foreach (id, _ in idSet)
			{
				if (skills.hasSkill(id))
				{
					skills.removeByID(id);
					this.m.PerkPoints++;
					this.m.PerkPointsSpent = this.Math.max(0, this.m.PerkPointsSpent - 1);
					refunded++;
				}
			}
			::logInfo("[mod_lewd] Cleaned up " + removed + " phantom lewd perks from " + this.getName() + " (refunded " + refunded + ")");
		};

		// Perk tree injection — must happen after setStartValuesEx
		// because background is null during onInit (assigned in setStartValuesEx)
		q.setStartValuesEx = @(__original) function( _backgrounds, _addTraits = true, _gender = -1, _addEquipment = true )
		{
			__original(_backgrounds, _addTraits, _gender, _addEquipment);

			local bg = this.getBackground();
			if (bg == null) return;

			// Debauchery: male Outlaws
			if (this.getGender() != 1 && !bg.isBackgroundType(::Const.BackgroundType.Female) && bg.isBackgroundType(::Const.BackgroundType.Outlaw))
			{
				if (!bg.hasPerkGroup(::Const.Perks.DebaucheryTree))
				{
					bg.addPerkGroup(::Const.Perks.DebaucheryTree.Tree);
					::logInfo("[mod_lewd] Injected Debauchery perk tree for " + this.getName() + " (bg: " + bg.getName() + ")");
				}
			}

			// Seduction Arts: female backgrounds with innate seductive talent
			local bgID = bg.getID();
			if (bgID == "background.legend_qiyan" || bgID == "background.belly_dancer")
			{
				if (!bg.hasPerkGroup(::Const.Perks.SeductionArtsTree))
				{
					bg.addPerkGroup(::Const.Perks.SeductionArtsTree.Tree);
					::logInfo("[mod_lewd] Injected Seduction Arts perk tree for " + this.getName() + " (bg: " + bg.getName() + ")");
				}
			}
		};

		// Player orgasm defeat: go unconscious instead of dying
		q.isReallyKilled = @(__original) function( _fatalityType ) {
			if (this.getFlags().has("lewdPleasureDeath"))
				return false; // -> unconscious, recoverable after battle
			return __original(_fatalityType);
		};

		// Pleasure bar + orgasm count on player tactical tooltip
		q.getTooltip = @(__original) function( _targetedWithSkill = null )
		{
			local tooltip = __original(_targetedWithSkill);

			if (this.getPleasureMax() > 0)
			{
				local insertIdx = tooltip.len();

				for (local i = tooltip.len() - 1; i >= 0; i--)
				{
					if ("type" in tooltip[i] && tooltip[i].type == "progressbar")
					{
						insertIdx = i + 1;
						break;
					}
				}

				tooltip.insert(insertIdx, {
					id = 50,
					type = "progressbar",
					icon = "ui/icons/pleasure.png",
					value = this.getPleasure(),
					valueMax = this.getPleasureMax(),
					text = "" + this.getPleasure() + " / " + this.getPleasureMax(),
					style = "pleasure-slim"
				});

				// Orgasm threshold bar (right after pleasure bar)
				if (::Lewd.Const.OrgasmDefeatEnabled)
				{
					local threshold = ::Lewd.Mastery.getOrgasmThreshold(this);
					if (threshold > 0 && threshold < 999)
					{
						tooltip.insert(insertIdx + 1, {
							id = 51,
							type = "progressbar",
							icon = "skills/climax.png",
							value = this.m.OrgasmCount,
							valueMax = threshold,
							text = "" + this.m.OrgasmCount + " / " + threshold,
							style = "orgasm-slim"
						});
					}
				}
			}

			return tooltip;
		};
	});

	// Predatory Instinct: +hit% vs Horny targets (applied as defense reduction on target side)
	mod.hook("scripts/skills/skill_container", function(q)
	{
		q.buildPropertiesForDefense = @(__original) function( _attacker, _skill )
		{
			local result = __original(_attacker, _skill);

			if (_attacker != null && _attacker.getSkills().hasSkill("perk.lewd_predatory_instinct")
				&& this.m.Actor.getSkills().hasSkill("effects.lewd_horny"))
			{
				result.MeleeDefense -= ::Lewd.Const.PredatoryInstinctHitBonus;
				result.RangedDefense -= ::Lewd.Const.PredatoryInstinctHitBonus;
			}

			return result;
		};
	});

	// Climax-triggered perk hooks: Conqueror, Soul Harvest, Unquenchable
	mod.hook("scripts/skills/effects/climax_effect", function(q)
	{
		q.onAdded = @(__original) function()
		{
			__original();

			local actor = this.getContainer().getActor();
			local sourceID = actor.m.LastPleasureSourceID;
			if (sourceID < 0) return;

			local source = this.Tactical.getEntityByID(sourceID);
			if (source == null || !source.isAlive()) return;
			local isEnemy = !source.isAlliedWith(actor);

			// Conqueror: morale boost + fatigue restore + dom bonus
			if (isEnemy && source.getSkills().hasSkill("perk.lewd_conqueror"))
			{
				source.checkMorale(1, 0);
				local fatigueRestore = this.Math.floor(source.getFatigueMax() * ::Lewd.Const.ConquerorFatigueRestorePct);
				source.m.Fatigue = this.Math.max(0, source.m.Fatigue - fatigueRestore);
				::Lewd.Mastery.addDomSub(source, ::Lewd.Const.ConquerorDomBonus);
				::logInfo("[conqueror] " + source.getName() + " conquered " + actor.getName() + ": morale boost, -" + fatigueRestore + " fatigue, +" + ::Lewd.Const.ConquerorDomBonus + " dom");
			}

			// Soul Harvest: heal 10% of target's PleasureMax when causing climax
			if (isEnemy && source.getSkills().hasSkill("perk.lewd_soul_harvest"))
			{
				local pleasureMax = actor.getCurrentProperties().getPleasureMax();
				local healAmount = this.Math.max(1, this.Math.floor(pleasureMax * ::Lewd.Const.SoulHarvestClimaxHealPct));
				source.setHitpoints(this.Math.min(source.getHitpointsMax(), source.getHitpoints() + healAmount));
				if (!source.isHiddenToPlayer())
				{
					this.spawnIcon("status_effect_79", source.getTile());
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(source) + " harvests [color=" + this.Const.UI.Color.PositiveValue + "]" + healAmount + "[/color] health from " + this.Const.UI.getColorizedEntityName(actor) + "'s climax");
				}
				::logInfo("[soul_harvest] " + source.getName() + " healed " + healAmount + " HP from " + actor.getName() + "'s climax");
			}

			// Unquenchable: +Allure per climax caused
			if (isEnemy)
			{
				local unquenchable = source.getSkills().getSkillByID("perk.lewd_unquenchable");
				if (unquenchable != null)
				{
					unquenchable.addClimax();
					::logInfo("[unquenchable] " + source.getName() + " gained +" + ::Lewd.Const.UnquenchableAllurePerClimax + " Allure (total stacks: " + unquenchable.m.ClimaxCount + ")");
				}
			}
		};
	});

	// Conqueror: mounted targets get additional Resolve penalty
	mod.hook("scripts/skills/effects/lewd_mounted_effect", function(q)
	{
		q.onUpdate = @(__original) function( _properties )
		{
			__original(_properties);

			// Check if any mounter has Conqueror
			local actor = this.getContainer().getActor();
			foreach (mounterID in this.m.MounterIDs)
			{
				local mounter = this.Tactical.getEntityByID(mounterID);
				if (mounter != null && mounter.isAlive() && mounter.getSkills().hasSkill("perk.lewd_conqueror"))
				{
					_properties.Bravery += ::Lewd.Const.ConquerorMountedResolvePenalty;
					break;
				}
			}
		};

	});

	// Hook Nudist perk: apply bonus based on zero fatigue cost rather than empty slots
	// This allows lewd clothing (which has 0 stamina penalty) to still benefit from the perk
	mod.hook("scripts/skills/perks/perk_legend_ubernimble", function(q)
	{
		q.getTooltip = @(__original) function()
		{
			local tooltip = this.skill.getTooltip();
			local fm = this.Math.round(this.getChance() * 100);
			local actor = this.getContainer().getActor();
			local items = actor.getItems();
			local bodyitem = items.getItemAtSlot(this.Const.ItemSlot.Body);
			local headitem = items.getItemAtSlot(this.Const.ItemSlot.Head);
			local hasFatigueCost = false;

			if (bodyitem != null && bodyitem.getStaminaModifier() < 0)
				hasFatigueCost = true;

			if (headitem != null && headitem.getStaminaModifier() < 0)
				hasFatigueCost = true;

			if (!hasFatigueCost)
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Only receive [color=%positive%]" + fm + "%[/color] of any damage to hitpoints from attacks"
				});
			}
			else
			{
				tooltip.push({
					id = 6,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=%negative%]This character isn\'t nude.[/color]"
				});
			}

			return tooltip;
		};

		q.onBeforeDamageReceived = @(__original) function( _attacker, _skill, _hitInfo, _properties )
		{
			local actor = this.getContainer().getActor();
			local items = actor.getItems();
			local bodyitem = items.getItemAtSlot(this.Const.ItemSlot.Body);
			local headitem = items.getItemAtSlot(this.Const.ItemSlot.Head);

			if (bodyitem != null && bodyitem.getStaminaModifier() < 0)
				return;

			if (headitem != null && headitem.getStaminaModifier() < 0)
				return;

			if (_attacker != null && _attacker.getID() == actor.getID() || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
				return;

			local chance = this.getChance();
			_properties.DamageReceivedRegularMult *= chance;
		};
	});

	// Hook Red Court hemovore trait: allow armor equipping
	if (::HasRedCourt)
	{
		mod.hook("scripts/skills/traits/hemovore_trait", function(q)
		{
			q.onAdded = @(__original) function()
			{
				// Call original but then undo the slot locking
				__original();
				local items = this.getContainer().getActor().getItems();
				if (items.getData()[this.Const.ItemSlot.Head][0] == -1)
					items.getData()[this.Const.ItemSlot.Head][0] = null;
				if (items.getData()[this.Const.ItemSlot.Body][0] == -1)
					items.getData()[this.Const.ItemSlot.Body][0] = null;
			};
		});
	}

	// Hook break_free to also remove the lewd_restrained effect
	mod.hook("scripts/skills/actives/break_free_skill", function(q)
	{
		q.onUse = @(__original) function( _user, _targetTile )
		{
			local hadRestrained = _user.getSkills().hasSkill("effects.lewd_restrained");
			local result = __original(_user, _targetTile);
			// If break_free succeeded AND we had restrained, remove it
			// (original only removes net/web/rooted/kraken/serpent)
			if (result && hadRestrained)
			{
				_user.getSkills().removeByID("effects.lewd_restrained");
			}
			return result;
		};
	});

	// Brutal Force: +1 orgasm threshold for perk owner
	// (added to mastery.nut getOrgasmThreshold via this hook)

	// Alluring Presence aura: apply pleasure to enemies on their turn start and when they move adjacent
	// Allied harassment: male brothers may grope adjacent high-allure allied females
	mod.hook("scripts/skills/effects/lewd_info_effect", function(q)
	{
		q.onTurnStart = @(__original) function()
		{
			__original();
			local actor = this.getContainer().getActor();
			if (!actor.isPlacedOnMap()) return;

			// --- Alluring Presence aura (enemy perspective) ---
			if (actor.getPleasureMax() > 0)
			{
				local tile = actor.getTile();
				for (local i = 0; i < 6; i++)
				{
					if (!tile.hasNextTile(i)) continue;
					local nextTile = tile.getNextTile(i);
					if (!nextTile.IsOccupiedByActor) continue;
					local adj = nextTile.getEntity();
					if (adj == null || adj.isAlliedWith(actor)) continue;
					if (!adj.getSkills().hasSkill("perk.lewd_alluring_presence")) continue;
					actor.addPleasure(::Lewd.Const.AlluringPresenceAuraPleasure, adj);
				}
			}

			// --- Allied harassment (male brother perspective, requires Horny) ---
			if (!::Lewd.Const.HarassmentEnabled) return;
			if (!actor.isPlayerControlled()) return;
			if (actor.getGender() == 1) return; // only males harass
			if (!actor.getSkills().hasSkill("effects.lewd_horny")) return; // must be horny

			// Find the most alluring adjacent allied female
			local bestTarget = null;
			local bestAllure = 0;
			local tile = actor.getTile();
			for (local i = 0; i < 6; i++)
			{
				if (!tile.hasNextTile(i)) continue;
				local nextTile = tile.getNextTile(i);
				if (!nextTile.IsOccupiedByActor) continue;
				local adj = nextTile.getEntity();
				if (adj == null || !adj.isAlliedWith(actor)) continue;
				if (adj.getGender() != 1) continue;
				if (adj.getPleasureMax() <= 0) continue;
				local allure = adj.allure();
				if (allure < ::Lewd.Const.HarassmentAllureThreshold) continue;
				if (allure > bestAllure)
				{
					bestAllure = allure;
					bestTarget = adj;
				}
			}

			if (bestTarget == null) return;

			local resolve = actor.getCurrentProperties().getBravery();
			local domSub = ::Lewd.Mastery.getDomSub(bestTarget);
			local chance = (bestAllure - ::Lewd.Const.HarassmentAllureThreshold) * ::Lewd.Const.HarassmentChancePerAllure
				- resolve * ::Lewd.Const.HarassmentResolveScale
				- domSub * ::Lewd.Const.HarassmentDomSubScale;
			chance = this.Math.max(::Lewd.Const.HarassmentMinChance, this.Math.min(::Lewd.Const.HarassmentMaxChance, this.Math.floor(chance)));

			::logInfo("[harassment] " + actor.getName() + " (horny) -> " + bestTarget.getName() + " allure:" + bestAllure + " resolve:" + resolve + " domSub:" + domSub + " chance:" + chance);

			local roll = this.Math.rand(1, 100);
			if (roll > chance)
			{
				::logInfo("[harassment] missed roll:" + roll + " > " + chance);
				return;
			}

			::logInfo("[harassment] TRIGGERED roll:" + roll + " <= " + chance);

			// Select harassment skill based on whether target is mounted
			local targetMounted = bestTarget.getSkills().hasSkill("effects.lewd_mounted");
			local selectedSkill = null;

			if (targetMounted)
			{
				// Escalation roll: base + allure*scale - resolve*scale, clamped [0, 80]
				local escChance = ::Lewd.Const.HarassmentEscalateBaseChance
					+ this.Math.floor(bestAllure * ::Lewd.Const.HarassmentEscalateAllureScale)
					- this.Math.floor(resolve * ::Lewd.Const.HarassmentEscalateResolveScale);
				escChance = this.Math.max(0, this.Math.min(80, escChance));

				local escRoll = this.Math.rand(1, 100);
				::logInfo("[harassment] escalation check: roll:" + escRoll + " chance:" + escChance + " (target mounted)");

				if (escRoll <= escChance)
				{
					// Escalate: try penetration or oral
					local pickRoll = this.Math.rand(1, 100);
					if (pickRoll <= 40)
					{
						// Try vaginal penetration
						local skill = actor.getSkills().getSkillByID("actives.allied_penetrate_vaginal");
						if (skill != null && actor.getActionPoints() >= skill.getActionPointCost())
							selectedSkill = skill;
					}
					else if (pickRoll <= 70)
					{
						// Try anal penetration
						local skill = actor.getSkills().getSkillByID("actives.allied_penetrate_anal");
						if (skill != null && actor.getActionPoints() >= skill.getActionPointCost())
							selectedSkill = skill;
					}

					// Fallback: force oral
					if (selectedSkill == null)
					{
						local skill = actor.getSkills().getSkillByID("actives.allied_force_oral");
						if (skill != null && actor.getActionPoints() >= skill.getActionPointCost())
							selectedSkill = skill;
					}
				}
			}

			// Fallback to grope (unmounted targets or failed escalation)
			if (selectedSkill == null)
			{
				local gropeSkill = actor.getSkills().getSkillByID("actives.allied_grope");
				if (gropeSkill != null && actor.getActionPoints() >= gropeSkill.getActionPointCost())
					selectedSkill = gropeSkill;
			}

			if (selectedSkill != null)
			{
				::logInfo("[harassment] using " + selectedSkill.getID() + " on " + bestTarget.getName());
				selectedSkill.use(bestTarget.getTile());
			}
		};

		q.onMovementFinished = @(__original) function()
		{
			__original();
			local actor = this.getContainer().getActor();
			if (!actor.isPlacedOnMap()) return;
			if (actor.getPleasureMax() <= 0) return;

			local tile = actor.getTile();
			for (local i = 0; i < 6; i++)
			{
				if (!tile.hasNextTile(i)) continue;
				local nextTile = tile.getNextTile(i);
				if (!nextTile.IsOccupiedByActor) continue;
				local adj = nextTile.getEntity();
				if (adj == null || adj.isAlliedWith(actor)) continue;
				if (!adj.getSkills().hasSkill("perk.lewd_alluring_presence")) continue;
				actor.addPleasure(::Lewd.Const.AlluringPresenceAuraPleasure, adj);
			}
		};
	});

	// Fire hexen transformation event directly after hexen combat (bypass score system)
	mod.hook("scripts/states/world_state", function(q)
	{
		q.onCombatFinished = @(__original) function()
		{
			__original();

			// Clear cum sprites from combat
			local roster = this.World.getPlayerRoster().getAll();
			foreach (bro in roster)
			{
				if (bro.hasSprite("cum_facial"))
				{
					bro.getSprite("cum_facial").Visible = false;
				}
				if (bro.hasSprite("cum_body"))
				{
					bro.getSprite("cum_body").Visible = false;
				}
				bro.setDirty(true);
			}

			// --- Hexen curse trigger ---
			if (this.World.Statistics.getFlags().get("lewdFoughtHexen"))
			{
				if (this.World.Statistics.getFlags().getAsInt("LastCombatResult") == 1)
				{
					local brothers = this.World.getPlayerRoster().getAll();
					foreach (bro in brothers)
					{
						if (bro.getGender() == 0 && bro.getFlags().get("IsPlayerCharacter")
							&& !bro.getFlags().has("lewdHexenCursed") && ::Lewd.Mastery.getLewdTier(bro) == 0)
						{
							::logInfo("[mod_lewd] Firing hexen curse event for " + bro.getName());
							local evt = this.World.Events.getEvent("event.lewd_hexen_curse");
							if (evt != null)
							{
								evt.m.Man = bro;
								this.World.Events.fire("event.lewd_hexen_curse", false);
							}
							break;
						}
					}
				}

				// Clear after fire() so onUpdateScore can still see the flag
				this.World.Statistics.getFlags().set("lewdFoughtHexen", false);
			}

			// --- Incubus seal cleanup ---
			// Remove incomplete seal after any combat (the defeated event handles stage 4)
			local sealWoman = ::Lewd.Transform.target();
			if (sealWoman != null)
			{
				local seal = sealWoman.getSkills().getSkillByID("effects.lewd_seal");
				if (seal != null && seal.getStage() < 4)
				{
					sealWoman.getSkills().removeByID("effects.lewd_seal");
					::logInfo("[mod_lewd] Removed incomplete lewd seal (stage " + seal.getStage() + ") after combat");
				}
			}

			// --- Restore world map figure based on current trait ---
			local player = this.World.State.m.Player;
			if (player != null)
			{
				local woman = ::Lewd.Transform.target();
				if (woman != null)
				{
					local figureBrush = null;
					if (woman.getSkills().hasSkill("trait.ethereal"))
						figureBrush = "figure_player_ethereal";
					else if (woman.getSkills().hasSkill("trait.delicate"))
						figureBrush = "figure_player_delicate";
					else if (woman.getSkills().hasSkill("trait.dainty"))
						figureBrush = "figure_player_dainty";

					if (figureBrush != null)
					{
						player.getSprite("body").setBrush(figureBrush);
						player.getSprite("body").setHorizontalFlipping(false);
					}
				}
			}

			// --- Ethereal quest chain: gheist encounter trigger ---
			if (this.World.Statistics.getFlags().get("lewdFoughtGheist"))
			{
				::logInfo("[mod_lewd] Ethereal quest: post-combat gheist check (won=" + (this.World.Statistics.getFlags().getAsInt("LastCombatResult") == 1) + ", stage=" + this.World.Flags.getAsInt("lewdEtherealQuestStage") + ")");
				this.World.Statistics.getFlags().set("lewdFoughtGheist", false);

				if (this.World.Statistics.getFlags().getAsInt("LastCombatResult") == 1)
				{
					local woman = ::Lewd.Transform.target();
					local lewdTier = woman != null ? ::Lewd.Mastery.getLewdTier(woman) : -1;
					local climaxes = woman != null
						? woman.getFlags().getAsInt("lewdPartnerClimaxes") + woman.getFlags().getAsInt("lewdSelfClimaxes")
						: 0;
					::logInfo("[mod_lewd] Ethereal quest: woman=" + (woman != null ? woman.getName() : "null") + " lewdTier=" + lewdTier + " climaxes=" + climaxes + " threshold=" + ::Lewd.Const.EtherealQuestClimaxThreshold);

					if (woman != null && this.World.Flags.getAsInt("lewdEtherealQuestStage") == 0
						&& lewdTier >= 2)
					{
						if (climaxes >= ::Lewd.Const.EtherealQuestClimaxThreshold)
						{
							::logInfo("[mod_lewd] Firing ethereal gheist encounter event");
							this.World.Events.fire("event.lewd_ethereal_gheist");
						}
						else
						{
							::logInfo("[mod_lewd] Ethereal quest: not enough climaxes (" + climaxes + "/" + ::Lewd.Const.EtherealQuestClimaxThreshold + ")");
						}
					}
				}
			}
		};

		// --- Save migration: revert pre-questchain Ethereal to Delicate ---
		// Players who got Ethereal via the old automatic event (lewd_ethereal_third)
		// need to redo it through the quest chain. Detect by checking for Ethereal
		// trait without the quest completion flag.
		q.onDeserialize = @(__original) function( _in )
		{
			__original(_in);

			// Only run once per save
			if (this.World.Flags.has("lewdEtherealQuestMigrated"))
				return;

			this.World.Flags.set("lewdEtherealQuestMigrated", true);

			local woman = ::Lewd.Transform.target();
			if (woman == null) return;

			local skills = woman.getSkills();
			if (!skills.hasSkill("trait.ethereal")) return;

			// Has Ethereal + quest complete flag = legitimate, skip
			if (this.World.Flags.getAsInt("lewdEtherealQuestStage") >= 6) return;

			::logInfo("[mod_lewd] Save migration: reverting pre-questchain Ethereal for " + woman.getName());

			// Remove Ethereal trait, add back Delicate
			skills.removeByID("trait.ethereal");
			if (!skills.hasSkill("trait.delicate"))
				skills.add(this.new("scripts/skills/traits/delicate_trait"));

			// Refund Succubus perks and remove perk tree
			local succubusPerks = [
				"perk.lewd_predatory_instinct",
				"perk.lewd_essence_feed",
				"perk.lewd_soul_harvest",
				"perk.lewd_unquenchable"
			];
			local succubusConsts = [
				::Const.Perks.PerkDefs.LewdPredatoryInstinct,
				::Const.Perks.PerkDefs.LewdEssenceFeed,
				::Const.Perks.PerkDefs.LewdSoulHarvest,
				::Const.Perks.PerkDefs.LewdUnquenchable
			];
			local refunded = 0;
			foreach (id in succubusPerks)
			{
				if (skills.hasSkill(id))
				{
					skills.removeByID(id);
					woman.m.PerkPoints++;
					woman.m.PerkPointsSpent = this.Math.max(0, woman.m.PerkPointsSpent - 1);
					refunded++;
				}
			}

			// Remove Succubus perk tree from background
			local bg = woman.getBackground();
			if (bg != null)
			{
				// Build ID lookup for succubus perk defs
				local constSet = {};
				local idSet = {};
				foreach (c in succubusConsts)
				{
					constSet[c] <- true;
					idSet[::Const.Perks.PerkDefObjects[c].ID] <- true;
				}

				// Remove from visual PerkTree
				local perkTree = bg.getPerkTree();
				if (perkTree != null)
				{
					foreach (row in perkTree)
					{
						for (local i = row.len() - 1; i >= 0; i--)
						{
							if (row[i].ID in idSet)
								row.remove(i);
						}
					}
				}

				// Remove from CustomPerkTree
				if (bg.m.CustomPerkTree != null)
				{
					foreach (row in bg.m.CustomPerkTree)
					{
						for (local i = row.len() - 1; i >= 0; i--)
						{
							if (row[i] in constSet)
								row.remove(i);
						}
					}
				}

				// Remove from PerkTreeMap
				if (bg.m.PerkTreeMap != null)
				{
					foreach (id, _ in idSet)
					{
						if (id in bg.m.PerkTreeMap)
							delete bg.m.PerkTreeMap[id];
					}
				}

				::logInfo("[mod_lewd] Save migration: removed Succubus perk tree");
			}

			// Remove flight skill
			if (skills.hasSkill("actives.lewd_flight"))
			{
				skills.removeByID("actives.lewd_flight");
				woman.getFlags().remove("lewdFlightGranted");
				::logInfo("[mod_lewd] Save migration: removed flight skill");
			}

			// Remove tail weapon
			if (woman.getFlags().has("lewdTailGranted"))
			{
				local items = woman.getItems();
				local mainhand = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);
				if (mainhand != null && mainhand.getID() == "weapon.tail_whip")
					items.unequip(mainhand);
				// Also check bag for tail
				local bagItems = items.getAllItemsAtSlot(this.Const.ItemSlot.Bag);
				foreach (item in bagItems)
				{
					if (item != null && item.getID() == "weapon.tail_whip")
						items.removeFromBag(item);
				}
				woman.getFlags().remove("lewdTailGranted");
				::logInfo("[mod_lewd] Save migration: removed tail weapon");
			}

			if (refunded > 0)
				::logInfo("[mod_lewd] Save migration: refunded " + refunded + " succubus perks");

			// Reset quest stage; gheist encounter will trigger naturally after next ghost battle
			this.World.Flags.set("lewdEtherealQuestStage", 0);
			::logInfo("[mod_lewd] Save migration: quest stage reset to 0, gheist encounter will trigger after next ghost battle");
		};
	});

	// Hook updateLook to restore lewd world map figure after camp/town leave
	mod.hook("scripts/states/world/asset_manager", function(q)
	{
		q.updateLook = @(__original) function( _updateTo = -1 )
		{
			__original(_updateTo);

			local player = this.World.State.getPlayer();
			if (player == null) return;

			local woman = ::Lewd.Transform.target();
			if (woman == null) return;

			local figureBrush = null;
			if (woman.getSkills().hasSkill("trait.ethereal"))
				figureBrush = "figure_player_ethereal";
			else if (woman.getSkills().hasSkill("trait.delicate"))
				figureBrush = "figure_player_delicate";
			else if (woman.getSkills().hasSkill("trait.dainty"))
				figureBrush = "figure_player_dainty";

			if (figureBrush != null)
			{
				player.getSprite("body").setBrush(figureBrush);
				player.getSprite("body").setHorizontalFlipping(false);
			}
		};
	});

	// Register pleasure bar CSS
	::mods_registerCSS("mod_lewd/pleasure_bar.css");

	foreach (dir in [
		"mod_lewd/lib",
	]) {
		foreach (file in ::IO.enumerateFiles(dir))
			::include(file);
	}
});