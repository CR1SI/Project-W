extends Control

@onready var mana: Label = %MANA

#reference for spellmanager
@onready var spell_manager: SpellManager = $/root/test_scene/Player/SpellManager

func _ready() -> void:
	var spell_slots = get_children().filter(func(child): return child is Spell_slot)
	
	# Populate first four slots with active_bar spells
	var active_bar_keys = spell_manager.active_bar.keys()
	var active_spell_count = min(4, spell_slots.size(), active_bar_keys.size())
	for i in active_spell_count:
		var spell_type = spell_manager.active_bar.find_key(spell_manager.active_bar[i])
		var spell_scene = spell_manager.active_bar[i]
		var spell_instance = spell_scene.instantiate()
		var spell_resource = spell_instance.resource
		
		var slot = spell_slots[i]
		var texture_rect = slot.get_node("TextureRect")
		
		# Use resource properties if available, else temp_spell_data
		var texture = spell_resource.icon
		var mana_cost = spell_resource.mana_cost
		
		texture_rect.property = {
			"TEXTURE": texture,
			"MANA": mana_cost,
			"SLOT_TYPE": 1,
			"SPELL_TYPE": spell_type
		}
		
		spell_instance.queue_free()
	
	# Populate last two slots with remaining spells (STONEFIST, LIGHTBEAM)
	var remaining_spells = spell_manager.spell_scenes.keys().filter(func(spell_type): return not spell_manager.active_bar.values().has(spell_manager.spell_scenes[spell_type]))
	var remaining_spell_count = min(spell_slots.size() - active_spell_count, remaining_spells.size())
	for i in remaining_spell_count:
		var spell_type = remaining_spells[i]
		var spell_scene = spell_manager.spell_scenes[spell_type]
		var spell_instance = spell_scene.instantiate()
		var spell_resource = spell_instance.resource
		
		var slot = spell_slots[active_spell_count + i]
		var texture_rect = slot.get_node("TextureRect")
		
		var texture = spell_resource.icon
		var mana_cost = spell_resource.mana_cost
		
		texture_rect.property = {
			"TEXTURE": texture,
			"MANA": mana_cost,
			"SLOT_TYPE": 1,
			"SPELL_TYPE": spell_type
		}
		
		spell_instance.queue_free()
	
	# Calculate initial mana total
	calc()


func calc():
	var sum = 0
	
	for i in get_children():
		if i.get_index() < 4:
			sum+=i.get_MANA()
			print(sum)
			mana.text = "total mana: "+str(sum)
