class_name casting_state
extends State

@onready var idle: idle_state = $"../idle"
@onready var walk: walk_state = $"../walk"
@onready var dodge: dodge_state = $"../dodge"
@onready var melee: melee_state = $"../melee"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

@onready var spell_manager: SpellManager = $"../../SpellManager"

var cast_done: bool = false

func Enter() -> void:
	if animation_player.current_animation == "idle_long_end_left" or animation_player.current_animation == "idle_long_end_right" or animation_player.current_animation == "idle_long_end_down" or animation_player.current_animation == "idle_long_end_up":
		await animation_player.animation_finished
	#player.UpdateAnimation("casting") #TODO add casting animation
	player.velocity = Vector2.ZERO
	
	if spell_manager.selected_spell > -1 and spell_manager.spell_fired == false:
		if spell_manager.is_targeting:
			var target_position: Vector2 = spell_manager.target_radius.global_position
			spell_manager.cast_spell(spell_manager.selected_spell, target_position)
		else:
			spell_manager.cast_spell(spell_manager.selected_spell, Vector2(player.position.x + player.last_direction.x * 50 , player.position.y + player.last_direction.y * 50))
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
	if Input.is_action_just_pressed("leftClick") and spell_manager.selected_spell == -1:
		return melee
	return null
