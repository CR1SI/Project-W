extends CharacterBody2D
class_name testDummy

@export var stats: Stats
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

func _ready() -> void:
	SignalBus.dead.connect(on_dead)
	state_machine.initialize(self)
	state_machine.ChangeState(state_machine.get_node("idle"))

func _process(_delta: float) -> void:
	state_machine._process(_delta)

func _physics_process(_delta: float) -> void:
	state_machine._physics_process(_delta)


func on_dead(nam: String) -> void:
	if self.name == nam:
		velocity = Vector2.ZERO
		stats.isDead = true
		#play death animation
		queue_free()
