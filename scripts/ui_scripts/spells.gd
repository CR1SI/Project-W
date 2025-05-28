extends Control
class_name inventory

@onready var spell_selector: GridContainer = $background/spell_selector
@onready var spell_manager: SpellManager = get_tree().get_first_node_in_group("player").get_node("SpellManager")


@onready var mana: Label = %mana
var manaAMOUNT: int = 0

var slots: Array = []
var active_spells: Array[spell_slot] = []
var extra_spells: Array[spell_slot] = []

var bar: Dictionary

func _ready() -> void:
	SignalBus.connect("open_selector", Callable(self, "_on_open"))
	bar = spell_manager.active_bar
	slots = spell_selector.get_children()
	
	for i: Panel in slots:
		if !i.get_name().begins_with("space"):
			i.slot_num = slots.find(i)
			i.connect("spell_dropped", Callable(self, "_on_spell_dropped"))
			var slot_name: String = i.get_name()
			if slot_name.begins_with("extra"):
				extra_spells.append(i)
			else:
				if slot_name.is_valid_int():
					active_spells.append(i)
	
	add_to_slot()
	
	#update manaNumber
	for i in active_spells:
		manaAMOUNT += int(i.mana.text)
	mana.text = "total mana: " + str(manaAMOUNT)

func add_to_slot() -> void:
	for spells: int in bar:
		var instance: Node = bar[spells].instantiate()
		var data: Spell = instance.data
		instance.queue_free()
		var assigned_to_active: bool = false
		#add to slot
		for slot in active_spells:
			if slot.data == null:
				slot.data = data
				assigned_to_active = true
				break #only exits loop
		#add to extra
		for slot in extra_spells:
			if slot.data == null and !assigned_to_active:
				slot.data = data
				break #only exits loop

func _on_spell_dropped(from: int, to: int) -> void:
	var from_slot: spell_slot = slots[from]
	var to_slot: spell_slot = slots[to]
	
	#swap ui
	var temp: Spell = to_slot.data
	to_slot.data = from_slot.data
	from_slot.data = temp
	
	#deal with extra slots
	if from_slot.name.begins_with("extra1"):
		from_slot.name = "5"
	elif from_slot.name.begins_with("extra2"):
		from_slot.name = "6"
	if to_slot.name.begins_with("extra1"):
		to_slot.name = "5"
	elif to_slot.name.begins_with("extra2"):
		to_slot.name = "6"
	
	#swap active_bar
	var temp_spell: PackedScene = spell_manager.active_bar[int(from_slot.name) - 1]
	spell_manager.active_bar[int(from_slot.name) - 1] = spell_manager.active_bar[int(to_slot.name) - 1]
	spell_manager.active_bar[int(to_slot.name) - 1] = temp_spell
	
	#update manaNumber
	manaAMOUNT = 0
	for i in active_spells:
		manaAMOUNT += int(i.mana.text)
	mana.text = "total mana: " + str(manaAMOUNT)


func _on_open() -> void:
	if visible:
		visible = false
	else:
		visible = true
