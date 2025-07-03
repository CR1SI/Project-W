extends Control
class_name HUD

@onready var player: Player = Nodes.player

#inv
@onready var spells: inventory = $CanvasLayer/inventory/spells
@onready var inv: PanelContainer = $CanvasLayer/inventory

#H&M info
@onready var health: TextureProgressBar = %health
@onready var mana: TextureProgressBar = %mana
@onready var info_spells: GridContainer = $CanvasLayer/info/VBoxContainer/infoSpells

#spells info
@onready var textures: Array= info_spells.get_children()

func _ready() -> void:
	SignalBus.connect("open_selector", _on_open)
	SignalBus.connect("updateUi",update)
	
	#H&M info
	health.max_value = player.stats.max_health
	mana.max_value = player.stats.max_mana
	health.value = player.stats.current_health
	mana.value = player.stats.mana
	
	#spell info
	
	for i in 4:
		textures[i].texture = player.spell_manager.active_bar[i].instantiate().data.icon
		textures[i].custom_minimum_size = Vector2(128,128)
		textures[i].expand_mode = TextureRect.EXPAND_FIT_WIDTH
		textures[i].stretch_mode = TextureRect.STRETCH_SCALE

func _process(_delta: float) -> void:
	
	for i in 4:
		textures[i].texture = player.spell_manager.active_bar[i].instantiate().data.icon
		textures[i].custom_minimum_size = Vector2(128,128)
		textures[i].expand_mode = TextureRect.EXPAND_FIT_WIDTH
		textures[i].stretch_mode = TextureRect.STRETCH_SCALE

func _on_open() -> void:
	if inv.visible:
		inv.visible = false
		get_tree().paused = false
	else:
		inv.visible = true
		get_tree().paused = true

func update() -> void:
	health.value = player.stats.current_health
	mana.value = player.stats.mana
