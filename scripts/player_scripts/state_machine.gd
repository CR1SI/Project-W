class_name StateMachine
extends Node

@onready var spell_manager: SpellManager = $"../SpellManager"

var states: Array[State]
var prev_state: State
var current_state: State

#called when node is first added to scene
func _ready(): 
	process_mode = Node.PROCESS_MODE_DISABLED
	
	pass

#used to handle state transition and processing
func _process(delta: float) -> void:
	ChangeState(current_state.Process(delta)) #these allow us to connect these functions to the ones in each state.(same functions)
	
		#to test
	if Input.is_action_just_pressed("spell1"):
		spell_manager.select_spell(1)
	if Input.is_action_just_pressed("spell2"):
		spell_manager.select_spell(2)
	if Input.is_action_just_pressed("spell3"):
		spell_manager.select_spell(3)
	if Input.is_action_just_pressed("spell4"):
		spell_manager.select_spell(4)
		
	pass

#physics process
func _physics_process(delta: float) -> void:
	ChangeState(current_state.Physics(delta))
	pass

#initializes the state machine with the player and gathers all state nodes with for loop.
func Initialize(_player: Player) -> void: 
	states = []
	
	for s in get_children():
		if s is State: 
			states.append(s)
	
	if states.size() > 0:
		states[0].player = _player
		ChangeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT


func ChangeState(new_state: State) -> void:
	if new_state == null || new_state == current_state: 
		return
	
	if current_state: #if we are in a state calls exit function.
		current_state.Exit()
	
	prev_state = current_state
	current_state = new_state
	current_state.Enter() #calls enter on our new current state
	

func _unhandled_input(event: InputEvent) -> void:
	ChangeState(current_state.Handle_Input(event))
	pass
