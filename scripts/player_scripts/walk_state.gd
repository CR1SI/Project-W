class_name walk_state
extends State

@onready var idle: idle_state = $"../idle"
@onready var dodge: dodge_state = $"../dodge"
@onready var melee: melee_state = $"../melee"
@onready var casting: casting_state = $"../casting"

@onready var spell_manager: SpellManager = $"../../SpellManager"
@onready var animation: AnimationPlayer = $"../../AnimationPlayer"

func Enter() -> void:
	if Input.is_action_just_pressed("right"): 
		animation.play("walk_right")
	elif Input.is_action_just_pressed("left"): 
		animation.play("walk_left")
	pass

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO: #if we stop walking/no direction we return idle.
		return idle
	
	player.velocity = player.velocity.lerp((player.direction).normalized() * player.stats.speed, player.stats.acceleration * _delta) #.normalized allows for the diagnoal velocity to be equal to the horizontal and vertical. 
	player.last_direction = player.direction
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State:
	if Input.is_action_pressed("dodge") and dodge.can_dash: 
		return dodge
	
	if Input.is_action_just_pressed("cast") and spell_manager.selected_spell > -1 and spell_manager.spell_fired == false: 
		if spell_manager.is_targeting: 
			spell_manager.stop_targeting()
		else:
			return casting
	
	return null
