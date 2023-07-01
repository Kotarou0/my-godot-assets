extends CharacterBody3D

const BASE_SPEED = 10.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_vector = ProjectSettings.get_setting("physics/3d/default_gravity_vector")
var direction = Vector2.ZERO
@onready var camera = $Pivot/h/v/Camera3D

func _input(event):
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = -Input.get_axis("ui_down", "ui_up")
	direction = direction.normalized()
	if camera:
		direction = direction.rotated(-camera.global_rotation.y)

func _physics_process(delta):
	if direction:
		$Visual.look_at(position + Vector3(direction.x, 0, direction.y))
	velocity.x = direction.x * BASE_SPEED
	velocity.z = direction.y * BASE_SPEED
	velocity += gravity_vector*gravity*delta
	move_and_slide()
