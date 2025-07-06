extends EnemyState
class_name EnemyChaseState

var attack_range: float = 100.0
@onready var idle: EnemyIdleState = $"../idle"
@onready var roam: EnemyRoamState = $"../roam"
@onready var attack: EnemyAttackState = $"../attack"

func Enter() -> void:
	super.Enter()

func Exit() -> void:
	pass

func Process(_delta: float) -> EnemyState:
	if NAV.target == null:
		print("lost target")
		return idle
	
	var distance: float = enemy.global_position.distance_to(NAV.target.global_position)
	if distance <= attack_range:
		return attack
	return null

func Physics(_delta: float) -> EnemyState:
	if NAV.is_knockback_active or NAV.blind_active or NAV.fear_active:
		return null
	
	if NAV.nave.is_navigation_finished():
		enemy.velocity = Vector2.ZERO
		return idle
	
	return null
