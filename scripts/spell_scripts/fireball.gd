class_name Fireball
extends base_script

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fire_spell()

func deal_damage(_dmg: int):  #overrides the dmg func in the base script
	pass
