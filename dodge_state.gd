class_name dodge_state
extends State

@onready var walk: walk_state = $"../walk"
@onready var idle: idle_state = $"../idle"

@export var dash_speed: float = 1000.0
@export var dash_duration: float = 0.3

var timer: float = 0.0


func Enter() -> void:
	var dash_direction = player.direction
	if dash_direction == Vector2.ZERO:
		dash_direction = player.last_direction #must inplment
		pass
	
	if dash_direction != Vector2.ZERO: 
		player.velocity = dash_direction.normalized() * dash_speed
		timer = dash_duration
	else:
		pass

func Exit() -> void:
	player.velocity = Vector2.ZERO 
	pass

func Process(_delta: float) -> State:
	timer -= _delta
	if timer <= 0.0:
		if player.direction != Vector2.ZERO: 
			return walk
		else: 
			return idle
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State: 
	return null
