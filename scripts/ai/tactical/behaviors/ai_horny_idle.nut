// AI behavior for horny entities that can't reach a target
// Returns a score that beats normal combat AI, causing the entity to
// do nothing rather than attack with weapons while horny
// Shared by all species (not goblin-specific)
this.ai_horny_idle <- this.inherit("scripts/ai/tactical/behavior", {
	m = {},
	function create()
	{
		this.m.ID = ::Lewd.Const.AIBehaviorIDHornyIdle;
		this.m.Order = this.Const.AI.Behavior.Order.AttackDefault;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Only activate when horny
		if (!_entity.getSkills().hasSkill("effects.lewd_horny"))
			return 0;

		// Don't idle if fleeing
		if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
			return 0;

		// This is a fallback — only score if we have AP left that would
		// otherwise be spent on weapon attacks
		if (_entity.getActionPoints() < 2)
			return 0;

		// Score just high enough to beat most normal combat behaviors
		// but low enough that actual sex skills and engage will beat it
		return ::Lewd.Const.HornyIdleAIScore * this.getProperties().BehaviorMult[this.m.ID];
	}

	function onExecute( _entity )
	{
		// Do nothing — consume the turn
		::logInfo("[ai_horny_idle] " + _entity.getName() + " is too aroused to fight (AP:" + _entity.getActionPoints() + ")");
		_entity.setActionPoints(0);
		return true;
	}
});
