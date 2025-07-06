extends EnemyState
class_name EnemyRoamState

@onready var idle: EnemyIdleState = $"../idle"
@onready var chase: EnemyChaseState = $"../chase"
@onready var attack: EnemyAttackState = $"../attack"

var angle: float
var radius: float
var distan: float
var random_point: Vector2

func Enter() -> void:
	super.Enter()
	if NAV.roam_target == Vector2.ZERO:
		angle = randf_range(0, TAU)
		radius = NAV.radius_detector / 2
		distan = randf_range(NAV.stopping_distance * 1.5, radius)
		random_point = NAV.get_parent().global_position + Vector2(distan * cos(angle), distan * sin(angle))
		NAV.roam_target = random_point

func Exit() -> void:
	pass

func Process(_delta: float) -> EnemyState:
	if NAV.target != null:
		return chase
	return null

func Physics(_delta: float) -> EnemyState:
	if NAV.is_knockback_active or NAV.blind_active or NAV.fear_active:
		return null
	return null
