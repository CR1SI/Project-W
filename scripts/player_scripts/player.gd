class_name Player
extends CharacterBody2D

@export var stats: Stats

var mouse_position: Vector2 = Vector2.ZERO

@onready var footsteps: PackedScene = preload("res://scenes/player_related/foot_steps.tscn")
var steps: Node
var stepTimer: Timer

@onready var spell_manager: SpellManager = $SpellManager
@onready var state_machine: StateMachine = $StateMachine
@onready var idle: State = $StateMachine/idle
@onready var walk: State = $StateMachine/walk
@onready var dodge: State = $StateMachine/dodge
@onready var melee: State = $StateMachine/melee
@onready var casting: State = $StateMachine/casting


var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.ZERO
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]


func _ready() -> void:
	state_machine.Initialize(self) #initialized statemachine, with self->(player) node
	
	stepTimer = Timer.new()
	stepTimer.wait_time = 0.5
	stepTimer.autostart = true
	stepTimer.connect("timeout", footStepMaker)
	add_child(stepTimer)

func _process(_delta: float) -> void:
	#calculating direciton x and y
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	mouse_position = get_global_mouse_position()


func _physics_process(_delta: float) -> void:
	move_and_slide()


func setDirection() -> bool:
	if direction == Vector2.ZERO: 
		return false
	
	var direction_id: int = int( round( ( direction ).angle() / TAU * DIR_4.size() ) )
	var new_dir: Vector2 = DIR_4 [ direction_id ]
	
	if new_dir == cardinal_direction: 
		return false
	
	cardinal_direction = new_dir
	return true

func UpdateAnimation(state: String) -> void:
	var dir: String = AnimDirection()
	
	if state != "idle_long" and state != "idle_long_end":
		animation_player.play( state + "_" + dir)
	elif state == "idle_long":
		animation_player.play( state + "_" + "start_" + dir)
		await animation_player.animation_finished
		animation_player.play( state + "_" + dir)
	elif state == "idle_long_end":
		animation_player.play( state + "_" + dir)

func AnimDirection() -> String: 
	if cardinal_direction == Vector2.DOWN: 
		return "down"
	elif cardinal_direction == Vector2.UP: 
		return "up"
	elif cardinal_direction == Vector2.RIGHT: 
		return "right"
	else:
		return "left"


#TODO Fine tune footsteps!
func footStepMaker() -> void:
	var new_steps: Node = footsteps.instantiate()
	new_steps.position = global_position
	new_steps.position.y = new_steps.position.y + 32
	
	get_parent().add_child(new_steps)
