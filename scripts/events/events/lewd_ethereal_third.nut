// Deprecated: replaced by lewd_ethereal_tentacle_destroyed.nut (quest chain).
// Kept as stub so old saves referencing this event ID don't crash.
this.lewd_ethereal_third <- this.inherit("scripts/events/event", {
	m = {
		Woman = null
	},
	function create()
	{
		this.m.ID = "event.lewd_ethereal_third";
		this.m.Title = "Reincarnation of Daji";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
	}

	function onUpdateScore()
	{
		this.m.Score = 0;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Woman = null;
	}
});
