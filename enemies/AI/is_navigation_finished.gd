extends ConditionLeaf

@export var enemy : CharacterBody3D

func tick(actor, blackboard):
	if not enemy:
		return FAILURE
	if enemy.navigation_agent.is_navigation_finished():
		return SUCCESS
	return FAILURE
