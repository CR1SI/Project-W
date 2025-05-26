class_name Companion
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D #sprite sheet for whichever companion
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var stats: Stats

var player: Player
var player_position: Vector2

#moving
var direction: Vector2 = Vector2.ZERO

enum States {
	IDLE, 
	FOLLOWING, 
	ATTACKING, 
	BUFFING}
var current_state = States.FOLLOWING
var previous_state

enum Buffs{
	STRENGTH_BUFF,
	DEFENSE_BUFF,
	MANA_RESTORE,
	HEALTH_BUFF,
	SPEED_BUFF
}
var buff: Buffs

#events
var enemyFound: bool = false
var playerNear: bool = false
var shouldBuff: bool = false #could have a lot of dependencies when you consider why it should buff

func buffType(companion_type):
	match companion_type:
		0:
			buff = Buffs.HEALTH_BUFF
			print("-companion1- buff")
		1:
			buff = Buffs.STRENGTH_BUFF
			print("-companion2- buff")
		2:
			buff = Buffs.DEFENSE_BUFF
			print("-companion3- buff")
		3:
			buff = Buffs.MANA_RESTORE
			print("-companion4- buff")
		4:
			buff = Buffs.SPEED_BUFF
			print("-companion5- buff")

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	SignalBus.connect("companion_zone_entered", Callable(self, "_on_companion_zone_entered"))
	SignalBus.connect("companion_zone_exited", Callable(self, "_on_companion_zone_exited"))
	
	buffType(stats.companion)


func _physics_process(_delta: float) -> void:
	if enemyFound and current_state != States.ATTACKING and stats.attackingCompanion:
		switch_state(States.ATTACKING)
	elif shouldBuff and current_state != States.BUFFING:
		switch_state(States.BUFFING)
	else:
		switcher(current_state, _delta)
	move_and_slide()


func _process(_delta: float) -> void:
	player_position = player.global_position

func switcher(state: States, _d: float):
	match state:
		States.IDLE:
			idle()
		States.FOLLOWING:
			following(_d)
		States.ATTACKING:
			attacking()
		States.BUFFING:
			buffing()

#state functions
func idle():
	direction = Vector2.ZERO
	velocity = velocity.lerp(Vector2.ZERO, 0.2)

func following(_delta: float):
	direction = player_position - global_position
	velocity = velocity.lerp((direction).normalized() * stats.speed, stats.acceleration * _delta)

func attacking():
	#direction to target
	pass

func buffing():
	direction = Vector2.ZERO
	velocity = velocity.lerp(Vector2.ZERO, 0.2)
	
	match buff: #TODO make these fair
		Buffs.HEALTH_BUFF:
			player.stats.health += 25 
		Buffs.STRENGTH_BUFF:
			player.stats.strength += 10
		Buffs.DEFENSE_BUFF:
			player.stats.defense += 15
		Buffs.MANA_RESTORE:
			player.stats.mana = player.stats.max_mana
		Buffs.SPEED_BUFF:
			player.stats.speed += 50
	
	shouldBuff = false #resetting flag
	switch_state(previous_state)

func _on_companion_zone_entered():
	playerNear = true
	switch_state(States.IDLE)
func _on_companion_zone_exited():
	playerNear = false
	switch_state(States.FOLLOWING)

func switch_state(future_state: States):
	#TODO add animation logic for each state here with a match statements
	previous_state = current_state
	current_state = future_state
