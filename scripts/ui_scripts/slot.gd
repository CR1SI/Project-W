class_name spell_slot
extends Panel

@export var data: Spell :
	set(value):
		data = value
		update_ui()

@onready var texture_rect: TextureRect = $TextureRect
@onready var mana: Label = %mana

var slot_num: int #tracks which slot it is in inventory

func _ready() -> void:
	update_ui()

func update_ui() -> void:
	if data:
		texture_rect.texture = data.icon
		texture_rect.tooltip_text = data.name
		mana.text = str(data.mana_cost)
	else:
		texture_rect.texture = null
		texture_rect.tooltip_text = ""
		mana.text = ""
		return

func _get_drag_data(_at_position: Vector2) -> Variant:
	if data:
		var drag_data: Dictionary = {
			"spell": data,
			"slot_index": slot_num
		}
		var preview: TextureRect = TextureRect.new()
		preview.texture = data.icon
		preview.custom_minimum_size = Vector2(32,32)
		preview.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		preview.stretch_mode = TextureRect.STRETCH_SCALE
		set_drag_preview(preview)
		return drag_data
	return null

func _can_drop_data(_at_position: Vector2, d_data: Variant) -> bool:
	#accept it, if it has spell resource
	return d_data is Dictionary and d_data.has("spell") and d_data["spell"] is Spell

func _drop_data(_at_position: Vector2, d_data: Variant) -> void:
	var _dragged_spell: Spell = d_data["spell"]
	var dragged_slot_num: int = d_data["slot_index"]
	#emit signal to swap items in inventory #emit signal to swap items in active_bar
	emit_signal("spell_dropped", dragged_slot_num, slot_num)

func update_slot(new_spell: Spell) -> void:
	data = new_spell
	update_ui()

signal spell_dropped(from_index: int, to_index: int)
