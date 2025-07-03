extends Node


@warning_ignore("unused_signal")
signal spell_collided(spell1: Area2D, spell2: Area2D)

@warning_ignore("unused_signal")
signal spell_fired

@warning_ignore("unused_signal")
signal spell_selected

@warning_ignore("unused_signal")
signal companion_zone_entered
@warning_ignore("unused_signal")
signal companion_zone_exited

@warning_ignore("unused_signal")
signal spell_dropped(from_index: int, to_index: int)

@warning_ignore("unused_signal")
signal open_selector

@warning_ignore("unused_signal")
signal apply_dmg_and_debuff

@warning_ignore("unused_signal")
signal dmg_debuff_applied

@warning_ignore("unused_signal")
signal dead

#ui
@warning_ignore("unused_signal")
signal updateUi

#effects!
@warning_ignore("unused_signal")
signal do_hitstop

@warning_ignore("unused_signal")
signal do_screen_shake

@warning_ignore("unused_signal")
signal knockback

@warning_ignore("unused_signal")
signal pull_inside

func _ready() -> void:
	self.process_mode = PROCESS_MODE_ALWAYS

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("inv"):
		SignalBus.emit_signal("open_selector")
	
	if Input.is_action_just_pressed("spell1"):
		SignalBus.emit_signal("spell_selected", 1)
	if Input.is_action_just_pressed("spell2"):
		SignalBus.emit_signal("spell_selected", 2)
	if Input.is_action_just_pressed("spell3"):
		SignalBus.emit_signal("spell_selected", 3)
	if Input.is_action_just_pressed("spell4"):
		SignalBus.emit_signal("spell_selected", 4)
