extends HBoxContainer

var spells: Array

func _ready(): 
	spells = get_children()
	for i in get_child_count(): 
		spells[i].change_key = str(i+1)
		spells[i].input_spell = i+1
