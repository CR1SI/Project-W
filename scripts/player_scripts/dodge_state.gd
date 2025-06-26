class_name dodge_state
extends State

@onready var walk: walk_state = $"../walk"
@onready var idle: idle_state = $"../idle"
@onready var melee: melee_state = $"../melee"
@onready var casting: casting_state = $"../casting"
@onready var spell_manager: SpellManager = $"../../SpellManager"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"


@export var dash_speed: float = 1000.0 #this has to always be higher than the player_speed otherwise it will slow down instead. 
@export var dash_duration: float = 0.3 

var can_dash: bool = true

var timer: float = 0.0 #makeshift timer, you could use a timer node.


func Enter() -> void:
	if animation_player.current_animation == "idle_long_end_left" or animation_player.current_animation == "idle_long_end_right":
		await animation_player.animation_finished
	#player.UpdateAnimation("dodge")
	if can_dash:
		can_dash = false
		$Timer.start()
		#checking what direction to dodge while in idle
		var dash_direction: Vector2 = player.last_direction
		
		#checking where to dodge based on current walking vector
		if dash_direction != Vector2.ZERO: 
			player.velocity = dash_direction.normalized() * dash_speed
			timer = dash_duration
		else:
			pass

func Exit() -> void:
	player.velocity = Vector2.ZERO #when we exit we want set velocity to zero otherwise we maintain that speed.
	pass

func Process(delta: float) -> State:
	
	timer -= delta
	if timer <= 0.0:
		if player.direction != Vector2.ZERO: 
			return walk
		else: 
			return idle
	
	if player.setDirection():
		#TODO player.UpdateAnimation("dodge")
		pass
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State: 
	if Input.is_action_just_pressed("leftClick") and spell_manager.selected_spell > -1 and spell_manager.spell_fired == false: 
		if spell_manager.is_targeting: 
			spell_manager.stop_targeting()
		else:
			return casting
	
	if Input.is_action_just_pressed("leftClick") and spell_manager.selected_spell == -1:
		return melee
	
	return null


func _on_timer_timeout() -> void:
	can_dash = true
