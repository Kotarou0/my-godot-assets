extends ConditionLeaf

@onready var player: CharacterBody3D = get_parent().player
@onready var action_key = get_parent().action_key

func tick(actor, blackboard):
	if player.last_action != action_key:
		return FAILURE
	player.last_action = ""
	return SUCCESS
