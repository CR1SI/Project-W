class_name casting_state
extends State

@onready var idle: idle_state = $"../idle"
@onready var walk: walk_state = $"../walk"
@onready var dodge: dodge_state = $"../dodge"
@onready var melee: melee_state = $"../melee"

@onready var spell_manager: SpellManager = $"../../SpellManager"

var cast_done: bool = false

func Enter() -> void:
	#player.UpdateAnimation("casting")
	#play animation without allowing for movement. if player moves, cancel cast.
	player.velocity = Vector2.ZERO
	
	if spell_manager.selected_spell > -1 and spell_manager.spell_fired == false:
		if spell_manager.is_targeting:
			var target_position: Vector2 = spell_manager.target_radius.global_position
			spell_manager.cast_spell(spell_manager.selected_spell, target_position)
		else:
			spell_manager.cast_spell(spell_manager.selected_spell, player.position)
		cast_done = true
	else: 
		cast_done = false


func Exit() -> void:
	@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
	spell_manager.selected_spell = -1
	cast_done = false

func Process(_delta: float) -> State:
	if cast_done: 
		return idle
	
	if player.setDirection():
		player.UpdateAnimation("casting")
	return self

func Physics(_delta: float) -> State: 
	if cast_done: 
		return self
	return null

func Handle_Input(_event: InputEvent) -> State: 
	return null
