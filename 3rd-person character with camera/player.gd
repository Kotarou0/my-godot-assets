extends CharacterBody3D

const BASE_SPEED = 10.0
const ACCELERATION = 5.0
const DEFAULT_SPRING_LENGTH = 6.9
const CAMERA_FOLLOW_SPEED = 4
const CAMERA_FOLLOW_MULTIPLIER = 0.075
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_vector = ProjectSettings.get_setting("physics/3d/default_gravity_vector")
var direction = Vector2.ZERO
@onready var camera = $Pivot/h/v/Camera3D

func _input(event):
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = -Input.get_axis("ui_down", "ui_up")
	direction = direction.normalized()
	direction = direction.rotated(-camera.global_rotation.y)

func _physics_process(delta):
	if direction:
		$Visual.look_at(position + Vector3(direction.x, 0, direction.y))
	velocity.x = lerp(velocity.x, direction.x * BASE_SPEED, ACCELERATION*delta)
	velocity.z = lerp(velocity.z, direction.y * BASE_SPEED, ACCELERATION*delta)
	velocity += gravity_vector*gravity*delta
	move_and_slide()
	
	$Pivot/h/v.spring_length = lerp($Pivot/h/v.spring_length, 
		DEFAULT_SPRING_LENGTH*(1+velocity.length()*CAMERA_FOLLOW_MULTIPLIER), 
		CAMERA_FOLLOW_SPEED * delta)
