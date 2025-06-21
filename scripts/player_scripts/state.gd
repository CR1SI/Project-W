class_name State
extends Node

static var player: Player

func _ready() -> void:
	SignalBus.connect("dead", on_dead)

func Enter() -> void: 
	pass

func Exit() -> void: 
	pass

func Process(_delta: float) -> State: 
	return null

func Physics(_delta: float) -> State: 
	return null

func Handle_Input(_event: InputEvent) -> State: 
	return null

#TODO make sure to set death logic for player
func on_dead(nam: String) -> void:
	if get_parent().get_parent().name == nam:
		player.velocity = Vector2.ZERO
		player.stats.isDead = true
		print("dead")
		#play death animation
		#queue_free()
	else:
		return
