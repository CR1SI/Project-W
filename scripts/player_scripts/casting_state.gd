class_name casting_state
extends State

@onready var idle: idle_state = $"../idle"
@onready var walk: walk_state = $"../walk"
@onready var dodge: dodge_state = $"../dodge"
@onready var melee: melee_state = $"../melee"

@onready var spell_manager: SpellManager = $"../../SpellManager"


func Enter() -> void:
	#play animation without allowing for movement. if player moves, cancel cast.
	await get_tree().create_timer(1.0).timeout
	#spell_manager.cast_spell(spell_manager.SpellType.FIREBALL) #this is a test, we would want to check which spell is selected and fire based on that!
	pass

func Exit() -> void: 
	pass

func Process(_delta: float) -> State:
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State: 
	return null
