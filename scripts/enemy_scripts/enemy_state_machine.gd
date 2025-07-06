extends Node
class_name EnemyStateMachine

var states: Array[EnemyState]
var current_state: EnemyState
var previous_state: EnemyState
@onready var enemy: CharacterBody2D = get_parent()
@onready var state_label: Label = $"../debug_HP_MANA/VBoxContainer/state"

func initialize(enemy_node: CharacterBody2D) -> void:
	enemy = enemy_node
	
	for child in get_children():
		if child is EnemyState:
			states.append(child)
			child.enemy = enemy
	
	if states.size() > 0:
		current_state = states[0]
		current_state.Enter()
		update_state()

func _process(delta: float) -> void:
	var new_state: EnemyState = current_state.Process(delta)
	if new_state:
		ChangeState(new_state)

func _physics_process(delta: float) -> void:
	var new_state: EnemyState = current_state.Physics(delta)
	if new_state:
		ChangeState(new_state)

func ChangeState(new_state: EnemyState) -> void:
	if new_state == current_state:
		return
	
	current_state.Exit()
	previous_state = current_state
	current_state = new_state
	current_state.Enter()
	update_state()

func update_state() -> void:
	if state_label:
		state_label.text = "State: " + current_state.name
