extends HBoxContainer

@onready var spell_manager: SpellManager = $"../../../SpellManager"
var spells: Array

func _ready(): 
	spell_manager.populate_actives()
	spells = get_children()
	
	for i in get_child_count(): 
		spells[i].change_key = str(i+1)
		spells[i].input_spell = i+1
		spells[i].set_texture_normal(spell_manager.active_spells[i].icon)

func _process(_delta) -> void:
	pass
