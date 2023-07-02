extends CharacterBody3D

const BASE_SPEED = 10.0
const ACCELERATION = 5.0
const DEFAULT_SPRING_LENGTH = 6.9
const CAMERA_FOLLOW_SPEED = 3
const CAMERA_FOLLOW_MULTIPLIER = 0.075
const SPEED_MULTIPLIER = 1.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_vector = ProjectSettings.get_setting("physics/3d/default_gravity_vector")
var direction = Vector2.ZERO
var speed_multiplier = 1.0
@onready var camera = $Pivot/h/v/Camera3D

func _input(event):
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = -Input.get_axis("ui_down", "ui_up")
	if event.is_action_pressed("run"):
		speed_multiplier = SPEED_MULTIPLIER
	if event.is_action_released("run"):
		speed_multiplier = 1
	direction = direction.normalized()
	direction = direction.rotated(-camera.global_rotation.y)

func _physics_process(delta):
	if direction:
		$Visual.look_at(position + Vector3(direction.x, 0, direction.y))
	velocity.x = lerp(velocity.x, direction.x * BASE_SPEED * speed_multiplier, ACCELERATION*delta)
	velocity.z = lerp(velocity.z, direction.y * BASE_SPEED * speed_multiplier, ACCELERATION*delta)
	velocity += gravity_vector*gravity*delta
	move_and_slide()
	
	$Pivot/h/v.spring_length = lerp($Pivot/h/v.spring_length, 
		DEFAULT_SPRING_LENGTH*(1+velocity.length()*CAMERA_FOLLOW_MULTIPLIER), 
		CAMERA_FOLLOW_SPEED * delta)
