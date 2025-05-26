extends TextureRect

@export var slot_type: int = 0

@export var MANA = 0:
	set(value):
		MANA = value
		%debug.text = str(MANA)
		
		if get_parent() is Spell_slot:
			get_parent().get_parent().calc()

@onready var property: Dictionary = {"TEXTURE": texture, "MANA": MANA, "SLOT_TYPE": slot_type}:
	set(value):
		property = value
		texture = property["TEXTURE"]
		MANA = property["MANA"]
		slot_type = property["SLOT_TYPE"]
