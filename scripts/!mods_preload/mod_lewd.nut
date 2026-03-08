::Lewd <- {
	ID = "mod_lewd",
	Version = "1.4.2",
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
	::Const.AI.Behavior.ID.COUNT = count;
	::Const.AI.Behavior.Name.push("LewdHorny");
	::Const.AI.Behavior.Name.push("LewdHornyEngage");
	::Lewd.Const.AIBehaviorIDHorny = ::Const.AI.Behavior.ID.LewdHorny;
	::Lewd.Const.AIBehaviorIDHornyEngage = ::Const.AI.Behavior.ID.LewdHornyEngage;

	// TODO when these get large, refactor out into separate files and include them
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

				if (_layerID == "socket")
				{
					old_addSprite("lewd_glow");
				}
				else if (_layerID == "status_stunned")
				{
					local horny = old_addSprite("status_horny");
					horny.Visible = false;
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
			this.getSkills().add(this.new("scripts/skills/actives/allied_grope_skill"));
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
			if (max <= 0) return;
			local amount = _amount;
			// mounted targets take extra pleasure
			if (this.getSkills().hasSkill("effects.lewd_mounted") && amount > 0)
			{
				amount = this.Math.floor(amount * ::Lewd.Const.MountPleasureVulnerability);
			}
			// Embrace Pain perk: self-pleasure restores fatigue
			if (amount > 0 && this.getSkills().hasSkill("perk.lewd_embrace_pain"))
			{
				local fatigueRestore = amount * ::Lewd.Const.EmbracePainFatigueRestore;
				this.m.Fatigue = this.Math.max(0, this.m.Fatigue - fatigueRestore);
			}
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
		}

		q.onClimax <- function() {
			this.m.OrgasmCount++;

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

			// Check defeat AFTER perks have fired
			if (::Lewd.Const.OrgasmDefeatEnabled)
			{
				local threshold = ::Lewd.Mastery.getOrgasmThreshold(this);
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
			// Actual kill happens in climax_effect.onTurnEnd
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

	});

	// hook item container to care about items' cursed status
	mod.hook("scripts/items/item_container", function(q)
	{
		q.unequip = @(__original) function(_item) {
			 // check item flags for cursed, if cursed, don't unequip and maybe show some kind of message about the item being cursed
			 if (_item != null && _item.getFlags().has("cursed"))
			 {
				if ("onRemoveWhileCursed" in _item) {
					_item.onRemoveWhileCursed();
				}
				 // TODO add some kind of message about the item being cursed and not unequipping
				 return false;
			 }
			 return __original(_item);
		};
	});

	// Perk tree injection is handled by the traits themselves (dainty, delicate, masochism)
	// via onAdded() using Legends' addPerkGroup/hasPerkGroup API

	// Player orgasm defeat: go unconscious instead of dying
	mod.hook("scripts/entity/tactical/player", function(q) {
		q.isReallyKilled = @(__original) function( _fatalityType ) {
			if (this.getFlags().has("lewdPleasureDeath"))
				return false; // -> unconscious, recoverable after battle
			return __original(_fatalityType);
		};
	});

	// Add pleasure bar + orgasm count to tactical tooltip (player characters)
	mod.hook("scripts/entity/tactical/player", function(q) {
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

	// Embrace Pain: auto-pass morale loss checks
	mod.hook("scripts/entity/tactical/actor", function(q)
	{
		// _type default: 0 = Const.MoraleCheckType.Default (can't use `this.Const` here, LSP chokes on it)
		q.checkMorale = @(__original) function( _change, _difficulty, _type = 0, _showIconBeforeMoraleIcon = "", _noNewLine = false )
		{
			if (_change < 0 && this.getSkills().hasSkill("perk.lewd_embrace_pain"))
				return false;
			return __original(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
		};
	});

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
			if (!actor.isPlayerControlled()) return;
			if (actor.getGender() == 1) return; // only males harass
			if (!actor.getSkills().hasSkill("effects.lewd_horny")) return; // must be horny
			local gropeSkill = actor.getSkills().getSkillByID("actives.allied_grope");
			if (gropeSkill == null) return;
			if (actor.getActionPoints() < gropeSkill.getActionPointCost()) return;

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
			if (roll <= chance)
			{
				::logInfo("[harassment] TRIGGERED roll:" + roll + " <= " + chance);
				gropeSkill.use(bestTarget.getTile());
			}
			else
			{
				::logInfo("[harassment] missed roll:" + roll + " > " + chance);
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

			if (!this.World.Statistics.getFlags().get("lewdFoughtHexen"))
				return;

			this.World.Statistics.getFlags().set("lewdFoughtHexen", false);

			// Must have won
			if (this.World.Statistics.getFlags().getAsInt("LastCombatResult") != 1)
				return;

			// Find eligible male avatar (not already cursed or transformed)
			local brothers = this.World.getPlayerRoster().getAll();
			foreach (bro in brothers)
			{
				if (bro.getGender() == 0 && bro.getFlags().get("IsPlayerCharacter")
					&& !bro.getFlags().has("lewdHexenCursed") && ::Lewd.Mastery.getLewdTier(bro) == 0)
				{
					::logInfo("[mod_lewd] Firing hexen curse event for " + bro.getName());
					this.World.Events.fire("event.lewd_hexen_curse");
					return;
				}
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