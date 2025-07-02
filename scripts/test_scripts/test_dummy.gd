extends CharacterBody2D
class_name testDummy

@export var stats: Stats

func _ready() -> void:
	SignalBus.dead.connect(on_dead)

func on_dead(nam: String) -> void:
	if self.name == nam:
		velocity = Vector2.ZERO
		stats.isDead = true
		#play death animation
		queue_free()
	else:
		return

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass
