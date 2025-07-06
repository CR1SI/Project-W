extends EnemyState
class_name EnemyIdleState

@onready var roam: EnemyRoamState = $"../roam"
@onready var chase: EnemyChaseState = $"../chase"
@onready var attack: EnemyAttackState = $"../attack"

var roam_timer: Timer = Timer.new()
var enter_roam: bool = false

func _ready() -> void:
	add_child(roam_timer)
	roam_timer.one_shot = true
	roam_timer.timeout.connect(Exit)

func Enter() -> void:
	super.Enter()
	enter_roam = false
	roam_timer.start(3)

func Exit() -> void:
	enter_roam = true
	roam_timer.stop()

func Process(_delta: float) -> EnemyState:
	if NAV.target != null:
		return chase
	if enter_roam:
		return roam
	return null

func Physics(_delta: float) -> EnemyState:
	enemy.velocity = Vector2.ZERO
	return null
