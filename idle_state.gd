class_name idle_state
extends State

@onready var walk: walk_state = $"../walk"
@onready var dodge: dodge_state = $"../dodge"



func Enter() -> void:
	pass

func Exit() -> void: 
	pass

func Process(_delta: float) -> State:
	if player.direction != Vector2.ZERO: 
		return walk
	
	player.velocity = Vector2.ZERO
	
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State:
	if Input.is_action_pressed("dodge"): 
		return dodge 
	return null
