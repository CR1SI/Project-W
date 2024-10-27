class_name casting_state
extends State

@onready var idle: idle_state = $"../idle"
@onready var walk: walk_state = $"../walk"
@onready var dodge: dodge_state = $"../dodge"
@onready var melee: melee_state = $"../melee"

@onready var spell_manager: SpellManager = $"../../SpellManager"

var cast_done: bool = false

func Enter() -> void:
	#play animation without allowing for movement. if player moves, cancel cast.
	cast_done = false
	player.velocity = Vector2.ZERO
	if spell_manager.selected_spell > -1:
		await get_tree().create_timer(3.0).timeout
		spell_manager.cast_spell(spell_manager.selected_spell)
		cast_done = true
		Exit()
	else:
		pass

func Exit() -> void:
	spell_manager.selected_spell = -1
	pass

func Process(_delta: float) -> State:
	if cast_done: 
		return idle
	return self

func Physics(_delta: float) -> State: 
	if cast_done: 
		return self
	return null

func Handle_Input(_event: InputEvent) -> State: 
	return null
