class_name walk_state
extends State

@onready var idle: idle_state = $"../idle"
@onready var dodge: dodge_state = $"../dodge"

@export var player_speed: float = 500.0

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO: 
		return idle
	
	player.velocity = (player.direction).normalized() * player_speed
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State:
	if Input.is_action_pressed("dodge"): 
		return dodge
	return null
