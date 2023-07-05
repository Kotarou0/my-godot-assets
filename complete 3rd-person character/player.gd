extends CharacterBody3D

const BASE_SPEED = 10.0
const ACCELERATION = 5.0
const DEFAULT_SPRING_LENGTH = 3.0
const CAMERA_FOLLOW_SPEED = 3
const CAMERA_FOLLOW_MULTIPLIER = 0.05
const SPEED_MULTIPLIER = 1.5
const JUMP_SPEED = 10

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_vector = ProjectSettings.get_setting("physics/3d/default_gravity_vector")
var direction = Vector2.ZERO
var speed_multiplier = 1.0
@onready var camera = $Pivot/h/v/Camera3D

@export var animation_tree : AnimationTree
var default_animation_parameter = "parameters/action/blend_position"
var do_action = "parameters/do_action/request"
var last_action = ""
var actions = InputMap.get_actions()

func _ready():
	EventBus.get_player.connect(return_player)

func return_player():
	EventBus.return_player.emit(self)

func _input(event):
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = -Input.get_axis("ui_down", "ui_up")
	if event.is_action_pressed("run"):
		speed_multiplier = SPEED_MULTIPLIER
	if event.is_action_released("run"):
		speed_multiplier = 1
	direction = direction.normalized()
	direction = direction.rotated(-camera.global_rotation.y)
	
	if animation_tree["parameters/do_action/active"]:
		direction = Vector2.ZERO
	elif is_zero_approx(velocity.y):
		for action in actions:
			if event.is_action(action):
				last_action = action
	
	if event.is_action_pressed("jump") and is_on_floor(): velocity.y = JUMP_SPEED

func _physics_process(delta):
	if direction:
		$Visual.look_at(position + Vector3(direction.x, 0, direction.y))
	velocity.x = lerp(velocity.x, direction.x * BASE_SPEED * speed_multiplier, ACCELERATION*delta)
	velocity.z = lerp(velocity.z, direction.y * BASE_SPEED * speed_multiplier, ACCELERATION*delta)
	
	velocity += gravity_vector*gravity*delta
	move_and_slide()
	
	if velocity.length() > 0:
		$Pivot/h/v.spring_length = lerp($Pivot/h/v.spring_length, 
			DEFAULT_SPRING_LENGTH*(1+velocity.length()*CAMERA_FOLLOW_MULTIPLIER), 
			CAMERA_FOLLOW_SPEED * delta)
		speed_multiplier *= 1 + delta * 0.01 
	else:
		speed_multiplier = 1
	
	animation_tree["parameters/run/blend_amount"] = clamp((velocity.x**2 + velocity.z**2)**(0.5)/BASE_SPEED, 0, 1)
	
	if not is_on_floor():
		if velocity.y < 0:
			animation_tree["parameters/jump/blend_amount"] = lerp(float(animation_tree["parameters/jump/blend_amount"]), 1.0, delta)
		else:
			animation_tree["parameters/jump/blend_amount"] = clamp(2.69*abs(1 - abs(velocity.y/JUMP_SPEED)), 0, 1)
	else:
		animation_tree["parameters/jump/blend_amount"] = lerp(animation_tree["parameters/jump/blend_amount"], 0.0, 3.9*delta)
