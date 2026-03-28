this.lewd_gold_bar_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.lewd_gold_bar";
		this.m.Name = "Gold Bar";
		this.m.Description = "A bar of gold smelted from various golden trinkets. Useful for crafting fine jewelry, or valuable enough to sell to a trader.";
		this.m.Icon = "trade/inventory_trade_gold_bars.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.Value = 900;
		this.m.ResourceValue = 2;
	}
});
