class_name melee_state
extends State

@onready var idle: idle_state = $"../idle"
@onready var walk: walk_state = $"../walk"
@onready var dodge: dodge_state = $"../dodge"
@onready var melee: melee_state = $"../melee"
@onready var spell_manager: SpellManager = $"../../SpellManager"
@onready var casting: casting_state = $"../casting"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

var done = false
#TODO something glitched with mellee state
func Enter() -> void:
	animation_player.play("melee_stomp")
	await animation_player.animation_finished
	done = true

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	if done:
		return idle
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State:
	if Input.is_action_pressed("dodge") and dodge.can_dash: #when dodge is pressed we dodge.
		return dodge 
	
	if Input.is_action_just_pressed("leftClick") and spell_manager.selected_spell > -1 and spell_manager.spell_fired == false: 
		if spell_manager.is_targeting: 
			spell_manager.stop_targeting()
		else:
			return casting
	return null
