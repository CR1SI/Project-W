class_name Player
extends CharacterBody2D

var mouse_position = null

@onready var state_machine: StateMachine = $StateMachine
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	state_machine.Initialize(self) #initialized statemachine, with self->(player) node
	pass

func _process(_delta: float) -> void:
	#calculating direciton x and y
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	pass

func _physics_process(delta: float) -> void:
	mouse_position = get_global_mouse_position() #keeps track of mouse position
	#check documentation
	move_and_slide()
