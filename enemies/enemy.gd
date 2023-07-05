extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_vector = ProjectSettings.get_setting("physics/3d/default_gravity_vector")

@export var base_speed = 7.0

## Minimum distance to target that the enemy needs to get. Set higher for big enemies.
@export var target_desired_distance = 5.0

## Set to lower if enemy is stuck at corners.
@export var path_desired_distance = 1.0
@onready var navigation_agent = $NavigationAgent3D

## Minimum distance to the end of the current path segment before updating the target position.
## Set to higher if the enemy need to update it frequently.
@export var path_threshold = 1.5
var next_path_position
var target

@export var distance_to_attack : float = 5.0

func _ready():
	navigation_agent.path_desired_distance = path_desired_distance
	navigation_agent.target_desired_distance = target_desired_distance

func _physics_process(delta):
	if target and next_path_position:
		if global_position.distance_to(next_path_position) < path_threshold or velocity == Vector3.ZERO:
			update_target_position()
			move_to_target()
	velocity += gravity * gravity_vector
	look_at(global_position + velocity - velocity.y * Vector3.UP)
	move_and_slide()

func set_target_node(target_node):
	target = target_node
	update_target_position()
	move_to_target()

func update_target_position():
	navigation_agent.target_position = target.global_position

func move_to_target():
	if global_position.distance_to(navigation_agent.target_position) <= distance_to_attack:
		navigation_agent.target_position = global_position
	next_path_position = navigation_agent.get_next_path_position()
	velocity = global_position.direction_to(next_path_position) * base_speed
