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

func cast_spell(spell: SpellType): 
	if spell in spell_scenes: 
		var spell_scene = spell_scenes[spell]
		var spell_instance = spell_scene.instantiate()
		spell_instance.position = player.position
		add_child(spell_instance)

func select_spell(spell_index: int): 
	match spell_index: 
		0: 
			selected_spell = SpellType.FIREBALL
