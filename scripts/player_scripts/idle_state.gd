class_name idle_state
extends State

@onready var walk: walk_state = $"../walk"
@onready var dodge: dodge_state = $"../dodge"
@onready var melee: melee_state = $"../melee"
@onready var casting: casting_state = $"../casting"

@onready var spell_manager: SpellManager = $"../../SpellManager"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"


func Enter() -> void:
	player.UpdateAnimation("idle")
	pass

func Exit() -> void: 
	pass

func Process(_delta: float) -> State:
	if player.direction != Vector2.ZERO: #if the player is moving we go to walk state
		return walk
	
	player.velocity = Vector2.ZERO #constantly set velocity to zero because we are not moving
	
	if player.setDirection():
		player.UpdateAnimation("idle")
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State:
	if Input.is_action_pressed("dodge") and dodge.can_dash: #when dodge is pressed we dodge.
		return dodge 
	
	if Input.is_action_just_pressed("cast") and spell_manager.selected_spell > -1 and spell_manager.spell_fired == false: 
		if spell_manager.is_targeting: 
			spell_manager.stop_targeting()
		else:
			return casting
	
	return null
