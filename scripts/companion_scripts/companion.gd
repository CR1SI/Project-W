class_name Companion
extends CharacterBody2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var stats: Stats

@export var player: Player
var player_position: Vector2

#moving
var direction: Vector2 = Vector2.ZERO

enum States {
	IDLE, 
	FOLLOWING, 
	ATTACKING, 
	BUFFING,
	SPOTTED,
	DEAD
	}
var current_state: States = States.FOLLOWING
var previous_state: States

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
var buffNum: int = 8

func buffType(companion_type: int) -> void:
	match companion_type:
		0:
			buff = Buffs.HEALTH_BUFF
			print("-companion1- buff-health")
		1:
			buff = Buffs.STRENGTH_BUFF
			print("-companion2- buff-strength")
		2:
			buff = Buffs.DEFENSE_BUFF
			print("-companion3- buff-defense")
		3:
			buff = Buffs.MANA_RESTORE
			print("-companion4- mana restore")
		4:
			buff = Buffs.SPEED_BUFF
			print("-companion5- buff-speed")

func _ready() -> void:
	SignalBus.connect("companion_zone_entered", _on_companion_zone_entered)
	SignalBus.connect("companion_zone_exited", _on_companion_zone_exited)
	
	buffType(stats.companion)
	
	if stats.on_head:
		stats.speed = 0
		stats.acceleration = 0
		switch_state(States.IDLE)


func _physics_process(_delta: float) -> void:
	if stats.on_head:
		global_position = player_position + Vector2(0,-35)
	move_and_slide()


func _process(_delta: float) -> void:
	if player.stats.isDead:
		switch_state(States.DEAD)
	else:
		player_position = player.global_position
	
	if enemyFound and current_state != States.ATTACKING and stats.attackingCompanion:
			switch_state(States.ATTACKING)
	elif shouldBuff and current_state != States.BUFFING:
			switch_state(States.BUFFING)

func switcher(state: States, _d: float) -> void:
	match state:
		States.IDLE:
			idle()
		States.FOLLOWING:
			following(_d)
		States.ATTACKING:
			attacking()
		States.BUFFING:
			buffing()
		States.DEAD:
			dead()
		States.SPOTTED:
			spotted()


#TODO add animation logic for each state here with a match statements
#region state functions

func idle() -> void:
	animation_player.play("idle")
	direction = Vector2.ZERO
	velocity = velocity.lerp(Vector2.ZERO, 0.5)

func following(_delta: float) -> void:
	direction = player_position - global_position
	velocity = velocity.lerp((direction).normalized() * stats.speed, stats.acceleration * _delta)

func attacking() -> void:
	#direction to target
	pass

func buffing() -> void:
	animation_player.play("buffing")
	await animation_player.animation_finished
	direction = Vector2.ZERO
	velocity = velocity.lerp(Vector2.ZERO, 0.2)
	
	match buff:
		Buffs.HEALTH_BUFF:
			player.stats.healthBUFF += 250
		Buffs.STRENGTH_BUFF:
			player.stats.strengthBUFF += 10
		Buffs.DEFENSE_BUFF:
			player.stats.defenseBUFF += 15
		Buffs.MANA_RESTORE:
			player.stats.mana = player.stats.max_mana
		Buffs.SPEED_BUFF:
			player.stats.speed += 50
	
	shouldBuff = false #resetting flag
	SignalBus.emit_signal("updateUi")
	switch_state(States.IDLE)

func spotted() -> void:
	if previous_state == States.SPOTTED:
		switch_state(States.IDLE)
	else:
		animation_player.play("enemy_spotted")
		await animation_player.animation_finished
		if randi_range(7, 9) == buffNum: #IMPORTANT make a new way to activate debuffs
			shouldBuff = true
		switch_state(previous_state)

func dead() -> void:
	#TODO play despawn animation
	queue_free()

#endregion

func _on_companion_zone_entered() -> void:
	playerNear = true
	switch_state(States.IDLE)
func _on_companion_zone_exited() -> void:
	playerNear = false
	switch_state(States.FOLLOWING)

func switch_state(future_state: States) -> void:
	previous_state = current_state
	current_state = future_state
	switcher(current_state, get_process_delta_time())

func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		switch_state(States.SPOTTED)
