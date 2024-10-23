class_name idle_state
extends State

@onready var walk: walk_state = $"../walk"
@onready var dodge: dodge_state = $"../dodge"

func Enter() -> void:
	#we would call idle animation here
	pass

func Exit() -> void: 
	pass

func Process(_delta: float) -> State:
	if player.direction != Vector2.ZERO: #if the player is moving we go to walk state
		return walk
	
	player.velocity = Vector2.ZERO #constantly set velocity to zero because we are not moving
	
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State:
	if Input.is_action_pressed("dodge") and dodge.can_dash: #when dodge is pressed we dodge.
		return dodge 
	return null
