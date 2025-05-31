extends GridContainer
class_name spell_visual


@onready var spell_manager: SpellManager = $"../SpellManager"

func _ready() -> void:
	var textures: Array= get_children()
	
	for i in 4:
		textures[i].texture = spell_manager.active_bar[i].instantiate().data.icon
		textures[i].custom_minimum_size = Vector2(128,128)
		textures[i].expand_mode = TextureRect.EXPAND_FIT_WIDTH
		textures[i].stretch_mode = TextureRect.STRETCH_SCALE


func _process(delta: float) -> void:
	var textures: Array= get_children()
	
	for i in 4:
		textures[i].texture = spell_manager.active_bar[i].instantiate().data.icon
		textures[i].custom_minimum_size = Vector2(128,128)
		textures[i].expand_mode = TextureRect.EXPAND_FIT_WIDTH
		textures[i].stretch_mode = TextureRect.STRETCH_SCALE
