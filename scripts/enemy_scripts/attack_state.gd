extends EnemyState
class_name EnemyAttackState

@onready var chase: EnemyChaseState = $"../chase"
@onready var roam: EnemyRoamState = $"../roam"
@onready var idle: EnemyIdleState = $"../idle"

var attack_cooldown: bool = false

func Enter() -> void:
	super.Enter()
	#TODO att animation
	#TODO start att cooldown timer

func Exit() -> void:
	pass

func Process(_delta: float) -> EnemyState:
	if attack_cooldown:
		return chase
	
	if NAV.target != null:
		return chase
	return null

func Physics(_delta: float) -> EnemyState:
	enemy.velocity = Vector2.ZERO
	return null
