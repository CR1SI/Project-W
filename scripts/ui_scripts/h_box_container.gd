extends HBoxContainer

@onready var spell_holder: Control = $".."
var spells: Array

func _ready(): 
	spells = get_children()
	for i in get_child_count(): 
		spells[i].change_key = str(i+1)
		spells[i].input_spell = i+1
		#spells[i].texture = spell_holder.spell_manager.spell_scenes[selected].instantiate().icon need to make this work
