extends Node2D
class_name effects

func _ready() -> void:
	SignalBus.do_hitstop.connect(hitstop)
	SignalBus.do_screen_shake.connect(screen_shake)

func hitstop() -> void:
	Engine.time_scale = 0
	await get_tree().create_timer(0.15, false, false, true).timeout
	Engine.time_scale = 1.0

func screen_shake() -> void:
	pass
