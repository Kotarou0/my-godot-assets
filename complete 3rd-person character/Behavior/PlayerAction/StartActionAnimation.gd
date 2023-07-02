extends ActionLeaf

@onready var player = get_parent().player
@onready var default_animation_parameter = player.default_animation_parameter
@onready var do_action = player.do_action
@onready var animation_value = get_parent().animation_value

func tick(actor, blackboard):
#	if player.animation_tree[default_animation_parameter] != 0:
#		return FAILURE
	player.animation_tree[do_action] = 1
	player.animation_tree[default_animation_parameter] = animation_value
	return SUCCESS
