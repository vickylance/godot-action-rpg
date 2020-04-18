extends KinematicBody2D

export var ACCELERATION := 1000
export var MAX_SPEED := 400
export var FRICTION := 400

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity := Vector2.ZERO

onready var animPlayer := $Anim
onready var animTree := $AnimTree
onready var animState = animTree.get("parameters/playback")

func _ready() -> void:
	animTree.active = true

func _physics_process(delta) -> void:
	match 	state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)

func move_state(delta):
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animTree.set("parameters/idle/blend_position", input_vector)
		animTree.set("parameters/run/blend_position", input_vector)
		animTree.set("parameters/attack/blend_position", input_vector)
		animState.travel("run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animState.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	velocity = Vector2.ZERO
	animState.travel("attack")

func attack_anim_finished():
	state = MOVE

func roll_state(delta):
	pass
