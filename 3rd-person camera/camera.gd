extends Node3D

const H_ACCELERATION = 3
const V_ACCELERATION = 3
const V_MIN = -45
const V_MAX = 80

var direction = Vector2.ZERO
var h_sensitivity = 1
var v_sensitivity = 1

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		direction.x += -event.relative.x * h_sensitivity
		direction.y += event.relative.y * v_sensitivity
		print(direction.y)
		direction.y = clamp(direction.y, V_MIN, V_MAX)

func _physics_process(delta):
	$h.rotation_degrees.y = lerp($h.rotation_degrees.y, direction.x, H_ACCELERATION * delta)
	$h/v.rotation_degrees.x = lerp($h/v.rotation_degrees.x, direction.y, V_ACCELERATION * delta)
