class_name melee_state
extends State

@onready var idle: idle_state = $"../idle"
@onready var walk: walk_state = $"../walk"
@onready var dodge: dodge_state = $"../dodge"
@onready var melee: melee_state = $"../melee"

func Enter() -> void: 
	pass

func Exit() -> void: 
	pass

func Process(_delta: float) -> State: 
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State: 
	return null
