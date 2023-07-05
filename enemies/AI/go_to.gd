extends ActionLeaf

@export var target : Node3D
@export var enemy : CharacterBody3D

func tick(actor, blackboard):
	set_target()
	return SUCCESS

func set_target():
	enemy.set_target_node(target)
