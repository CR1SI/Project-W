class_name dodge_state
extends State

@onready var walk: walk_state = $"../walk"
@onready var idle: idle_state = $"../idle"
@onready var melee: melee_state = $"../melee"
@onready var casting: casting_state = $"../casting"


@export var dash_speed: float = 1000.0 #this has to always be higher than the player_speed otherwise it will slow down instead. 
@export var dash_duration: float = 0.3 

var can_dash: bool = true

var timer: float = 0.0 #makeshift timer, you could use a timer node.


func Enter() -> void:
	player.UpdateAnimation("dodge")
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

func Process(_delta: float) -> State:
	
	timer -= _delta #_delta is essentially each frame. so it can work as good precise timer but not a lot of flexibility.
	#if timer reaches 0 and we are moving go to walk otherwise go to idle. 
	if timer <= 0.0:
		if player.direction != Vector2.ZERO: 
			return walk
		else: 
			return idle
	
	if player.setDirection():
		player.UpdateAnimation("dodge")
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State: 
	return null


func _on_timer_timeout() -> void:
	can_dash = true
