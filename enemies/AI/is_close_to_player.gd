extends ConditionLeaf

@export var enemy : CharacterBody3D
var player

func _ready():
	EventBus.return_player.connect(set_player)
	EventBus.get_player.emit()

func set_player(node):
	player = node

func tick(actor, blackboard):
	if not player:
		return FAILURE
	if enemy.global_position.distance_to(player.global_position) <= enemy.distance_to_attack:
		return SUCCESS
	return FAILURE
