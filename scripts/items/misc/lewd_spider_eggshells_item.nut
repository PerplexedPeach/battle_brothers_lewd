// Spider Eggshells -- left behind after opening a spider egg sac.
// Stackable flavor item confirming a successful hatch.
this.lewd_spider_eggshells_item <- this.inherit("scripts/items/item", {
	m = {
		Amount = 1,
		IsStackable = true
	},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.lewd_spider_eggshells";
		this.m.Name = "Spider Eggshells";
		this.m.Description = "Cracked shells and sticky remnants of a spider egg. Whatever was inside has already hatched or been claimed.";
		this.m.Icon = "misc/inventory_spider_eggshells.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc;
		this.m.IsAllowedInBag = false;
		this.m.Value = 5;
	}

	function setAmount( _n )
	{
		this.m.Amount = _n;
		this.m.Value = 5 * _n;
	}

	function getAmount()
	{
		return this.m.Amount;
	}

	function isAmountShown()
	{
		return this.m.Amount > 1;
	}

	function getAmountString()
	{
		return "" + this.m.Amount;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

	function onSerialize( _out )
	{
		this.item.onSerialize(_out);
		_out.writeU16(this.m.Amount);
	}

	function onDeserialize( _in )
	{
		this.item.onDeserialize(_in);
		this.m.Amount = _in.readU16();
		this.m.Value = 5 * this.m.Amount;
	}
});
