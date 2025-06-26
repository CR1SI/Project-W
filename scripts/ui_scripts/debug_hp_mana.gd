extends Control
class_name debugHP_MANA

@onready var player: Player = $".."

@onready var health: TextureProgressBar = %health
@onready var mana: TextureProgressBar = %mana


func _ready() -> void:
	health.max_value = player.stats.max_health
	mana.max_value = player.stats.max_mana
	
	health.value = player.stats.current_health
	mana.value = player.stats.mana
	
	SignalBus.connect("updateUi",update)
	


func update() -> void:
	health.value = player.stats.current_health
	mana.value = player.stats.mana
