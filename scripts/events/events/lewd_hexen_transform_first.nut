this.lewd_hexen_transform_first <- this.inherit("scripts/events/event", {
	m = {
		Man = null
	},
	function create()
	{
		this.m.ID = "event.lewd_hexen_transform_first";
		this.m.Title = "The Seed Stirs";
		this.m.Cooldown = 999999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/hexen_transform_1.png[/img]Three days since the Hexen fight, and the cold hasn't faded. If anything, it has spread.\n\nYou first noticed it while shaving. The razor caught less stubble than usual, and when you ran a hand across your jaw, the skin felt smoother than any blade could achieve. You told yourself it was nothing. Then came the ache in your joints, a dull, persistent pressure in your hips and shoulders as though your bones were being slowly reshaped on an invisible anvil. You told yourself that was nothing too.\n\nBut you can't ignore what you see in the mirror this morning.\n\nYour face has changed. The jaw has narrowed, the cheekbones risen slightly, giving your reflection an androgynous cast that wasn't there a week ago. Your skin, always weathered from years of campaigning, has cleared. Scars haven't vanished, but they've faded, smoothed into pale lines against skin that now has the texture of doeskin rather than old leather.\n\nYour hands shake as you touch your own cheek. The cold pulses beneath your sternum, and you swear you can feel it smiling.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The changes are getting harder to hide.",
					function getResult( _event )
					{
						return "B";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Man.getImagePath());
			}
		});

		this.m.Screens.push({
			ID = "B",
			Text = "It is not just your face. Your body is shifting.\n\nYour armor sits differently now, loose where it used to be tight and tight where it used to be loose. Your shoulders have narrowed enough that your pauldrons slip if you don't cinch the straps. Your waist, on the other hand, seems to be drawing inward, and there is a softness developing at your chest and hips that no amount of training seems to counteract.\n\nThe brothers have noticed. They haven't said anything directly, not yet, but you catch the sidelong glances. %randombrother% walked past you yesterday and did a visible double-take before muttering something about the light playing tricks.\n\nAt night, alone in your tent, you press your fingers to the cold spot beneath your ribs. It pulses in response, warm now rather than cold, as though the seed the Hexen planted has germinated and the roots are threading through your whole body. You can feel them, thin tendrils of change working through muscle and bone, dismantling what was and building something new in its place.\n\nYou should be terrified. Part of you is. But there is another part, deeper and quieter, that watches the transformation with something uncomfortably close to curiosity.\n\nWhatever the Hexen intended, it is well underway. And you are not sure you want it to stop.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You are losing yourself. Or finding something else.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local man = _event.m.Man;
				man.getFlags().set("lewdHexenTransformStage", 1);

				this.List.push({
					id = 10,
					type = "text",
					icon = "ui/icons/special.png",
					text = "The Hexen's curse is reshaping your body."
				});

				this.Characters.push(man.getImagePath());
			}
		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		this.m.Man = null;

		foreach (bro in brothers)
		{
			if (bro.getFlags().get("lewdHexenCursed") && !bro.getFlags().has("lewdHexenTransformStage"))
			{
				this.m.Man = bro;
				break;
			}
		}

		if (this.m.Man == null)
		{
			this.m.Score = 0;
			return;
		}

		this.m.Score = ::Lewd.Const.HexenTransformFirstBaseScore;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"man",
			this.m.Man.getName()
		]);
	}

	function onClear()
	{
		this.m.Man = null;
	}
});
