extends Slot
class_name Spell_slot
#TODO FIX THI BUG WHERE IT SWAPS BETWEEN SPELLS
@onready var spell_manager: SpellManager = $/root/test_scene/Player/SpellManager


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is TextureRect and data.slot_type == slot_type


func _drop_data(at_position: Vector2, data: Variant) -> void:
	
	var dragged_slot = data.get_parent()
	if not dragged_slot is Spell_slot:
		print("Error: Dragged slot is not a Spell_slot")
		return
	
	
	# Swap properties
	var temp = texture_rect.property
	texture_rect.property = dragged_slot.texture_rect.property
	dragged_slot.texture_rect.property = temp
	
	# Update active_bar if this slot is in the first four slots
	var slot_index = get_index()
	var dragged_slot_index = dragged_slot.get_index()
	
	# Update current slot's active_bar entry if in first four
	if slot_index < 4:
		var new_spell_type = texture_rect.property["SPELL_TYPE"]
		if new_spell_type in spell_manager.spell_scenes:
			spell_manager.active_bar[slot_index] = spell_manager.spell_scenes[new_spell_type]
		else:
			print("Error: Invalid SPELL_TYPE for current slot: ", new_spell_type)
	
	# Update dragged slot's active_bar entry if in first four
	if dragged_slot_index < 4:
		var dragged_spell_type = dragged_slot.texture_rect.property["SPELL_TYPE"]
		if dragged_spell_type in spell_manager.spell_scenes:
			spell_manager.active_bar[dragged_slot_index] = spell_manager.spell_scenes[dragged_spell_type]
		else:
			print("Error: Invalid SPELL_TYPE for dragged slot: ", dragged_spell_type)
	
	# Recalculate mana
	var parent = get_parent()
	if parent is Control:
		parent.calc()
