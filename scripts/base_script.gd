class_name base_script
extends Area2D

@export var resource: Spell

var spell_fired: bool = false

func _ready():
	pass

func _process(delta: float) -> void:
	if spell_fired:
		position += transform.x * resource.spell_speed * delta

func fire_spell():
	spell_fired = true
