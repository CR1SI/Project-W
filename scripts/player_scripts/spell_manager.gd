class_name SpellManager
extends Node

@onready var player: Player = $".."

enum SpellType { 
	FIREBALL
}

var spell_scenes = { 
	SpellType.FIREBALL : preload("res://scenes/spells/fireball.tscn")
}

var selected_spell: SpellType = -1
var spell_fired: bool = false

func _process(_delta: float) -> void:
	pass

func cast_spell(spell: SpellType, position: Vector2): 
	if spell in spell_scenes: 
		var spell_scene = spell_scenes[spell]
		var spell_instance = spell_scene.instantiate()
		spell_instance.position = position
		
		add_child(spell_instance)
		spell_fired = true
		
		#check for cooldown!
		if spell_fired and selected_spell > -1:  
			await get_tree().create_timer(spell_scenes[selected_spell].instantiate().resource.cooldown).timeout
			spell_fired = false

func select_spell(spell_index: int): 
	match spell_index: 
		0: 
			selected_spell = SpellType.FIREBALL

#func _on_spell_collision(spell_a, spell_b):
	## Logic to combine spells upon collision
	#var combined_spell_type = get_combined_spell_type(spell_a, spell_b)
	#if combined_spell_type:
		## Remove the old spells and cast a new combined spell
		#spell_a.queue_free()
		#spell_b.queue_free()
		#cast_spell(combined_spell_type, spell_a.position)
#
#func get_combined_spell_type(spell_a, spell_b):
	## combination rules here and return the new type if any
	#if spell_a.resource.type == SpellType.FIREBALL and spell_b.resource.type == SpellType.FIREBALL:
		#return SpellType.FIREBALL # Example, could be a new spell type like FIREBALL_COMBO
	#return null
