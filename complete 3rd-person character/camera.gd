extends Node3D

const H_ACCELERATION = 3
const V_ACCELERATION = 3
const V_MIN = -45
const V_MAX = 80

var direction = Vector2.ZERO
var h_sensitivity = 0.75
var v_sensitivity = 0.75

var focus = false
var enemy

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("focus") and enemy:
		focus = !focus
	if not focus and event is InputEventMouseMotion:
		direction.x += -event.relative.x * h_sensitivity
		direction.y += event.relative.y * v_sensitivity
		direction.y = clamp(direction.y, V_MIN, V_MAX)

func _physics_process(delta):
	if not focus:
		$h.rotation_degrees.y = lerp($h.rotation_degrees.y, direction.x, H_ACCELERATION * delta)
		$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, direction.y, V_ACCELERATION * delta)
	else:
		$h.look_at(enemy.global_position)

func _on_area_3d_body_entered(body):
	if body.is_in_group("enemy"):
		enemy = body

func _on_area_3d_body_exited(body):
	if body == enemy:
		enemy = null
		focus = false
