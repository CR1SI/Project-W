class_name walk_state
extends State

@onready var idle: idle_state = $"../idle"
@onready var dodge: dodge_state = $"../dodge"

@export var acceleration: float = 50.0

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO: #if we stop walking/no direction we return idle.
		return idle
	
	player.velocity = player.velocity.lerp((player.direction).normalized() * player.stats.speed, acceleration * _delta) #.normalized allows for the diagnoal velocity to be equal to the horizontal and vertical. 
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State:
	if Input.is_action_pressed("dodge") and dodge.can_dash: 
		return dodge
	return null
