extends Node
class_name EnemyState

var enemy: CharacterBody2D
var NAV: nav

func Enter() -> void:
	NAV = enemy.get_node("NAV")
	pass

func Exit() -> void:
	pass

func Process(_delta: float) -> EnemyState:
	return null

func Physics(_delta: float) -> EnemyState:
	return null
