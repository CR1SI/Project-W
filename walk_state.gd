class_name walk_state
extends State

@onready var idle: idle_state = $"../idle"
@onready var dodge: dodge_state = $"../dodge"

@export var player_speed: float = 500.0 #we can set speed here or in the player script, but here we can see it. @export allows to be edited in the side panel.

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO: #if we stop walking/no direction we return idle.
		return idle
	
	player.velocity = (player.direction).normalized() * player_speed #.normalized allows for the diagnoal velocity to be equal to the horizontal and vertical. 
	player.last_direction = player.direction #we are setting the last_direction here to later use it for dodge. however we will change it to dodge where the mouse is.
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State:
	if Input.is_action_pressed("dodge"): 
		return dodge
	return null
