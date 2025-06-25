extends CharacterBody2D
class_name testDummy

@export var stats: Stats

func _ready() -> void:
	SignalBus.connect("dead",Callable(self, "on_dead"))

func on_dead(nam: String) -> void:
	if get_tree().get_first_node_in_group("enemy").name == nam:
		velocity = Vector2.ZERO
		stats.isDead = true
		print("dead")
		#play death animation
		#queue_free()
	else:
		return

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass
