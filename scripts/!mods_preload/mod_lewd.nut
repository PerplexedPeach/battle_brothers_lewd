::Lewd <- {
	ID = "mod_lewd",
	Version = "1.3.0",
	Name = "Lewdness",
	IsStartingNewCampaign = false
};

::Lewd.Const <- {};

// ::mods_registerMod(::Lewd.ID, ::Lewd.Version, ::Lewd.Name);
local mod = ::Hooks.register(::Lewd.ID, ::Lewd.Version, ::Lewd.Name);

mod.require("mod_legends", "mod_msu");

// ::mods_queue(modID, "mod_legends,mod_msu", function()
mod.queue(">mod_legends", ">mod_msu", ">mod_ROTUC" function()
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

	// TODO when these get large, refactor out into separate files and include them
	mod.hook("scripts/entity/tactical/actor", function (q)
	{
		// Add Pleasure as a member variable on actor (same pattern as m.Fatigue)
		q.m.Pleasure <- 0;
		q.m.LastPleasureSourceID <- -1; // ID of actor who last dealt pleasure (for Insatiable perk)

		// Add lewd_glow sprite layer for pheromone visual effects, and add lewd_info_effect to all actors
		q.onInit = @(__original) function()
		{
			local self = this;
			local old_addSprite = self.addSprite;
			self.addSprite = function (_layerID)
			{
				local ret = old_addSprite(_layerID);

				if (_layerID == "socket")
				{
					old_addSprite("lewd_glow");
				}

				return ret;
			};
			__original();
			this.getSkills().add(this.new("scripts/skills/effects/lewd_info_effect"));
			this.getSkills().add(this.new("scripts/skills/effects/lewd_subdom_effect"));
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
				this.m.Pleasure = 0;
				this.onClimax();
			}
			else
			{
				this.m.Pleasure = this.Math.max(0, this.Math.round(cur));
			}
		}

		q.onClimax <- function() {
			if (!this.getSkills().hasSkill("effects.climax"))
			{
				local effect = this.new("scripts/skills/effects/climax_effect");
				this.getSkills().add(effect);
			}
		}

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

	foreach (dir in [
		"mod_lewd/lib",
	]) {
		foreach (file in ::IO.enumerateFiles(dir))
			::include(file);
	}
});