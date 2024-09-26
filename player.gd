class_name Player
extends CharacterBody2D

@onready var state_machine: StateMachine = $StateMachine
var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2

func _ready() -> void:
	state_machine.Initialize(self)
	pass

func _process(_delta: float) -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	pass

func _physics_process(delta: float) -> void:
	move_and_slide()

func upd_last_direction(dir: Vector2) -> void: 
	pass
