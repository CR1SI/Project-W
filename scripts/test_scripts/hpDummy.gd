extends Control
class_name ssss

@onready var dummy: testDummy = $".."

@onready var health: TextureProgressBar = %health


func _ready() -> void:
	health.max_value = dummy.stats.max_health
	
	health.value = dummy.stats.current_health
	
	SignalBus.connect("updateUi", Callable(self, "update"))
func update() -> void:
	health.value = dummy.stats.current_health
