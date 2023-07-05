extends "res://enemies/AI/go_to.gd"

func _ready():
	EventBus.return_player.connect(set_player)
	EventBus.get_player.emit()

func set_player(player):
	target = player

func tick(actor, blackboard):
	if not target:
		EventBus.get_player.emit()
		return FAILURE
	set_target()
	return SUCCESS
