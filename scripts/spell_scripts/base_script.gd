class_name base_script
extends Area2D

@export var resource: Spell

var direction: Vector2 = Vector2.ZERO
var spell_fired: bool = false

func _ready():
	add_to_group("spells")
	pass

func _process(delta: float) -> void:
	if spell_fired:
		position += direction * resource.spell_speed * delta

func fire_spell():
	direction = (get_global_mouse_position() - global_position).normalized()
	spell_fired = true

func deal_damage(_dmg: int): 	#deal dmg stuff here
	pass
