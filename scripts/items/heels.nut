this.heels <- this.inherit("scripts/items/accessory/accessory", {
	function defineHeels(_height, _allure)
	{
		this.getFlags().set("heelHeight", _height);
		this.getFlags().set("allureHeels", _allure);
	}

	function onEquip()
	{
		this.accessory.onEquip();
		local actor = this.getContainer().getActor();
		// we will be overwriting the footstep sounds with the heel walking effect, so disable them here
		actor.m.IsEmittingMovementSounds = false;

		actor.getFlags().set("heelHeight", this.getFlags().get("heelHeight"));
		actor.getFlags().set("allureHeels", this.getFlags().get("allureHeels"));

		local skill = this.new("scripts/skills/effects/entrancing_beauty_effect");
		skill.setItem(this);
		this.addSkill(skill);

		skill = this.new("scripts/skills/effects/heel_walking_effect");
		skill.setItem(this);
		this.addSkill(skill);

		::logInfo("Equipped heels with heel height: " + actor.getFlags().get("heelHeight"));
	}

	function onUnequip()
	{
		this.accessory.onUnequip();
		local actor = this.getContainer().getActor();
		actor.m.IsEmittingMovementSounds = true;

		actor.getFlags().set("heelHeight", 0);
		actor.getFlags().set("allureHeels", 0);
		::logInfo("Unequipped heels, reset heel height to: " + actor.getFlags().get("heelHeight"));
	}



	function onRemoveWhileCursed()
	{
		::logInfo("Try to remove cursed item this: " + this.getName());
		// TODO fire event that explains this more immersively
	}
});
