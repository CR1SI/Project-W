class_name Player
extends CharacterBody2D

@export var stats: Stats

var mouse_position: Vector2 = Vector2.ZERO

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

func _process(_delta: float) -> void:
	#calculating direciton x and y
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if Input.is_action_just_pressed("spell1"):
		SignalBus.emit_signal("spell_selected", 1)
	if Input.is_action_just_pressed("spell2"):
		SignalBus.emit_signal("spell_selected", 2)
	if Input.is_action_just_pressed("spell3"):
		SignalBus.emit_signal("spell_selected", 3)
	if Input.is_action_just_pressed("spell4"):
		SignalBus.emit_signal("spell_selected", 4)
	
	if Input.is_action_just_pressed("inv"):
		SignalBus.emit_signal("open_selector")
	
	mouse_position = get_global_mouse_position()


func _physics_process(_delta: float) -> void:
	move_and_slide() #move


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
	if state != "idle_long":
		animation_player.play( state + "_" + AnimDirection())
	elif state == "idle_long":
		animation_player.play( state + "_" + "start_" + AnimDirection())
		await animation_player.animation_finished
		animation_player.play( state + "_" + AnimDirection())
	elif state == "idle_long_end":
		animation_player.play( state + "_" + AnimDirection())

func AnimDirection() -> String: 
	if cardinal_direction == Vector2.DOWN: 
		return "down"
	elif cardinal_direction == Vector2.UP: 
		return "up"
	elif cardinal_direction == Vector2.RIGHT: 
		return "right"
	else:
		return "left"
